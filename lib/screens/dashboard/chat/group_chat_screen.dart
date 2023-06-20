import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../global/PrefKeys.dart';
import '../../../global/config.dart';
import '../../../global/global.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../model/chat_msg_model.dart';
import 'chat_details_screen.dart';
import 'custom_ui/own_msg_card.dart';
import 'custom_ui/reply_card.dart';

class GroupChatScreen extends StatefulWidget {
  final String? to_user_id;
  final String? to_user_name;
  final String? img;
  final IO.Socket? socket;

  const GroupChatScreen(
      {Key? key, this.to_user_id, this.to_user_name, this.img, this.socket})
      : super(key: key);

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  String? from_user_id;
  String? from_user_name;

  bool show = false;
  FocusNode focusNode = FocusNode();
  bool sendButton = false;

  TextEditingController _dataController = TextEditingController();

  ChatMessageModel? chatMessageModel;

  List<ChatMessageModel> chatMessages = [];
  List<ChatMessageModel> tempOldChatMessages = [];

  var nextPageUrl;
  var loadCompleted = false;
  var firstTimeLoad = true;
  ScrollController _scrollControllerGroup = new ScrollController();

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFileList;
  String? imageBase64 = "";
  File? imageFile;
  String? _fileName = "";
  int? offset = 0;
  int? limit = 10;
  int initialCount = 0;
  var screenHeight =
      (window.physicalSize.longestSide / window.devicePixelRatio);

  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : value;
    _fileName = _imageFileList!.name;
    imageBase64 = FileConverter.getBase64FormateFile(_imageFileList!.path);
    _sendMessageImage();
    debugPrint("imageBase64>>" + imageBase64!);
  }

  Future<void> _imgFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: null,
      maxHeight: null,
      imageQuality: 10,
    );

    setState(() {
      _setImageFileListFromFile(pickedFile);
    });
  }

  /// Get from gallery
  Future<void> _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 10,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        _fileName = imageFile!.path.split('/').last;
        imageBase64 =
            FileConverter.getBase64FormateFile(imageFile!.path.toString());
        _sendMessageImage();

        debugPrint("imageBase64>>" + imageBase64!);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    from_user_id = PrefObj.preferences!.get(PrefKeys.USER_ID).toString();
    _receiveMessageGroup();
    _getOldChatMessageGroup();
    _oldChatReceiveMessageGroup();
    individualChatListScrollDataView();
  }

  @override
  void dispose() {
    _scrollControllerGroup.dispose();
    //  widget.socket!.onDisconnect((_) => print('disconnect'));
    super.dispose();
  }

/*  void chatTextFocusNodeListener() {
    focusNode.addListener(() {
      _scrollControllerGroup.animateTo(
        _scrollControllerGroup.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 200,
        ),
        curve: Curves.easeInOut,
      );
    });
  }*/

  void individualChatListScrollDataView() {
    _scrollControllerGroup.addListener(
      () {
        if (_scrollControllerGroup.position.pixels ==
            _scrollControllerGroup.position.maxScrollExtent) {
          print('reach to top');
          setState(() {
            _getOldChatMessageGroup();
          });
        }
      },
    );
  }

  _sendMessageImage() {
    widget.socket!.emit('send_group_message', {
      json.encode({
        'group_id': widget.to_user_id.toString(),
        'sender_id': from_user_id,
        'content': "data:image/jpeg;base64," + imageBase64!,
        'type': 'image'
      })
    });
    imageBase64 = "";
    _dataController.clear();
  }

  _sendMessageText() {
    firstTimeLoad = false;
    widget.socket!.emit('send_group_message', {
      json.encode({
        'group_id': widget.to_user_id.toString(),
        'sender_id': from_user_id,
        'content': _dataController.text.trim(),
        'type': 'text'
      })
    });

    _dataController.clear();
  }

  _getOldChatMessageGroup() {
    offset = initialCount + offset!;

    if (screenHeight > 500 && screenHeight < 600) {
      initialCount = 6;
    } else if (screenHeight > 601 && screenHeight < 700) {
      initialCount = 7;
    } else if (screenHeight > 701 && screenHeight < 800) {
      initialCount = 8;
    } else if (screenHeight > 801 && screenHeight < 900) {
      initialCount = 10;
    } else if (screenHeight > 901 && screenHeight < 1000) {
      initialCount = 10;
    } else if (screenHeight > 1001 && screenHeight < 1100) {
      initialCount = 11;
    } else {
      initialCount = 12;
    }

    limit = initialCount;

    print("Offset==> " + offset.toString());
    print("limit==> " + limit.toString());

    widget.socket!.emit('get_group_old_chat_message', {
      json.encode({
        'group_id': widget.to_user_id.toString(),
        'offset': offset,
        'limit': limit
      })
    });
  }

  _oldChatReceiveMessageGroup() {
    widget.socket!.on('group_old_chat_receive_message', (eventData) {
      List jsonResponse = json.decode(eventData);
      chatMessages.addAll(jsonResponse
          .map((job) => new ChatMessageModel.fromJson(job))
          .toList());
    });
  }

  _receiveMessageGroup() {
    widget.socket!.on('receive_group_message', (eventData) {
      var msg = json.decode(eventData)['content'];
      var senderChatID = json.decode(eventData)['sender_id'];
      var receiverChatID = json.decode(eventData)['group_id'];
      var name_en = json.decode(eventData)['name_en'];
      var created_at = json.decode(eventData)['created_at'];
      var type = json.decode(eventData)['type'];
      var is_sent_by_system = json.decode(eventData)['is_sent_by_system'];
      var is_redirect = json.decode(eventData)['is_redirect'];
      var polling_id = json.decode(eventData)['polling_id'];

      print('receive_message: ${msg}');
      print('receive_message: ${senderChatID}');
      print('receiver_id: ${receiverChatID}');
      print('receive_message_name_en: ${name_en}');
      print('receive_message_created_at: ${created_at}');
      print('is_sent_by_system: ${is_sent_by_system}');
      print('is_redirect: ${is_redirect}');

      if (receiverChatID.toString() == widget.to_user_id.toString()) {
        chatMessages.insert(
            0,
            new ChatMessageModel(
                id: "",
                created_at: created_at,
                sender_id: senderChatID,
                receiver_id: receiverChatID,
                seen: "",
                content: msg,
                type: type,
                name_en: name_en,
                name_fr: "",
                is_redirect: is_redirect,
                is_sent_by_system: is_sent_by_system,
                polling_id: polling_id));
      }
    });
  }

  void _scrollDown() {
    if (_scrollControllerGroup.hasClients) {
      _scrollControllerGroup.animateTo(
        _scrollControllerGroup.position.maxScrollExtent + 300,
        duration: const Duration(
          milliseconds: 200,
        ),
        curve: Curves.easeOut,
      );
    }
  }

  void _scrollDownMax() {
    if (_scrollControllerGroup.hasClients) {
      _scrollControllerGroup.animateTo(
        _scrollControllerGroup.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 200,
        ),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /*       Image.asset(
          "assets/whatsapp_Back.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),*/
        Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              backgroundColor: Color.fromRGBO(5, 119, 128, 1),
              leadingWidth: 70,
              titleSpacing: 0,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 24,
                    ),
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(widget.img.toString()),
                    )
                  ],
                ),
              ),
              title: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => ChatDetailsScreen(
                              groupId: widget.to_user_id.toString(),
                              userId: PrefObj.preferences!
                                  .get(PrefKeys.USER_ID)
                                  .toString(),
                            )),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.to_user_name.toString(),
                        style: TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    controller: _scrollControllerGroup,
                    itemCount: chatMessages.length + 1,
                    itemBuilder: (context, index) {
                      if (index == chatMessages.length) {
                        return Container(
                          height: 50,
                        );
                      }
                      if (chatMessages[index].sender_id.toString() ==
                          from_user_id) {
                        return OwnMessageCard(
                          message: chatMessages[index].content,
                          time: chatMessages[index]
                              .created_at
                              .toString()
                              .substring(11, 16),
                          sender_name: chatMessages[index].name_en,
                          type: chatMessages[index].type,
                          is_redirect:
                              chatMessages[index].is_redirect.toString(),
                          is_sent_by_system:
                              chatMessages[index].is_sent_by_system.toString(),
                          groupId: chatMessages[index].receiver_id.toString(),
                          polling_id: chatMessages[index].polling_id.toString(),
                        );
                      } else {
                        return ReplyCard(
                          message: chatMessages[index].content,
                          time: chatMessages[index]
                              .created_at
                              .toString()
                              .substring(11, 16),
                          sender_name: chatMessages[index].name_en,
                          type: chatMessages[index].type,
                          is_redirect:
                              chatMessages[index].is_redirect.toString(),
                          is_sent_by_system:
                              chatMessages[index].is_sent_by_system.toString(),
                          groupId: chatMessages[index].receiver_id.toString(),
                          polling_id: chatMessages[index].polling_id.toString(),
                        );
                      }
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 60,
                        child: Card(
                          margin: EdgeInsets.only(left: 2, right: 2, bottom: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextFormField(
                            controller: _dataController,
                            focusNode: focusNode,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.multiline,
                            maxLines: 10,
                            minLines: 1,
                            onChanged: (value) {
                              if (value.length > 0) {
                                setState(() {
                                  sendButton = true;
                                });
                              } else {
                                setState(() {
                                  sendButton = false;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Type a message",
                              hintStyle: TextStyle(color: Colors.grey),
                              prefixIcon: IconButton(
                                icon: Icon(
                                  show ? Icons.keyboard : Icons.keyboard,
                                ),
                                onPressed: () {},
                              ),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Visibility(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.attach_file,
                                      ),
                                      onPressed: () {
                                        _getFromGallery();
                                      },
                                    ),
                                    visible: true,
                                  ),
                                  Visibility(
                                    child: IconButton(
                                      icon: Icon(Icons.camera_alt),
                                      onPressed: () {
                                        _imgFromCamera();
                                      },
                                    ),
                                    visible: true,
                                  ),
                                ],
                              ),
                              contentPadding: EdgeInsets.all(5),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8,
                          right: 2,
                          left: 2,
                        ),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Color(0xFF128C7E),
                          child: IconButton(
                            icon: Icon(
                              sendButton ? Icons.send : Icons.send,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (sendButton) {
                                _sendMessageText();

                                setState(() {
                                  sendButton = false;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class FileConverter {
  static String getBase64FormateFile(String path) {
    File file = File(path);
    print('File is = ' + file.toString());
    List<int> fileInByte = file.readAsBytesSync();
    String fileInBase64 = base64Encode(fileInByte);
    return fileInBase64;
  }
}
