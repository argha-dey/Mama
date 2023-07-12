import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mama/model/event_list_model.dart';
import 'package:http/http.dart' as http;
import '../../../global/PrefKeys.dart';
import '../../../global/config.dart';
import '../../../global/global.dart';
import '../../../localizations/app_localizations.dart';
import 'admin_event_attandence_list.dart';
import 'generate_event_qr_code.dart';

class AdminEventListPage extends StatefulWidget {
  final String? groupId;
  final String? groupName;
  final String? groupNumber;
  final String? groupCreateOn;
  AdminEventListPage(
      {Key? key,
      this.groupId,
      this.groupName,
      this.groupNumber,
      this.groupCreateOn})
      : super(key: key);

  @override
  State<AdminEventListPage> createState() => _AdminEventListPageState();
}

class _AdminEventListPageState extends State<AdminEventListPage> {
  List<EventData> eventDataList = [];
  EventListModel? eventData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        GetEventList();
      });
    });
  }

  Future<void> GetEventList() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);
      final uri = Uri.parse(
          Config.apiurl + "event" + "?group_id=" + widget.groupId.toString());
      debugPrint("member req url: $uri");

      var requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        "timezone":
        '${PrefObj.preferences!.get(PrefKeys.MAMA_APP_TIME_ZONE)}',
        'Authorization':
            'Bearer ' + '${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}',
        'Accept-Language': 'en'
      };

      final body = {};

      debugPrint("body : " + jsonEncode(body).toString());

      var response = await http.get(
        uri,
        headers: requestHeaders, // use jsonEncode()
      );

      debugPrint("response : " + json.decode(response.body).toString());

      Map<String, dynamic> map = json.decode(response.body);
      var messageShow = map["message"];
      dynamic responseJson;
      if (response.statusCode == 200 || response.statusCode == 201) {
        global().hideLoader(context);

        //   Navigator.pop(context);
        responseJson = json.decode(response.body);

        setState(() {
          eventData = EventListModel.fromJson(responseJson);
          eventDataList = eventData!.data!;
        });
      } else {
        global().hideLoader(context);
      }
    } catch (e) {
      global().hideLoader(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(top: 35, left: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Container(
                        child: const Icon(
                          Icons.keyboard_backspace,
                          color: Colors.black54,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        widget.groupName.toString(),
                        style: TextStyle(
                            fontFamily: 'HelveticaNeueMedium',
                            color: Colors.black,
                            fontSize: 19),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue[50],
                      ),
                      margin: EdgeInsets.only(right: 15),
                      padding: EdgeInsets.only(
                          top: 5, bottom: 5, left: 14, right: 14),
                      child: Text(
                        Translation.of(context)!.translate('group')!,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Color.fromRGBO(5, 119, 128, 1),
                            fontFamily: 'HelveticaNeueMedium'),
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 15, top: 7),
                  child: Text(
                    widget.groupNumber.toString() +
                        ' ' +
                        Translation.of(context)!.translate('members')!,
                    style: TextStyle(
                        fontFamily: 'HelveticaNeueMedium',
                        color: Colors.black38,
                        fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        'Ongoing Meeting List',
                        style: TextStyle(
                            fontFamily: 'HelveticaNeueMedium',
                            color: Colors.black,
                            fontSize: 19),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.80,
                  child: ListView.builder(
                      itemCount: eventDataList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left: 15),
                                              child: Text(
                                                eventDataList[index]
                                                    .name
                                                    .toString(),
                                                style: TextStyle(
                                                    fontFamily:
                                                        'HelveticaNeueMedium',
                                                    color: Colors.black,
                                                    fontSize: 15),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.topLeft,
                                              margin: EdgeInsets.only(
                                                  left: 15, top: 4),
                                              child: Text(
                                                eventDataList[index]
                                                    .description
                                                    .toString(),
                                                style: TextStyle(
                                                    fontFamily:
                                                        'HelveticaNeueMedium',
                                                    color: Colors.black38,
                                                    fontSize: 13),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.topLeft,
                                              margin: EdgeInsets.only(
                                                  left: 15, top: 4),
                                              child: Text(
                                                Translation.of(context)!
                                                        .translate(
                                                            'start_on')! +
                                                    ": " +
                                                    eventDataList[index]
                                                        .startOn
                                                        .toString(),
                                                style: TextStyle(
                                                    fontFamily:
                                                        'HelveticaNeueMedium',
                                                    color: Colors.black38,
                                                    fontSize: 10),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.topLeft,
                                              margin: EdgeInsets.only(
                                                  left: 15, top: 4),
                                              child: Text(
                                                Translation.of(context)!
                                                        .translate('end_on')! +
                                                    ": " +
                                                    eventDataList[index]
                                                        .endOn
                                                        .toString(),
                                                style: TextStyle(
                                                    fontFamily:
                                                        'HelveticaNeueMedium',
                                                    color: Colors.black38,
                                                    fontSize: 10),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          child: Container(
                                            //   margin: EdgeInsets.only(left: 45),
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: Color.fromRGBO(
                                                    5, 119, 128, 1),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            alignment: Alignment.center,
                                            width: 25,
                                            height: 25,
                                            child: Image.asset(
                                              'assets/images/barcode_scanner.png',
                                              fit: BoxFit.contain,
                                              color: Colors.white,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      GenerateEventQRCodeScreen(
                                                        groupId: widget.groupId
                                                            .toString(),
                                                        eventId:
                                                            eventDataList[index]
                                                                .eventId
                                                                .toString(),
                                                        eventDescribtion:
                                                            eventDataList[index]
                                                                .description
                                                                .toString(),
                                                        eventEndOn:
                                                            eventDataList[index]
                                                                .endOn
                                                                .toString(),
                                                        eventGroupName: widget
                                                            .groupName
                                                            .toString(),
                                                        eventName:
                                                            eventDataList[index]
                                                                .name
                                                                .toString(),
                                                        eventStartOn:
                                                            eventDataList[index]
                                                                .startOn
                                                                .toString(),
                                                      )),
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          child: Container(
                                            margin: EdgeInsets.only(right: 15),
                                            padding: EdgeInsets.all(7),
                                            decoration: BoxDecoration(
                                                color: Color.fromRGBO(
                                                    5, 119, 128, 1),
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            alignment: Alignment.center,
                                            width: 31,
                                            height: 31,
                                            child: Image.asset(
                                              'assets/images/view.png',
                                              fit: BoxFit.contain,
                                              color: Colors.white,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      EventAttadenceManagementPage(
                                                        groupId: widget.groupId
                                                            .toString(),
                                                        eventId:
                                                            eventDataList[index]
                                                                .eventId
                                                                .toString(),
                                                      )),
                                            );
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 12, top: 15),
                                  child: Divider(
                                    color: Colors.black26,
                                  ),
                                ),
                              ],
                            ));
                      }),
                ),
              ],
            ),
          ),
        ));
  }
}
