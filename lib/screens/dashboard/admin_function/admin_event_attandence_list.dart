import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../../../global/PrefKeys.dart';
import '../../../global/config.dart';
import '../../../global/global.dart';
import '../../../localizations/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';

import '../../../model/admin_grouplist_model.dart';
import '../../../model/payment_group_member_model.dart';

class EventAttadenceManagementPage extends StatefulWidget {
  final String? groupId;
  final String? eventId;
  const EventAttadenceManagementPage({Key? key, this.groupId, this.eventId})
      : super(key: key);

  @override
  State<EventAttadenceManagementPage> createState() =>
      _EventAttadenceManagementPageState();
}

class _EventAttadenceManagementPageState
    extends State<EventAttadenceManagementPage> {
  bool statusLanguage = false;

  PaymentGroupMemberModel? paymentGroupMemberData;
  List<PaymentGroupMember> paymentGroupMemberList = [];

  Future<void> GetEventAttentMemberList() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);

      final uri = Uri.parse(Config.apiurl +
          "event-attendance?event_id=" +
          widget.eventId.toString());

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
          paymentGroupMemberData =
              PaymentGroupMemberModel.fromJson(responseJson);
          paymentGroupMemberList = paymentGroupMemberData!.data!;
        });
      } else {
        global().showSnackBarShowError(
            context, 'Failed to get GroupDetailModel Data!');
      }
    } catch (e) {
      global().hideLoader(context);
      print('==>Failed to get GroupDetailModel ');
    }
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        GetEventAttentMemberList();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 45,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 5, left: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Container(
                      /*   decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 3.0,
                                ),
                              ]),*/
                      child: const Icon(
                        Icons.keyboard_backspace,
                        color: Colors.black54,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.only(left: 15),
            child: Text(
              "Event Attendance Member List",
              style: TextStyle(
                  fontFamily: 'HelveticaNeueMedium',
                  color: Colors.black,
                  fontSize: 20),
            ),
          ),
          Container(
            child: paymentGroupMemberList.length > 0
                ? Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: paymentGroupMemberList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 16, right: 16, top: 10, bottom: 10),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        paymentGroupMemberList[index]
                                                    .user!
                                                    .profileImage ==
                                                null
                                            ? CircleAvatar(
                                                radius: 22,
                                                backgroundImage: NetworkImage(
                                                    "https://ui-avatars.com/api/?name=" +
                                                        paymentGroupMemberList[
                                                                index]
                                                            .user!
                                                            .nameEn
                                                            .toString()
                                                            .toUpperCase()),
                                              )
                                            : CircleAvatar(
                                                radius: 22,
                                                backgroundImage: NetworkImage(
                                                    /*Config.imageurl +*/
                                                    paymentGroupMemberList[
                                                            index]
                                                        .user!
                                                        .profileImage
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
                                                  paymentGroupMemberList[index]
                                                      .user!
                                                      .nameEn
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
                                                  "Member",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          Colors.grey.shade600,
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 0),
                                        child: FlutterSwitch(
                                          width: 60,
                                          height: 26,
                                          activeColor: Colors.green,
                                          inactiveColor: Colors.red,
                                          toggleSize: 24,
                                          activeText: "",
                                          inactiveText: "",
                                          value: true,
                                          showOnOff: true,
                                          onToggle: (val) {
                                            setState(() {});
                                          },
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
                    height: 300,
                    alignment: Alignment.center,
                    child: Text(
                      "No Members found",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
