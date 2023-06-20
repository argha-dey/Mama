import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mama/screens/dashboard/polling_question_screen.dart';
import 'package:http/http.dart' as http;

import '../../global/PrefKeys.dart';
import '../../global/config.dart';
import '../../global/global.dart';
import '../../localizations/app_localizations.dart';
import '../../model/group_detail_model.dart';
import '../../model/polling_list_model.dart';
import '../scanner/scanner_screen.dart';

class PollingScreen extends StatefulWidget {
  String? groupId;
  PollingScreen({Key? key, this.groupId}) : super(key: key);

  @override
  State<PollingScreen> createState() => _PollingScreenState();
}

class _PollingScreenState extends State<PollingScreen> {
  List<PollingListData> pollingDataList = [];
  PollingListModel? pollingData;
  String? userid;
  GroupDetailModel? groupdetailData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
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
          widget.groupId.toString() +
          "&request_user_type=member");
      debugPrint("polling url: $uri");

      var requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
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

/*  Future<void> GetGroupDetailData() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);
      final uri = Uri.parse(Config.apiurl + Config.groupdetail + widget.groupid.toString());
      debugPrint("group Detail url: $uri");



      var requestHeaders = {
        'Content-Type':'application/json',
        'Accept':'application/json',
        'Authorization': 'Bearer '+'${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}',
        'Accept-Language' : 'en'
      };

      final requestBody = {

      };
      debugPrint("group Detail url: $requestHeaders");




      final response = await http.get(uri, headers: requestHeaders);
      debugPrint("response : "+json.decode(response.body).toString());

      global().hideLoader(context);

      dynamic responseJson;
      if (response.statusCode == 200) {
        debugPrint("success ");
        setState(() {
          responseJson = json.decode(response.body);
          groupdetailData =  GroupDetailModel.fromJson(responseJson);

          for(int index = 0 ; index < groupdetailData!.data!.groupMember!.length; index++ ){
            userid = groupdetailData!.data!.groupMember![index].user!.userId.toString();
      //      approvestatus = groupdetailData!.data!.groupMember![index].approveStatus.toString();

          */ /*  if (PrefObj.preferences!.get(PrefKeys.USER_TYPE) == "admin" || PrefObj.preferences!.get(PrefKeys.USER_ID).toString() == userid ) {
              isJoiningReqButtonVisible = false;
              //   isAlreadyJoinedVisible = true;
              break;
            }
            else{
              isJoiningReqButtonVisible = true;
              //  isAlreadyJoinedVisible = false;
            }*/ /*

          }




        });


      } else {

        global().showSnackBarShowError(context,'Failed to get GroupDetailModel Data!');
      }
    }catch(e){
      global().hideLoader(context);
      print('==>Failed to get GroupDetailModel ');
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(left: 0),
                      alignment: Alignment.center,
                      width: 53,
                      height: 53,
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )

                  /* Container(

                  child: Text(
                    'MAMA',
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                  ) ,
                ),*/
                  /*  Row(
                  children: [
                    InkWell(
                      child: Container(
                        //   margin: EdgeInsets.only(left: 45),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(25)),
                        alignment: Alignment.center,
                        width: 25,
                        height: 25,
                        child: Image.asset(
                          'assets/images/polling.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => PollingScreen()),
                        );
                      },
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ScanScreen()),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(25)),
                        alignment: Alignment.center,
                        width: 25,
                        height: 25,
                        child: Image.asset(
                          'assets/images/barcode_scanner.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                      //  margin: EdgeInsets.only(left: 45),
                      padding: EdgeInsets.all(5),

                      decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(25)),
                      alignment: Alignment.center,
                      width: 25,
                      height: 25,
                      child: Image.asset(
                        'assets/images/bell.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                  ],
                ),*/
                ],
              ),
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.only(left: 15),
              alignment: Alignment.topLeft,
              child: Text(
                Translation.of(context)!.translate('polling')!,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 19),
              ),
            ),
            pollingData == null
                ? Container()
                : Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 15, top: 6),
                    child: Text(
                      pollingDataList.length == 0
                          ? ""
                          : pollingDataList.length.toString() +
                              ' ' +
                              Translation.of(context)!
                                  .translate('ongoing_polling')!,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black38,
                      ),
                    ),
                  ),
            pollingDataList.length > 0
                ? Expanded(
                    child: ListView.builder(
                        itemCount: pollingData!.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => PollingQstnScreen(
                                          pollingId: pollingData!
                                              .data![index].pollingId
                                              .toString(),
                                        )),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: CircleAvatar(
                                          radius: 22,
                                          backgroundImage: NetworkImage(
                                              "https://ui-avatars.com/api/?name=" +
                                                  pollingData!.data![index].name
                                                      .toString()
                                                      .toUpperCase()),
                                        )),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 15),
                                          child: Text(
                                            pollingDataList[index]
                                                .name
                                                .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 14),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              EdgeInsets.only(left: 15, top: 4),
                                          child: Text(
                                            Translation.of(context)!.translate(
                                                    'submit_within')! +
                                                " " + getTimeString(pollingDataList[index]
                                                .pollingHour)
                                                 +
                                                " hrs",
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                InkWell(
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        color: Color.fromRGBO(5, 119, 128, 1),
                                      ),
                                      margin:
                                          EdgeInsets.only(right: 15, top: 4),
                                      padding: EdgeInsets.all(10),
                                      child: Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                      )),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (_) => PollingQstnScreen(
                                                pollingId: pollingData!
                                                    .data![index].pollingId
                                                    .toString(),
                                              )),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        }))
                : Container(
                    height: 500,
                    child: Center(
                      child: Text("No New Polling Available!"),
                    ))

            /*   Container(
              margin: EdgeInsets.only(left: 15,right: 15,bottom: 12),
              child:Divider(
                color: Colors.black26,

              ) ,
            ),*/
          ],
        ));
  }
  String getTimeString(int value) {
    debugPrint("time ---------------"+value.toString());
    final int hour = value ~/ 60;
    final int minutes = value % 60;
    return '${hour.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}';
  }
}
