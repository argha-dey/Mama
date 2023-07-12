import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:io';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mama/screens/dashboard/chat/chat_details_screen.dart';
import 'package:mama/screens/dashboard/chat/payment_status_screen.dart';
import 'package:mama/screens/dashboard/polling_screen.dart';
import 'package:mama/screens/dashboard/profile/about_us_screen.dart';
import 'package:mama/screens/dashboard/profile/faq_screen.dart';
import 'package:mama/screens/dashboard/profile/privacy_policy_screen.dart';
import 'package:mama/screens/dashboard/profile/support_screen.dart';
import 'package:mama/screens/dashboard/profile/terms_conditions_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../global/PrefKeys.dart';
import '../../../global/config.dart';
import '../../../global/global.dart';
import '../../../global/global_socket_connection.dart';
import '../../../localizations/language_model.dart';
import '../../../model/admin_grouplist_model.dart';
import '../../../model/group_detail_model.dart';
import '../../../repository/repository.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


import 'dart:async';

import '../dashboard_screen.dart';


class SelectGroupForPaymentScreen extends StatefulWidget {
  String? userid;
   SelectGroupForPaymentScreen({Key? key,this.userid}) : super(key: key);

  @override
  State<SelectGroupForPaymentScreen> createState() => _SelectGroupForPaymentScreenState();
}

class _SelectGroupForPaymentScreenState extends State<SelectGroupForPaymentScreen>
    with TickerProviderStateMixin {

  List<IndividualUser> allReadyJoinGroupDataList = [];
  late IO.Socket _socket;




  final GlobalKey<ExpansionTileCardState> _languageKeys = GlobalKey();
  LangModel? languageModel;
  late String dropLanguageValue;

  final repository = Repository();
  File? imageFile = null;

  final ImagePicker _picker = ImagePicker();
  String? _fileName = "";
  final picker = ImagePicker();
  String? imageBase64 = "";
  XFile? _imageFileList;
  late Uint8List imagevalue;
  DateTime selectedDate = DateTime.now();
  String? strtDate;
  DateTime dateTime = DateTime.now();
  bool showDate = false;
  GroupDetailModel? groupdetailData;
  AdminGroupListModel? memberGroupList;
  String? mem_name;
  String? from_user_id;


  @override
  void initState() {
    super.initState();
    from_user_id = PrefObj.preferences!.get(PrefKeys.USER_ID).toString();
    _connectSocket();
  }

  _connectSocket() async {
    _socket = await GlobalSocketConnection()
        .connectSocket(PrefObj.preferences!.get(PrefKeys.USER_ID).toString());
    _socket.onConnect((data) => print('Connection established Successfully'));

    _socket.on('connect', (data) => print(' socketid : ${_socket.id}'));

    _socket.onConnectError((data) => print('Connect Error: $data'));

    _getAllReadyJoinGroupListListen();

    _socket.on(
        'receive_chat_group_list_${from_user_id}', _receiveChatGroupListListen);

  }
  _getAllReadyJoinGroupListListen() {
    log('user_id=> : $from_user_id');
    _socket.emit('get_chat_group_list', {
      json.encode({'user_id': from_user_id, 'keyword': ''})
    });
  }

  _receiveChatGroupListListen(data) {
    log('get_chat_group_list=> : $data');
    log('user_id=> : $from_user_id');
    List jsonResponse = json.decode(data);
    allReadyJoinGroupDataList =
        jsonResponse.map((job) => new IndividualUser.fromJson(job)).toList();
  }
/*  Future<void> GetMemberGroupList() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);
      final uri = Uri.parse(Config.apiurl + "my-group?member_type=member");

      debugPrint("admin group list url: $uri");

      var requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
        'Bearer ' + '${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}',
        'Accept-Language': 'en'
      };

      final requestBody = {};
      debugPrint("group Detail url: $requestHeaders");

      final response = await http.get(uri, headers: requestHeaders);
      debugPrint("response : " + json.decode(response.body).toString());

      global().hideLoader(context);

      dynamic responseJson;
      if (response.statusCode == 200) {
        debugPrint("success ");
        setState(() {
          responseJson = json.decode(response.body);
          memberGroupList = AdminGroupListModel.fromJson(responseJson);
        });
      } else {
        global().showSnackBarShowError(
            context, 'Failed to get GroupDetailModel Data!');
      }
    } catch (e) {
      global().hideLoader(context);
      print('==>Failed to get GroupDetailModel ');
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(5, 119, 128, 1),
          title: Text(
            "Select group",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18),
          ),
          leading: IconButton(
              icon: new Icon(
                Icons.keyboard_backspace_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body:Container(

          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),

              allReadyJoinGroupDataList.length > 0
                  ? Expanded(
                  child: ListView.builder(
                      itemCount: allReadyJoinGroupDataList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var group_name =
                        allReadyJoinGroupDataList[index].name_en.toString();
                        var group_id =
                        allReadyJoinGroupDataList[index].id.toString();
                        var group_image =
                            allReadyJoinGroupDataList[index].image;

                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => PaymentStatusScreen(
                                    groupid: group_id,
                                   userid: widget.userid.toString(),

                                  )),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, top: 10, bottom: 10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      allReadyJoinGroupDataList[index].image ==
                                          null
                                          ? CircleAvatar(
                                        radius: 22,
                                        backgroundImage: NetworkImage(
                                            "https://ui-avatars.com/api/?name=" +
                                                allReadyJoinGroupDataList[
                                                index]
                                                    .name_en
                                                    .toString()
                                                    .toUpperCase()),
                                      )
                                          : CircleAvatar(
                                        radius: 22,
                                        backgroundImage: NetworkImage(
                                            Config.imageurl +
                                                allReadyJoinGroupDataList[
                                                index]
                                                    .image
                                                    .toString()),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                allReadyJoinGroupDataList[index]
                                                    .name_en
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                           /*   SizedBox(
                                                height: 6,
                                              ),
                                              allReadyJoinGroupDataList[index]
                                                  .last_message ==
                                                  null
                                                  ? Text(
                                                "No new message available",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors
                                                        .grey.shade600,
                                                    fontWeight: FontWeight
                                                        .normal),
                                              )
                                                  : Text(

                                                allReadyJoinGroupDataList[
                                                index]
                                                    .last_message
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors
                                                        .grey.shade600,
                                                    fontWeight: FontWeight
                                                        .normal),
                                                maxLines: 1,
                                              ),*/
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        /*        Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    allReadyJoinGroupDataList[index]
                                        .last_message ==
                                        null
                                        ? Container()
                                        : Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Text(
                                        allReadyJoinGroupDataList[index]
                                            .last_message_time
                                            .toString()
                                            .substring(11, 16),
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                            fontSize: 12),
                                      ),
                                    ),
                                    allReadyJoinGroupDataList[index].unseen != 0
                                        ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(20),
                                        color: Colors.transparent,
                                      ),
                                      margin: EdgeInsets.only(
                                          right: 10, top: 5),
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        allReadyJoinGroupDataList[index]
                                            .unseen
                                            .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.transparent,
                                            fontSize: 8),
                                      ),
                                    )
                                        : Container(),
                                  ],
                                ),*/
                              ],
                            ),
                          ),
                        );
                      }))
                  : Container(
                alignment: Alignment.center,
                child:   Text(
                  "No Joined Group(s) found",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )

           /*   memberGroupList == null
                  ? Container(
                alignment: Alignment.center,
                child:  Text("No Group found"),
              )

                  : memberGroupList!.data!.length > 0
                  ? Expanded(
                  child: ListView.builder(
                      itemCount: memberGroupList!.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                               Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => PaymentStatusScreen(
                                groupid: memberGroupList!
                                    .data![index].groupId
                                    .toString(),
                                userid: widget.userid.toString(),
                              )),
                        );
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, top: 10, bottom: 10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      memberGroupList!.data![index].image ==
                                          null
                                          ? CircleAvatar(
                                        radius: 22,
                                        backgroundImage: NetworkImage(
                                            "https://ui-avatars.com/api/?name=" +
                                                memberGroupList!
                                                    .data![index].name
                                                    .toString()
                                                    .toUpperCase()),
                                      )
                                          : CircleAvatar(
                                        radius: 22,
                                        backgroundImage: NetworkImage(
                                            Config.imageurl +
                                                memberGroupList!
                                                    .data![index]
                                                    .image
                                                    .toString()),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                memberGroupList!
                                                    .data![index].name
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Text(
                                                "Admin",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors
                                                        .grey.shade600,
                                                    fontWeight:
                                                    FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Text(
                                        "",
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }))
                  : Container(
                alignment: Alignment.center,
                child: Text(
                  "No Admin Groups found",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )*/
            ],
          ),
        ));
  }




}
