import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import '../../global/PrefKeys.dart';
import '../../global/config.dart';
import '../../global/global.dart';
import 'package:http/http.dart' as http;

class ScanScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ScanScreenState();
}

class ScanScreenState extends State<ScanScreen> {
  String? qrCodeResult = "Not Yet Scanned";

  String? event_id;
  String? group_id;
  String? event_name;
  String? event_description;
  String? event_start_on;
  String? event_end_on;
  String? event_group_name;
  String? project_name;

  Future<void> onGiveAttand() async {
    try {
      global().showLoader(context);
      final uri = Uri.parse(Config.apiurl + "event-attendance");
      debugPrint("register url: $uri");

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        "timezone":
        '${PrefObj.preferences!.get(PrefKeys.MAMA_APP_TIME_ZONE)}',
        "Accept-Language": "en",
        "Authorization":
            'Bearer ' + '${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}'
      };

      final body = {
        "event_id": event_id,
        "group_id": group_id,
        "user_id": PrefObj.preferences!.get(PrefKeys.USER_ID).toString(),
        "attendance": '1',
        "remarks": "I was attended the meeting",
        "date": event_end_on,
      };

      debugPrint("body : " + jsonEncode(body).toString());

      var response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body), // use jsonEncode()
      );

      debugPrint("response : " + json.decode(response.body).toString());

      Map<String, dynamic> map = json.decode(response.body);
      var messageShow = map["message"];

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context);
        global().hideLoader(context);
        global().showSnackBarShowSuccess(context, messageShow.toString());
      } else {
        Navigator.pop(context);
        global().hideLoader(context);
        global().showSnackBarShowError(context, messageShow.toString());
      }
    } catch (e) {
      global().hideLoader(context);
      global().showSnackBarShowError(context, e.toString());
    }
  }

@override
  void initState() {
    // TODO: implement initState

    super.initState();
  }






  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              "Meeting Attendances",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18),
            ),
            leading: IconButton(
                icon: new Icon(
                  Icons.keyboard_backspace_outlined,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ),
          body: Container(
            padding: EdgeInsets.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //Message displayed over here
                  Text(
                    "Result",
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  qrCodeResult == null ||
                          qrCodeResult == "No scancode found" ||
                          qrCodeResult == "Not Yet Scanned"
                      ? Container(
                          child: Text(
                            "Not Yet Scanned",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 5.0,
                                      bottom: 5,
                                      top: 10),
                                  child: Text(
                                    "Group Name : " +
                                        event_group_name.toString(),
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 5.0,
                                      bottom: 5,
                                      top: 5),
                                  child: Text(
                                      "Event Name : " + event_name.toString(),
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 5.0,
                                      bottom: 5,
                                      top: 5),
                                  child:
                                  event_description == "null" ?    Text(
                                      "Event Description : No description found."
                          ,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left):
                                  Text(
                                      "Event Description : " +
                                          event_description.toString(),
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 5.0,
                                      bottom: 5,
                                      top: 5),
                                  child: Text(
                                      "Start On : " + event_start_on.toString(),
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 5.0,
                                      bottom: 10,
                                      top: 5),
                                  child: Text(
                                      "End On : " + event_end_on.toString(),
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left),
                                ),
                              ]),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          elevation: 5,
                          margin: EdgeInsets.all(10),
                        ),

                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    qrCodeResult == null ? "No scancode found" : '',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),
                  qrCodeResult == null ||
                          qrCodeResult == "No scancode found" ||
                          qrCodeResult == "Not Yet Scanned"
                      ? InkWell(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.only(bottom: 15),
                            child: Stack(
                              children: [
                                Container(
                                  child: Image.asset('assets/images/button.png',
                                      fit: BoxFit.contain),
                                ),
                                Container(
                                  // alignment: Alignment.bottomCenter,
                                  margin: EdgeInsets.only(left: 45, top: 15),
                                  child: Text(
                                    "SCAN NOW",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () async {
                            await Permission.camera.request();
                            if (await Permission.camera.request().isGranted) {
                              // Either the permission was already granted before or the user just granted it.
                              String? codeSaner = await scanner.scan();
                              setState(() {
                                Map<String, dynamic> map =
                                json.decode(codeSaner!);
                                project_name = map["project_name"];
                                if (project_name.toString() == "Mama") {
                                  event_id = map["event_id"];
                                  group_id = map["group_id"];
                                  event_name = map["event_name"];
                                  event_description = map["event_description"];
                                  event_start_on = map["event_start_on"];
                                  event_end_on = map["event_end_on"];
                                  event_group_name = map["event_group_name"];
                                }

                                qrCodeResult = "Not a valid QR";
                              });
                            }


                          },
                        )
                      : InkWell(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: Stack(
                              children: [
                                Container(
                                  child: Image.asset('assets/images/button.png',
                                      fit: BoxFit.contain),
                                ),
                                Container(
                                  // alignment: Alignment.bottomCenter,
                                  margin: EdgeInsets.only(
                                      left: 20, top: 15, right: 1),
                                  child: Text(
                                    "GIVE ATTENDANCE",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            onGiveAttand();
                          },
                        ),


                ]),
          ),
        ));
  }
}
