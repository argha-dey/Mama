import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import '../../../global/PrefKeys.dart';
import '../../../global/config.dart';
import '../../../global/global.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../model/chat_msg_model.dart';
import 'custom_ui/own_msg_card.dart';
import 'custom_ui/reply_card.dart';

class ChatScreen extends StatefulWidget {
  final String? channel_id;
  final String? to_user_id;
  final String? to_user_name;
  final String? img;
  final IO.Socket? socket;
  final int? lastUnseenMsgCount;
  const ChatScreen(
      {Key? key,
      this.channel_id,
      this.to_user_id,
      this.to_user_name,
      this.img,
      this.socket,
      this.lastUnseenMsgCount})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? from_user_id;
  String? from_user_name;

  FocusNode focusNode = FocusNode();
  bool sendButton = false;

  TextEditingController _dataController = TextEditingController();
  ChatMessageModel? chatMessageModel;
  List<ChatMessageModel> chatMessages = [];
  ScrollController _scrollControllerIndividual = new ScrollController();

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
    debugPrint("imageBase64>>" + imageBase64!);
  }

  Future<void> _imgFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: null,
      maxHeight: null,
      imageQuality: null,
    );

    setState(() {
      _setImageFileListFromFile(pickedFile);
    });
  }

  /// Get from gallery
  Future<void> _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        _fileName = imageFile!.path.split('/').last;
        imageBase64 =
            FileConverter.getBase64FormateFile(imageFile!.path.toString());

        debugPrint("imageBase64>>" + imageBase64!);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    from_user_id = PrefObj.preferences!.get(PrefKeys.USER_ID).toString();
    _receiveMessage();
    _getOldChatMessage();
    _oldChatReceiveMessage();
    _sendSeenMessage();

    individualChatListScrollDataView();
  }

  @override
  void dispose() {
    _scrollControllerIndividual.dispose();
    super.dispose();
  }

  void individualChatListScrollDataView() {
    _scrollControllerIndividual.addListener(
      () {
        if (_scrollControllerIndividual.position.pixels ==
            _scrollControllerIndividual.position.maxScrollExtent) {
          print('reach to top');
          setState(() {
            _getOldChatMessage();
          });
        }
      },
    );
  }

  _sendMessageImage() {
    widget.socket!.emit('send_message', {
      json.encode({
        'receiver_id': widget.to_user_id.toString(),
        'sender_id': from_user_id,
        'content': imageBase64,
        'type': 'image'
      })
    });
    imageBase64 = "";
    _dataController.clear();
  }

  _sendMessageText() {
    widget.socket!.emit('send_message', {
      json.encode({
        'receiver_id': widget.to_user_id.toString(),
        'sender_id': from_user_id,
        'content': _dataController.text.trim(),
        'type': 'text'
      })
    });

    _dataController.clear();
  }

  _sendSeenMessage() {
    widget.socket!.emit('seen_message', {
      json.encode({
        'receiver_id': from_user_id,
        'sender_id': widget.to_user_id.toString(),
      })
    });
  }

  _getOldChatMessage() {
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

    //  print("Offset==> " + offset.toString());
//    print("limit==> " + limit.toString());

    widget.socket!.emit('get_old_chat_message', {
      json.encode({
        'receiver_id': widget.to_user_id,
        'sender_id': from_user_id,
        'offset': offset,
        'limit': limit
      })
    });
  }

  _oldChatReceiveMessage() {
    widget.socket!.on('old_chat_receive_message_${from_user_id}', (eventData) {
      List jsonResponse = json.decode(eventData);
      chatMessages.addAll(jsonResponse
          .map((job) => new ChatMessageModel.fromJson(job))
          .toList());
    });
  }

  _receiveMessage() {
    widget.socket!.on('receive_message', (eventData) {
      var msg = json.decode(eventData)['content'];
      var senderChatID = json.decode(eventData)['sender_id'];
      var receiverChatID = json.decode(eventData)['receiver_id'];
      var id = json.decode(eventData)['id'];
      var created_at = json.decode(eventData)['created_at'];
      var name_en = json.decode(eventData)['name_en'];
      var type = json.decode(eventData)['type'];

/*      print('receive_message: ${msg}');
      print('receive_message: ${name_en}');
      print('receive_message: ${senderChatID}');
      print('receive_message: ${receiverChatID}');
      print('receive_message: ${id}');
      print('receive_message_type: ${type}');*/

      if (receiverChatID.toString() == widget.to_user_id.toString() &&
          senderChatID.toString() == from_user_id.toString()) {
        chatMessages.insert(
            0,
            new ChatMessageModel(
                id: id,
                created_at: created_at,
                sender_id: senderChatID,
                receiver_id: receiverChatID,
                seen: "",
                content: msg,
                name_en: name_en,
                name_fr: "",
                type: type));
      }

      if (senderChatID.toString() == widget.to_user_id.toString() &&
          receiverChatID.toString() == from_user_id.toString()) {
        chatMessages.insert(
            0,
            new ChatMessageModel(
                id: id,
                created_at: created_at,
                sender_id: senderChatID,
                receiver_id: receiverChatID,
                seen: "",
                content: msg,
                name_en: name_en,
                name_fr: "",
                type: type));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
                      radius: 20,
                      backgroundImage: NetworkImage(
                        widget.img.toString(),
                      ),
                    ),
                  ],
                ),
              ),
              title: InkWell(
                onTap: () {},
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
                      Text(
                        "",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.normal),
                      )
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
                    shrinkWrap: true,
                    reverse: true,
                    controller: _scrollControllerIndividual,
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
                              .substring(12, 16),
                          sender_name: chatMessages[index].name_en.toString(),
                          type: chatMessages[index].type,
                          is_redirect:
                              "2", // send 2 for no need re-direction hear
                          is_sent_by_system:
                              "2", // send 2 for no need re-direction hear
                        );
                      } else {
                        return ReplyCard(
                          message: chatMessages[index].content,
                          time: chatMessages[index]
                              .created_at
                              .toString()
                              .substring(12, 16),
                          sender_name: chatMessages[index].name_en.toString(),
                          type: chatMessages[index].type,
                          is_redirect:
                              "2", // send 2 for no need re-direction hear
                          is_sent_by_system:
                              "2", // send 2 for no need re-direction hear
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
                            minLines: 1,
                            maxLines: 10,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.multiline,
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
                                icon: Icon(Icons.keyboard),
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
                                    visible: false,
                                  ),
                                  Visibility(
                                    child: IconButton(
                                      icon: Icon(Icons.camera_alt),
                                      onPressed: () {
                                        _imgFromCamera();
                                      },
                                    ),
                                    visible: false,
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
                                if (imageBase64 == "") {
                                  _sendMessageText();
                                } else {
                                  _sendMessageImage();
                                }
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
