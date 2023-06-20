import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../global/PrefKeys.dart';
import '../../global/config.dart';
import '../../global/global.dart';
import '../../localizations/app_localizations.dart';
import '../../model/polling_qstn_detail_model.dart';

class PollingResultScreen extends StatefulWidget {
  String? pollingId;
  PollingResultScreen({Key? key, this.pollingId}) : super(key: key);

  @override
  State<PollingResultScreen> createState() => _PollingResultScreenState();
}

class _PollingResultScreenState extends State<PollingResultScreen> {
  List gender = ["Yes", "No", "May be"];
  String selectGenderType = "";
  PollingQstnDetailsModel? pollingQstnDetailsModel;
  List<PollingQuestion> pollQstnList = [];
  Future<void> GetPollingDetails() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);
      final uri = Uri.parse(Config.apiurl +
          Config.pollingCreate +
          "/" +
          widget.pollingId.toString());

      debugPrint("polling Detail url: $uri");

      var requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
            'Bearer ' + '${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}',
        'Accept-Language': 'en'
      };
      debugPrint("requestHeaders : $requestHeaders");
      final requestBody = {};

      dynamic responseJson;
      var response = await http.get(uri, headers: requestHeaders);
      global().hideLoader(context);
      debugPrint(
          "polling Detail response : " + json.decode(response.body).toString());

      if (response.statusCode == 200) {
        setState(() {
          responseJson = json.decode(response.body);
          pollingQstnDetailsModel =
              PollingQstnDetailsModel.fromJson(responseJson);
          pollQstnList = pollingQstnDetailsModel!.data!.pollingQuestion!;
        });
      } else {
        global().showSnackBarShowError(
            context, 'Failed to get polling details Data!');
      }
    } catch (e) {
      global().hideLoader(context);
      print('==>Failed ');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        GetPollingDetails();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
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
                    /*  Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: HomePage(),
                          ),
                        );*/
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
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  Translation.of(context)!.translate('polling_reselt')!,
                  style: TextStyle(
                      fontFamily: 'HelveticaNeueMedium',
                      color: Colors.black,
                      fontSize: 17),
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.80,
                  child: ListView.builder(
                    physics: ScrollPhysics(),
                    itemCount: pollQstnList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 15, bottom: 10),
                            alignment: Alignment.topLeft,
                            child: Text(
                              pollQstnList[index].question.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 19),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(left: 15, right: 15),
                              padding:
                                  EdgeInsets.only(top: 5, bottom: 5, left: 15),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  /*  border: Border.all(
                color: Colors.blue,
            ),*/
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue[50]!,
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Radio<String>(
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        value: gender[0],
                                        groupValue: selectGenderType,
                                        onChanged: (value) {},
                                      ),
                                      Text(
                                        Translation.of(context)!
                                            .translate('yes')!,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontFamily: 'HelveticaNeueMedium',
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 320,
                                    height: 12,
                                    child: LinearPercentIndicator(
                                      percent: pollQstnList[index].option1Avg! >
                                              0
                                          ? (pollQstnList[index].option1Avg! /
                                                  100)
                                              .toDouble()
                                          : 0.0,
                                      backgroundColor: Colors.blue[50],
                                      progressColor:
                                          Color.fromRGBO(5, 119, 128, 1),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    margin:
                                        EdgeInsets.only(left: 20, bottom: 20),
                                    child: Text(
                                      pollQstnList[index]
                                              .option1Avg
                                              .toString() +
                                          "%",
                                      style: TextStyle(
                                          fontFamily: 'HelveticaNeueMedium',
                                          color: Color.fromRGBO(5, 119, 128, 1),
                                          fontSize: 13),
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(left: 15, right: 15),
                              padding:
                                  EdgeInsets.only(top: 5, bottom: 5, left: 15),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  /*  border: Border.all(
                color: Colors.blue,
            ),*/
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue[50]!,
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Radio<String>(
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        value: gender[1],
                                        groupValue: selectGenderType,
                                        onChanged: (value) {},
                                      ),
                                      Text(
                                        Translation.of(context)!
                                            .translate('no')!,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontFamily: 'HelveticaNeueMedium',
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 320,
                                    height: 12,
                                    child: LinearPercentIndicator(
                                      percent: pollQstnList[index].option2Avg! >
                                              0
                                          ? (pollQstnList[index].option2Avg! /
                                                  100)
                                              .toDouble()
                                          : 0.0,
                                      backgroundColor: Colors.blue[50],
                                      progressColor:
                                          Color.fromRGBO(5, 119, 128, 1),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    margin:
                                        EdgeInsets.only(left: 20, bottom: 20),
                                    child: Text(
                                      pollQstnList[index]
                                              .option2Avg
                                              .toString() +
                                          "%",
                                      style: TextStyle(
                                          fontFamily: 'HelveticaNeueMedium',
                                          color: Color.fromRGBO(5, 119, 128, 1),
                                          fontSize: 13),
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(left: 15, right: 15),
                              padding:
                                  EdgeInsets.only(top: 5, bottom: 5, left: 15),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  /*  border: Border.all(
                color: Colors.blue,
            ),*/
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue[50]!,
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Radio<String>(
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        value: gender[2],
                                        groupValue: selectGenderType,
                                        onChanged: (value) {},
                                      ),
                                      Text(
                                        "May be",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontFamily: 'HelveticaNeueMedium',
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 320,
                                    height: 12,
                                    child: LinearPercentIndicator(
                                      percent: pollQstnList[index].option3Avg! >
                                              0
                                          ? (pollQstnList[index].option3Avg! /
                                                  100)
                                              .toDouble()
                                          : 0.0,
                                      backgroundColor: Colors.blue[50],
                                      progressColor:
                                          Color.fromRGBO(5, 119, 128, 1),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    margin:
                                        EdgeInsets.only(left: 20, bottom: 20),
                                    child: Text(
                                      pollQstnList[index]
                                              .option3Avg
                                              .toString() +
                                          "%",
                                      style: TextStyle(
                                          fontFamily: 'HelveticaNeueMedium',
                                          color: Color.fromRGBO(5, 119, 128, 1),
                                          fontSize: 13),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      );
                    },
                  ))
            ],
          ),
        ));
  }

  Container addRadioButton(int btnValue, String title) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 15, right: 15),
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            /*  border: Border.all(
                color: Colors.blue,
            ),*/
            boxShadow: [
              BoxShadow(
                color: Colors.blue[50]!,
                blurRadius: 5.0,
              ),
            ],
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Radio<String>(
                  activeColor: Theme.of(context).primaryColor,
                  value: gender[btnValue],
                  groupValue: selectGenderType,
                  onChanged: (value) {},
                ),
                Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: 'HelveticaNeueMedium',
                      fontSize: 16,
                      color: Colors.black),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 170,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(5, 119, 128, 1),
                      borderRadius: BorderRadius.circular(9)),
                ),
                Container(
                  width: 130,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(9)),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 20, bottom: 20),
              child: Text(
                '55 %',
                style: TextStyle(
                    fontFamily: 'HelveticaNeueMedium',
                    color: Color.fromRGBO(5, 119, 128, 1),
                    fontSize: 13),
              ),
            ),
          ],
        ));
  }
}
