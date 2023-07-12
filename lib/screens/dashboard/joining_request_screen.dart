import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:mama/screens/dashboard/polling_screen.dart';

import '../../global/PrefKeys.dart';
import '../../global/config.dart';
import '../../global/global.dart';
import '../../localizations/app_localizations.dart';
import '../../model/group_detail_model.dart';
import '../../model/member_req_model.dart';
import '../../repository/repository.dart';
import 'already_joined.dart';
import 'dashboard_screen.dart';
import 'joining_request_status_screen.dart';

class JoiningRequestSCreen extends StatefulWidget {
  String? groupid;
  String? userid;
  JoiningRequestSCreen({Key? key, required this.groupid, required this.userid})
      : super(key: key);

  @override
  State<JoiningRequestSCreen> createState() => _JoiningRequestSCreenState();
}

class _JoiningRequestSCreenState extends State<JoiningRequestSCreen> {
  double? ratingValu;
  final repository = Repository();
  MemberReqModel? memberReqData;
  List<MemberReqData> memberReqDataList = [];
  String? userid;
  String? reqid;
  GroupDetailModel? groupdetailData;

  bool isJoiningReqButtonVisible = true;
  bool isAlreadyJoinedVisible = false;
  String? approvestatus = '0';
  String? showButtonMessage = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        GetGroupDetailData();
      });
    });
  }

  Future<void> GetGroupDetailData() async {
  //  try {
      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);
      final uri = Uri.parse(
          Config.apiurl + Config.groupdetail + widget.groupid.toString());
      debugPrint("group Detail url: $uri");

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
        debugPrint("success");
        setState(() {
          responseJson = json.decode(response.body);
          groupdetailData = GroupDetailModel.fromJson(responseJson);

          for (int index = 0;
              index < groupdetailData!.data!.groupMember!.length;
              index++) {
            userid = groupdetailData!.data!.groupMember![index].user!.userId
                .toString();
            approvestatus = groupdetailData!
                .data!.groupMember![index].approveStatus
                .toString();
            String? nameUser = groupdetailData!
                .data!.groupMember![index].user!.nameEn
                .toString();

            debugPrint("group nameUser : $nameUser");
            debugPrint("group status : $approvestatus");
            debugPrint("local user id : "+PrefObj.preferences!.get(PrefKeys.USER_ID).toString());
            print(groupdetailData!.data!.groupMember![index].user!);

            if ((PrefObj.preferences!.get(PrefKeys.USER_ID).toString() ==
                    userid) &&
                (approvestatus == '1')) {
              debugPrint("group nameUser : $nameUser");
              debugPrint("grp aprv 1 :"+userid.toString());

              isJoiningReqButtonVisible = false;
              isAlreadyJoinedVisible = true;
              showButtonMessage = "Already Joined";
              break;
            } else if ((PrefObj.preferences!.get(PrefKeys.USER_ID).toString() ==
                    userid) &&
                (approvestatus == '0')) {

              debugPrint("grp :"+userid.toString());
              isJoiningReqButtonVisible = false;
              isAlreadyJoinedVisible = true;
              showButtonMessage =
                  "Join Request Already Send.\nPlease Waiting For Admin Approval";
              break;
            } else if ((PrefObj.preferences!.get(PrefKeys.USER_ID).toString() ==
                    userid) &&
                (approvestatus == '2')) {
              isJoiningReqButtonVisible = true;
              isAlreadyJoinedVisible = true;
              showButtonMessage =
                  "Join Request Decline By Admin.\nSend a New Joining Request";
              break;
            }
          }
        });
      } else {
        global()
            .showSnackBarShowError(context, 'Failed to get GroupDetailModel!');
      }
  /*  }


    catch (e) {
      print("kkkkkk");
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                width: 400,
                height: 125,
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage("assets/images/group_info.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
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
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
                  groupdetailData == null ? "" : groupdetailData!.data!.name!,
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
                padding:
                    EdgeInsets.only(top: 5, bottom: 5, left: 12, right: 12),
                child: Text(
                  Translation.of(context)!.translate('group')!,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 15, top: 5),
            child: Text(
              groupdetailData == null
                  ? ""
                  : groupdetailData!.data!.totalMember.toString() +
                      ' ' +
                      Translation.of(context)!.translate('members')! +
                      ' | ' +
                      Translation.of(context)!.translate('created_on')! +
                      ' ' +
                      groupdetailData!.data!.createdAt!,
              style: TextStyle(
                fontFamily: 'HelveticaNeueMedium',
                color: Colors.black38,
              ),
            ),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, top: 10),
                alignment: Alignment.topLeft,
                child: RatingBar.builder(
                  ignoreGestures: true,
                  initialRating: groupdetailData == null
                      ? 0.0
                      : groupdetailData!.data!.rating!.toDouble(),
                  itemSize: 27,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 10,
                  ),
                  onRatingUpdate: (rating) {
                    ratingValu = rating;

                    print(rating);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  groupdetailData == null
                      ? ""
                      : groupdetailData!.data!.rating.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: 19),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Text(
                  '/5',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 15, top: 25),
            child: Text(
              Translation.of(context)!.translate('about_group')!,
              style: TextStyle(
                  fontFamily: 'HelveticaNeueMedium',
                  color: Colors.black,
                  fontSize: 19),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 15, left: 15, top: 12, bottom: 12),
            child: Text(
              groupdetailData == null
                  ? ""
                  : groupdetailData!.data!.description.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black38,
                  fontSize: 15,
                  wordSpacing: 7),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 15, top: 25),
            child: Text(
              "Group Payment period",
              style: TextStyle(
                  fontFamily: 'HelveticaNeueMedium',
                  color: Colors.black,
                  fontSize: 19),
            ),
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 15, top: 5,bottom: 20),
                child: Text(
                  "Between ",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
              groupdetailData == null ?
              Container(

              )
                  :  Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only( top: 5,bottom: 20),
                child: Text(
                  groupdetailData!.data!.paymentStartDate == null ||   groupdetailData!.data!.paymentStartDate == ""  ? "1" : groupdetailData!.data!.paymentStartDate,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only( top: 5,bottom: 20),
                child: Text(
                  " - ",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
              groupdetailData == null ?
              Container(

              )
                  :  Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only( top: 5,bottom: 20),
                child: Text(
                  groupdetailData!.data!.paymentEndDate == null ||   groupdetailData!.data!.paymentEndDate == ""  ? "5" : groupdetailData!.data!.paymentEndDate,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only( top: 5,bottom: 20),
                child: Text(
                  " of the current month",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
              /*  " - "
                                  +
                                  groupdetailData!.data!.paymentEndDate == null ||   groupdetailData!.data!.paymentStartDate == "" ? "5" : groupdetailData!.data!.paymentEndDate
                                  +
                                  " of the current month"*/
            ],
          ),

          /*  InkWell(
              child: Container(
                alignment: Alignment.center,


                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/button.png', fit: BoxFit.contain),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 14,),
                      child:   Text(
                        "Send Joining Request",
                        // textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )

                  ],
                ),
              ) ,
              onTap: (){
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      actions: <Widget>[

                        Align(
                          alignment: Alignment.center,
                          child:    Text(
                            "Terms to join group"
                            ,
                            style: TextStyle(
                              fontSize: 19,
                              fontFamily: 'Comfortaa',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 10,),
                        Align(
                          alignment: Alignment.center,
                          child:    Text(
                            'n publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before final copy is available   n publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before final copy is available'
                            ,
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Comfortaa',
                              fontWeight: FontWeight.normal,
                              color: Colors.black38,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(

                              child: Container(
                                  padding: EdgeInsets.only(left: 10,right: 10,top: 6,bottom: 6),
                                  decoration: BoxDecoration(
                                      color:Colors.red,
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  child:Text(
                                    "Cancel"
                                    ,
                                    style: TextStyle(
                                      fontFamily: 'Comfortaa',
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  )
                              )
                              ,
                              onTap: () {
                                Navigator.pop(context);


                              },
                            ),
                            InkWell(

                              child:  Stack(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: Image.asset('assets/images/button3.png', fit: BoxFit.contain,width: 140,),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 10,left: 18),
                                    child:   Text(
                                      "Agree & Continue",
                                      // textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white, fontSize: 13),
                                    ),
                                  )

                                ],
                              ),
                              onTap: () {
                                Navigator.pop(context);


                              },
                            ),
                          ],
                        )


                      ],
                    );
                  },
                );
              },
            )
            ,*/

          SizedBox(
            height: 80,
          ),
          Visibility(
              child: InkWell(
                child: Container(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Image.asset('assets/images/button.png',
                            fit: BoxFit.contain),
                      ),
                      PrefObj.preferences!.get(PrefKeys.LANG).toString() ==
                                  'en' ||
                              PrefObj.preferences!
                                      .get(PrefKeys.LANG)
                                      .toString() ==
                                  null
                          ? Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                top: 14,
                              ),
                              child: Text(
                                Translation.of(context)!
                                    .translate('send_join_req')!,
                                // textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            )
                          : Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                top: 10,
                              ),
                              child: Text(
                                Translation.of(context)!
                                    .translate('send_join_req')!,
                                // textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            )
                    ],
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        actions: <Widget>[
                          SizedBox(
                            height: 28,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              Translation.of(context)!.translate('term_to')!,
                              style: TextStyle(
                                fontSize: 19,
                                fontFamily: 'Comfortaa',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 19,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: Text(
                                    groupdetailData!
                                                .data!.terms_and_condition ==
                                            null
                                        ? ''
                                        : groupdetailData!
                                            .data!.terms_and_condition
                                            .toString(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black38,
                                        wordSpacing: 7),
                                    textAlign: TextAlign.left,
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                child: Container(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, top: 6, bottom: 6),
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Text(
                                      Translation.of(context)!
                                          .translate('cancel')!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    )),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              InkWell(
                                child: Stack(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        'assets/images/button3.png',
                                        fit: BoxFit.contain,
                                        width: 140,
                                      ),
                                    ),
                                    PrefObj.preferences!
                                                    .get(PrefKeys.LANG)
                                                    .toString() ==
                                                'en' ||
                                            PrefObj.preferences!
                                                    .get(PrefKeys.LANG)
                                                    .toString() ==
                                                null
                                        ? Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(
                                                top: 8, left: 19),
                                            child: Text(
                                              Translation.of(context)!
                                                  .translate('agree_continue')!,
                                              // textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13),
                                            ),
                                          )
                                        : Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(
                                                top: 10, left: 10),
                                            child: Text(
                                              Translation.of(context)!
                                                  .translate('agree_continue')!,
                                              // textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13),
                                            ),
                                          )
                                  ],
                                ),
                                onTap: () {
                                  onJoinReq();
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              visible: isJoiningReqButtonVisible),
          Visibility(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 0, top: 25),
              child: Text(
                showButtonMessage.toString(),
                style: TextStyle(
                    fontFamily: 'HelveticaNeueMedium',
                    color: Colors.green,
                    decoration: TextDecoration.underline,
                    fontSize: 18),
              ),
            ),
            visible: isAlreadyJoinedVisible,
          )
        ],
      ),
    );
  }

  dynamic onJoinReq() async {
    // show loader
    global().showLoader(context);
    final http.Response response =
        await repository.onJoiningReqApi(widget.userid, widget.groupid);
    Map<String, dynamic> map = json.decode(response.body);
    global().hideLoader(context);

    var addjoinreq = map["message"];
    debugPrint(addjoinreq);
    if (addjoinreq == "Created successfully") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => JoinStatusScreen(
                  groupId: widget.groupid.toString(),
                )),
      );
    } else {}
  }
}
