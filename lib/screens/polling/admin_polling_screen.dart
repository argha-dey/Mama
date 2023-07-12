import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mama/screens/polling/polling_create_screen.dart';
import 'package:http/http.dart' as http;
import 'package:mama/screens/polling/polling_question_screen_for_admin.dart';
import 'package:mama/screens/polling/polling_result_screen.dart';
import '../../global/PrefKeys.dart';
import '../../global/config.dart';
import '../../global/global.dart';
import '../../localizations/app_localizations.dart';
import '../../model/group_detail_model.dart';
import '../../model/polling_list_model.dart';
import '../dashboard/polling_question_screen.dart';

class AdminPollingScreen extends StatefulWidget {
  String? groupId;
  AdminPollingScreen({Key? key, this.groupId}) : super(key: key);

  @override
  State<AdminPollingScreen> createState() => _AdminPollingScreenState();
}

class _AdminPollingScreenState extends State<AdminPollingScreen> {
  double? ratingValu;
  GroupDetailModel? groupdetailData;
  List<PollingListData> pollingDataList = [];
  PollingListModel? pollingData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        GetGroupDetailData();
      });
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        GetPollingList();
      });
    });
  }

  Future<void> GetPollingList() async {
    try {
      global().showLoader(context);
      final uri = Uri.parse(Config.apiurl +
          Config.pollingList +
          "?group_id=" +
          widget.groupId.toString());
      debugPrint("polling url: $uri");

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
      debugPrint("polling list url: $requestHeaders");

      final response = await http.get(uri, headers: requestHeaders);
      debugPrint(
          "pollinglist response : " + json.decode(response.body).toString());

      global().hideLoader(context);

      dynamic responseJson;
      if (response.statusCode == 201 || response.statusCode == 200) {
        setState(() {
          pollingDataList = [];
          responseJson = json.decode(response.body);
          pollingData = PollingListModel.fromJson(responseJson);
          pollingDataList = pollingData!.data!;
        });
      } else {
        global()
            .showSnackBarShowError(context, 'Failed to get GroupModel Data!');
      }
    } catch (e) {
      global().hideLoader(context);
      print('==>Failed ');
    }
  }

  Future<void> GetGroupDetailData() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);
      final uri = Uri.parse(
          Config.apiurl + Config.groupdetail + widget.groupId.toString());
      debugPrint("group Detail url: $uri");

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
      debugPrint("group Detail url: $requestHeaders");

      final response = await http.get(uri, headers: requestHeaders);
      debugPrint("response : " + json.decode(response.body).toString());

      global().hideLoader(context);

      dynamic responseJson;
      if (response.statusCode == 200) {
        setState(() {
          responseJson = json.decode(response.body);
          groupdetailData = GroupDetailModel.fromJson(responseJson);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        groupdetailData == null
                            ? ""
                            : groupdetailData!.data!.name.toString(),
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
                groupdetailData == null
                    ? Container()
                    : Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: 15, top: 7),
                        child: Text(
                          groupdetailData!.data!.totalMember.toString() +
                              ' ' +
                              Translation.of(context)!.translate('members')! +
                              ' | ' +
                              Translation.of(context)!
                                  .translate('created_on')! +
                              ' ' +
                              groupdetailData!.data!.createdAt.toString(),
                          style: TextStyle(
                              fontFamily: 'HelveticaNeueMedium',
                              color: Colors.black38,
                              fontSize: 15),
                        ),
                      ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 15, right: 15),
                    padding: EdgeInsets.only(top: 15, bottom: 15, left: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        /*  border: Border.all(
                color: Colors.blue,
            ),*/
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue[100]!,
                            blurRadius: 5.0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          Translation.of(context)!.translate('create_polling')!,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'HelveticaNeueMedium',
                              fontSize: 16,
                              color: Colors.black),
                        ),
                        InkWell(
                          child: Container(
                            margin: EdgeInsets.only(right: 15),
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(5, 119, 128, 1),
                                borderRadius: BorderRadius.circular(25)),
                            alignment: Alignment.center,
                            width: 28,
                            height: 28,
                            child: Image.asset(
                              'assets/images/edit.png',
                              fit: BoxFit.contain,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                      builder: (_) => PollingCreateScreen(
                                            groupId: widget.groupId,
                                          )),
                                )
                                .then((value) => GetPollingList());
                          },
                        ),
                      ],
                    )),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        Translation.of(context)!.translate('ongoing_polling')!,
                        style: TextStyle(
                            fontFamily: 'HelveticaNeueMedium',
                            color: Colors.black,
                            fontSize: 17),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    /*          Container(
                      margin: EdgeInsets.only(right: 15),
                      child: Text(
                        Translation.of(context)!.translate('view_all')!,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            decoration: TextDecoration.underline),
                      ),
                    ),*/
                  ],
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 15, top: 6),
                  child: Text(
                    pollingDataList.length.toString() +
                        ' ' +
                        Translation.of(context)!.translate('ongoing_polling')!,
                    style: TextStyle(
                        fontFamily: 'HelveticaNeueMedium',
                        color: Colors.black38,
                        fontSize: 13),
                  ),
                ),
                Container(
                  height: 550,
                  child: ListView.builder(
                      itemCount: pollingDataList.length,
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
                                                pollingDataList[index].name,
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
                                                  left: 15, top: 6),
                                              child: Text(
                                                Translation.of(context)!
                                                        .translate(
                                                            'start_on')! +
                                                    pollingDataList[index]
                                                        .startOn,
                                                style: TextStyle(
                                                    fontFamily:
                                                        'HelveticaNeueMedium',
                                                    color: Colors.black38,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.topLeft,
                                              margin: EdgeInsets.only(
                                                  left: 15, top: 3),
                                              child: Text(
                                                Translation.of(context)!
                                                        .translate('end_on')! +
                                                    pollingDataList[index]
                                                        .endOn,
                                                style: TextStyle(
                                                    fontFamily:
                                                        'HelveticaNeueMedium',
                                                    color: Colors.black38,
                                                    fontSize: 12),
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
                                              'assets/images/vote2.png',
                                              fit: BoxFit.contain,
                                              color: Colors.white,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      PollingResultScreen(
                                                        pollingId:
                                                            pollingDataList[
                                                                    index]
                                                                .pollingId
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
                                                      PollingQstnScreenForAdmin(
                                                        pollingId: pollingData!
                                                            .data![index]
                                                            .pollingId
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
                /*     Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      Translation.of(context)!.translate('past_polling')!,

                      style: TextStyle(fontFamily: 'HelveticaNeueMedium',color: Colors.black,fontSize: 17),
                    ) ,
                  ),

                  Container(
                    margin: EdgeInsets.only(right: 15),
                    child: Text(
                      Translation.of(context)!.translate('view_all')!,
                      style: TextStyle(fontWeight: FontWeight.normal,color: Colors.black,decoration: TextDecoration.underline),
                    ) ,
                  ),


                ],
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 15,top: 6),
                child:Text(
                  '4 '+                      Translation.of(context)!.translate('ongoing_polling')!,
                  style: TextStyle(fontFamily: 'HelveticaNeueMedium',color: Colors.black38,fontSize: 15),
                ) ,
              ),

              Container(
                height: 410,
                child:  ListView.builder(
                    itemCount: 3,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return   InkWell(
                          onTap: (){


                          },
                          child:  Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 15),
                                            child: Text(
                                              'Polling 1',
                                              style: TextStyle(fontFamily: 'HelveticaNeueMedium',color: Colors.black,fontSize: 15),
                                            ) ,
                                          ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            margin: EdgeInsets.only(left: 15,top: 6),
                                            child:Text(
                                              Translation.of(context)!.translate('start_on')!+' 11:00 AM,22.03.2021',
                                              style: TextStyle(fontFamily: 'HelveticaNeueMedium',color: Colors.black38,fontSize: 12),
                                            ) ,
                                          ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            margin: EdgeInsets.only(left: 15,top: 3),
                                            child:Text(
                                              Translation.of(context)!.translate('end_on')!+' 11:00 AM,22.03.2021',
                                              style: TextStyle(fontFamily: 'HelveticaNeueMedium',color: Colors.black38,fontSize: 12),
                                            ) ,
                                          ),


                                        ],
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 15),
                                      padding: EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                          color:Color.fromRGBO(5, 119, 128,1),

                                          borderRadius: BorderRadius.circular(25)
                                      ),
                                      alignment: Alignment.center,
                                      width: 31,
                                      height: 31,
                                      child: Image.asset('assets/images/view.png', fit: BoxFit.contain,color: Colors.white,),
                                    ) ,
                                    onTap: (){

                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (_) => AdminPoliingQuestionScreen()),
                                      );
                                    },
                                  ),

                                ],
                              ) ,
                              Container(
                                margin: EdgeInsets.only(bottom: 12,top: 15),
                                child:Divider(
                                  color: Colors.black26,

                                ) ,
                              ),
                            ],
                          )


                      )

                      ;



                    }),
              ),*/
              ],
            ),
          ),
        ));
  }
}
