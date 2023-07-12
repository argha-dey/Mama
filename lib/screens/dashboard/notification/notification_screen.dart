import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../../global/PrefKeys.dart';
import '../../../global/config.dart';
import '../../../global/global.dart';
import '../../../localizations/app_localizations.dart';
import '../../../model/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
/*  bool isRegister = PrefObj.preferences!.get(PrefKeys.IS_LOGIN) == null
      ? false
      : PrefObj.preferences!.get(PrefKeys.IS_LOGIN);*/
  List<AnotherData> notificationList = [];
  NotificationModel? notificationData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  getNotificationListBloc.getNotificationListBlocSink();

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        GetNotificationList();
      });
    });
  }

  Future<void> GetNotificationList() async {
    try {
      global().showLoader(context);
      final uri = Uri.parse(Config.apiurl +
          "user/" +
          PrefObj.preferences!.get(PrefKeys.USER_ID).toString() +
          Config.notification);
      debugPrint("notification url: $uri");

      var requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        "timezone":
        '${PrefObj.preferences!.get(PrefKeys.MAMA_APP_TIME_ZONE)}',
        'Authorization':
            'Bearer ' + '${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}',
        'Accept-Language': 'en'
      };

      final requestBody = {};
      //   debugPrint("polling list url: $requestHeaders");

      final response = await http.get(uri, headers: requestHeaders);
      debugPrint(
          "notification response : " + json.decode(response.body).toString());

      global().hideLoader(context);

      dynamic responseJson;
      if (response.statusCode == 201 || response.statusCode == 200) {
        setState(() {
          notificationList = [];
          responseJson = json.decode(response.body);
          notificationData = NotificationModel.fromJson(responseJson);
          notificationList = notificationData!.data!;
        });
      } else {
        global().showSnackBarShowError(context, 'Failed to get Data!');
      }
    } catch (e) {
      global().hideLoader(context);
      print('==>Failed ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key, // Assign the key to Scaffold.

      appBar: AppBar(
        backgroundColor: Color.fromRGBO(5, 119, 128, 1),
        title: Text(
          'Notifications',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 19),
        ),
        leading: IconButton(
            icon: new Icon(Icons.keyboard_backspace_outlined),
            onPressed: () {
              //todo:
              Navigator.of(context).pop();
            }),
      ),

      backgroundColor: Colors.white,

      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),

          /*  Container(
            margin: EdgeInsets.only(left: 20),
            child: Text(
                Translation.of(context)!.translate('nonotification')!,
                style: GoogleFonts.comfortaa(
                  textStyle:                   TextStyle(color: Colors.black87, fontSize: 13,fontWeight: FontWeight.bold),

                )
            ),
          ),*/

          //isRegister?
          /// notifications
          notificationList.length > 0
              ? Expanded(
                  child: ListView.builder(
                      itemCount: notificationList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                            onTap: () {},
                            child: Card(
                              margin: EdgeInsets.all(5),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                margin: EdgeInsets.only(
                                                    right: 5, top: 2),
                                                child: Text(
                                                  notificationList[index]
                                                      .data!
                                                      .title
                                                      .toString(),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 14),
                                                )),
                                            Container(
                                                width: 260,
                                                margin: EdgeInsets.only(
                                                    left: 0, right: 5, top: 2),
                                                padding: EdgeInsets.only(top: 2),
                                                child: Text(
                                                  notificationList[index]
                                                      .data!
                                                      .body
                                                      .toString(),
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                )),
                                          ],
                                        ),
                                        Offstage(
                                          offstage: notificationList[index].hasRead ?? false,
                                          child: Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Icon(
                                              Icons.circle,
                                              size: 10,
                                              color: Color.fromRGBO(5, 119, 128, 1),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    )
                                  ],
                                ),
                              ),
                            ));
                      }))
              : Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Notifications not found!",
                    textAlign: TextAlign.center,
                  ),
                )

          /// notifications

          /*:     Container(
              margin: EdgeInsets.only(top: 27, left: 15),
              child: Text(
                Translation.of(context)!.translate('nonof')!,
                style: GoogleFonts.comfortaa(
                    textStyle: TextStyle(fontSize: 14)),
              ),
            )*/
        ],
      ),
    );
  }
}
