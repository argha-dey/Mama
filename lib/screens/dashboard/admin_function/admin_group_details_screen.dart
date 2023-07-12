import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mama/screens/dashboard/admin_function/rating_and_review_details_of_admin.dart';
import 'package:mama/screens/dashboard/chat/remove_grp_memb_screen.dart';

import '../../../global/PrefKeys.dart';
import '../../../global/config.dart';
import '../../../global/global.dart';
import '../../../global/global_socket_connection.dart';
import '../../../localizations/app_localizations.dart';
import '../../../model/group_detail_model.dart';
import '../../../model/member_list_model.dart';
import '../../../model/member_req_model.dart';
import '../../../repository/repository.dart';
import '../../polling/admin_polling_screen.dart';
import '../chat/indivisual_chat_screen.dart';
import '../dashboard_screen.dart';
import '../polling_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

import 'admin_payment_management_page.dart';
import 'edit_about_group_terms_conditions.dart';
import 'event_create_page.dart';

class AdminGroupDetailsScreen extends StatefulWidget {
  String? groupId;
  AdminGroupDetailsScreen({Key? key, this.groupId}) : super(key: key);

  @override
  State<AdminGroupDetailsScreen> createState() =>
      _AdminGroupDetailsScreenState();
}

class _AdminGroupDetailsScreenState extends State<AdminGroupDetailsScreen> {
  final repository = Repository();

  double? ratingValu = 0.0;
  bool isSwitched = false;
  bool statusLanguage = false;
  MemberReqModel? memberReqData;
  List<MemberReqData> memberReqDataList = [];
  MemberModel? memberData;
  List<MemberData> memberDataList = [];
  GroupDetailModel? groupdetailData;
  TextEditingController addreview = TextEditingController();
  String? grpMemId;
  bool isRateAdminDone = false;
  late IO.Socket _socket;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        GetGroupMember();
      });
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        GetGroupDetailData();
      });
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        GetMemberReq();
      });
    });

    _connectSocket();
  }

  _connectSocket() async {
    _socket = await GlobalSocketConnection()
        .connectSocket(PrefObj.preferences!.get(PrefKeys.USER_ID).toString());
  }

  Future<void> GetMemberReq() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);
      final uri = Uri.parse(Config.apiurl +
          "group/" +
          widget.groupId.toString() +
          Config.memberReq);
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

      final requestBody = {};
      //  debugPrint("group url: $requestHeaders");

      final response = await http.get(uri, headers: requestHeaders);
      debugPrint(
          "member req response : " + json.decode(response.body).toString());

      global().hideLoader(context);

      dynamic responseJson;
      if (response.statusCode == 200) {
        setState(() {
          memberReqDataList = [];
          responseJson = json.decode(response.body);
          memberReqData = MemberReqModel.fromJson(responseJson);
          memberReqDataList = memberReqData!.data!;
        });
      } else {
        global().showSnackBarShowError(
            context, 'Failed to get MemberReqModel Data!');
      }
    } catch (e) {
      global().hideLoader(context);
      print('==>Failed to get MemberReqModel ');
    }
  }

  Future<void> GetGroupMember() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);
      final uri = Uri.parse(Config.apiurl +
          "group/" +
          widget.groupId.toString() +
          Config.memberlist);
      debugPrint("group memberlist url: $uri");

      var requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
            'Bearer ' + '${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}',
        'Accept-Language': 'en'
      };

      final requestBody = {};
      //  debugPrint("group url: $requestHeaders");

      //    PrefObj.preferences!.put(PrefKeys.USER_TYPE, userType);

      final response = await http.get(uri, headers: requestHeaders);
      debugPrint("group memberlist response : " +
          json.decode(response.body).toString());

      global().hideLoader(context);

      dynamic responseJson;
      if (response.statusCode == 200) {
        setState(() {
          memberDataList = [];
          responseJson = json.decode(response.body);
          memberData = MemberModel.fromJson(responseJson);
          memberDataList = memberData!.data!;

          if (memberDataList.length > 0) {
          } else {
            PrefObj.preferences!.put(PrefKeys.USER_TYPE, "member");
          }

          for (MemberData memberData in memberDataList) {
            if (memberData.user!.userId.toString() ==
                PrefObj.preferences!.get(PrefKeys.USER_ID).toString()) {
              if (memberData.memberType.toString() == "admin") {
                //   PrefObj.preferences!.put(PrefKeys.USER_TYPE, memberData.user!.userType.toString());
                PrefObj.preferences!.put(PrefKeys.USER_TYPE, "admin");
                //  global().showSnackBarShowError(context, memberData.user!.nameEn.toString() + " as admin");
                break;
              } else {
                PrefObj.preferences!.put(PrefKeys.USER_TYPE, "member");
                // global().showSnackBarShowError(context, memberData.user!.nameEn.toString() + " as memmber");
                break;
              }
            }
          }
        });
      } else {
        global()
            .showSnackBarShowError(context, 'Failed to get GroupMember Data!');
      }
    } catch (e) {
      global().hideLoader(context);
      print('==>Failed to get GroupMember ');
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
          ratingValu = double.parse(groupdetailData!.data!.rating.toString());
          debugPrint("ratingValu : " + ratingValu.toString());
          for (int index = 0;
              index < groupdetailData!.data!.groupMember!.length;
              index++) {
            grpMemId = groupdetailData!.data!.groupMember![index].groupMemberId
                .toString();
          }
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
    return WillPopScope(
        onWillPop: () async {
          // _tabSwapUsingBackButton(context, tabIndex!);
          return false;
        },
        child: DefaultTabController(
            length: 2,
            child: Scaffold(
                backgroundColor: Colors.white,
                body: ListView(
                  children: [
                    SizedBox(
                      height: 10,
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
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              child: Container(
                                //   margin: EdgeInsets.only(left: 45),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(5, 119, 128, 1),
                                    borderRadius: BorderRadius.circular(5)),
                                alignment: Alignment.center,
                                width: 25,
                                height: 25,
                                child: Image.asset(
                                  'assets/images/pen.png',
                                  fit: BoxFit.contain,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              EditAboutGroupTermsConditionScreen(
                                                  groupId:
                                                      groupdetailData!
                                                          .data!.groupId
                                                          .toString(),
                                                  groupDetails:
                                                      groupdetailData!
                                                          .data!.description
                                                          .toString(),
                                                  termCondition:
                                                      groupdetailData!.data!
                                                          .terms_and_condition
                                                          .toString(),
                                                  groupPolicy: groupdetailData!
                                                      .data!.privacy_policy
                                                      .toString())),
                                    )
                                    .then((value) => GetGroupDetailData());
                              },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
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
                            groupdetailData == null
                                ? ""
                                : groupdetailData!.data!.name!,
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
                              top: 5, bottom: 5, left: 12, right: 12),
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
                      margin: EdgeInsets.only(left: 15, top: 10),
                      child: Text(
                        groupdetailData == null
                            ? " "
                            : groupdetailData!.data!.totalMember!.toString() +
                                ' ' +
                                Translation.of(context)!.translate('members')! +
                                ' ' +
                                ' | ' +
                                Translation.of(context)!
                                    .translate('created_on')! +
                                ' ' +
                                groupdetailData!.data!.createdAt!.toString() +
                                "",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
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
                            initialRating: ratingValu!,
                            itemSize: 27,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 10,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            groupdetailData == null
                                ? ""
                                : groupdetailData!.data!.rating!.toString(),
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
                        InkWell(
                          child: Container(
                            margin: EdgeInsets.only(top: 15, left: 10),
                            child: Text(
                              Translation.of(context)!
                                  .translate('view_review')!,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => ReviewAndRatingOfAdmin(
                                        groupId: groupdetailData!.data!.groupId
                                            .toString(),
                                      )),
                            );
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    /* Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 15, right: 15),
                        padding: EdgeInsets.only(top: 5, bottom: 5, left: 15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            */ /*  border: Border.all(
                color: Colors.blue,
            ),*/ /*
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue[50]!,
                                blurRadius: 5.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              Translation.of(context)!.translate('payment_alert')!,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'HelveticaNeueMedium',
                                  fontSize: 16,
                                  color: Color.fromRGBO(5, 119, 128, 1)),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 0),
                              child: FlutterSwitch(
                                width: 48,
                                height: 25,

                                activeText: "",
                                inactiveText: "",
                                activeColor: Colors.blue,
                                inactiveColor: Colors.red,
                                toggleSize: 20,
                                value: statusLanguage,
                                showOnOff: true,
                                onToggle: (val) {
                                  setState(() {
                                    statusLanguage  =val;
                                  });

                                },
                              ),
                            ),
                          ],
                        )
                    ),*/

                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                      //   color: Colors.blue,
                      margin: EdgeInsets.only(left: 1, right: 1),
                      padding: EdgeInsets.only(
                        top: 15,
                        bottom: 5,
                      ),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CreateEventPage(
                                              groupId: groupdetailData!
                                                  .data!.groupId
                                                  .toString(),
                                              groupName: groupdetailData!
                                                  .data!.name
                                                  .toString(),
                                              groupCreateOn: "",
                                              groupNumber: groupdetailData!
                                                  .data!.totalMember
                                                  .toString(),
                                            )),
                                  );
                                },
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  padding: EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Color.fromRGBO(5, 119, 128, 1)),
                                  child: Image.asset(
                                    'assets/images/event.png',
                                    fit: BoxFit.contain,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 1),
                                child: Text("    Meeting \n Attendance"),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  padding: EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Color.fromRGBO(5, 119, 128, 1)),
                                  child: Image.asset(
                                    'assets/images/moneybag.png',
                                    fit: BoxFit.contain,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PaymentManagementPage(
                                              groupId: groupdetailData!
                                                  .data!.groupId
                                                  .toString(),
                                            )),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 1),
                                child: Text("     Payment \n Management"),
                              )
                            ],
                          ),
                          InkWell(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 45,
                                  height: 45,
                                  padding: EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Color.fromRGBO(5, 119, 128, 1)),
                                  child: Image.asset(
                                    'assets/images/polling.png',
                                    fit: BoxFit.contain,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 1),
                                  child: Text("      Polling \n Management"),
                                )
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminPollingScreen(
                                          groupId: groupdetailData!
                                              .data!.groupId
                                              .toString(),
                                        )),
                              );
                            },
                          ),
                        ],
                      ),
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
                      margin: EdgeInsets.only(
                          right: 15, left: 15, top: 12, bottom: 12),
                      child: Text(
                        groupdetailData == null
                            ? ""
                            : groupdetailData!.data!.description!,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
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
                        groupdetailData == null ?Container():
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only( top: 5,bottom: 20),
                          child: Text(
                            groupdetailData!.data!.paymentStartDate == null  ||       groupdetailData!.data!.paymentStartDate == ""  ? "1" : groupdetailData!.data!.paymentStartDate,
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
                        groupdetailData == null ?Container():
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only( top: 5,bottom: 20),
                          child: Text(
                            groupdetailData!.data!.paymentStartDate == null ||      groupdetailData!.data!.paymentEndDate == ""  ? "5" : groupdetailData!.data!.paymentEndDate,
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
                      height: 20,
                    ),
                    TabBar(
                      onTap: (index) {
                        debugPrint("index $index");
                        if (index==1) {
                          GetMemberReq();
                          setState(() {});
                        }
                        /*  setState(() {
                         if (index==3) {
                           onTap = false;
                         }
                       });*/
                      },
                      indicatorColor: Colors.black,
                      //   controller: _tabController,
                      tabs: [
                        Tab(
                          child: Container(
                            child: Text(
                              Translation.of(context)!
                                  .translate('group_members')!,
                              style: TextStyle(
                                  fontFamily: 'HelveticaNeueMedium',
                                  color: Colors.black,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            child: Text(
                              Translation.of(context)!
                                  .translate('members_req')!,
                              style: TextStyle(
                                  fontFamily: 'HelveticaNeueMedium',
                                  color: Colors.black,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                        height: 420,
                        child: TabBarView(
                          //  controller: _tabController,
                          children: [memberWidget(), requestWidget()],
                        )),

                    /// rate
                    /*    Container(
                margin: EdgeInsets.only(left: 15, top: 40, bottom: 7),
                alignment: Alignment.topLeft,
                child: Text(
                  Translation.of(context)!.translate('rate_admin')!,
                  style: TextStyle(
                      fontFamily: 'HelveticaNeueMedium',
                      color: Colors.black,
                      fontSize: 19),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    alignment: Alignment.topLeft,
                    child: RatingBar.builder(
                      initialRating: 5,
                      itemSize: 24,
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
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.only(
                          top: 10, bottom: 5, left: 5, right: 5),
                      decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(20)),
                      alignment: Alignment.center,
                      width: 40,
                      height: 40,
                      child: Image.asset(
                        'assets/images/send.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    onTap: () {
                      */ /* Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => PollingScreen()),
                    );*/ /*
                    },
                  ),
                ],
              ),*/
                    SizedBox(
                      height: 30,
                    ),
                    /*            Container(
                      margin: EdgeInsets.only(left: 15, top: 10, bottom: 7),
                      alignment: Alignment.center,
                      child: Text(
                        Translation.of(context)!.translate('terms_condition')! +
                            ' | ' +
                            Translation.of(context)!
                                .translate('privacy_policy')! +
                            ' | FAQ',
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black38,
                            fontSize: 14),
                      ),
                    ),*/
                  ],
                ))));
  }

  Widget memberWidget() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(
                Translation.of(context)!.translate('members')!,
                style: TextStyle(
                    fontFamily: 'HelveticaNeueMedium',
                    color: Colors.black,
                    fontSize: 19),
              ),
            ),
          /*  Container(
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
          margin: EdgeInsets.only(left: 15, top: 6, bottom: 10),
          child: Text(
            /* '5 ' + Translation.of(context)!.translate('out_of')! + ' 10',*/
            'Total : ' + memberDataList.length.toString() + '',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: memberDataList.length,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    if (memberDataList[index].memberType == "member") {
                      Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                                builder: (_) => RemoveMemberScreen(
                                      addrs: memberDataList[index]
                                          .user!
                                          .address
                                          .toString(),
                                      memberId: memberDataList[index]
                                          .groupMemberId
                                          .toString(),
                                      dob: memberDataList[index]
                                          .user!
                                          .dateOfBirth
                                          .toString(),
                                      email: memberDataList[index]
                                          .user!
                                          .email
                                          .toString(),
                                      grpType: memberDataList[index]
                                          .user!
                                          .groupType
                                          .toString(),
                                      role: memberDataList[index]
                                          .user!.userRole.toString(),
                                      img: memberDataList[index]
                                          .user!
                                          .profileImage
                                          .toString(),
                                      name: memberDataList[index]
                                          .user!
                                          .nameEn
                                          .toString(),
                                      //  role: memberDataList[index].user!.,
                                      telephone: memberDataList[index]
                                          .user!
                                          .mobile
                                          .toString(),
                                      grpId: memberDataList[index]
                                          .group!
                                          .groupId
                                          .toString(),
                                    )),
                          )
                          .then((value) => GetGroupMember());
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                  memberData == null
                                      ? ""
                                      : memberDataList[index]
                                          .user!
                                          .profileImage
                                          .toString(),
                                  //file:///image-vJQkle4EGXcCkTqCOqLqwDq1be057OvaP56fNE7w.png
                                ),
                              )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                margin: EdgeInsets.only(left: 15),
                                child: Text(
                                  memberData == null
                                      ? ""
                                      : memberDataList[index]
                                          .user!
                                          .nameEn
                                          .toString(),
                                  maxLines: 6,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 14),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15, top: 4),
                                child: Text(
                                  memberData == null
                                      ? ""
                                      : memberDataList[index]
                                          .memberType
                                          .toString(),
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
                      PrefObj.preferences!.get(PrefKeys.LANG).toString() ==
                                  'en' ||
                              PrefObj.preferences!
                                      .get(PrefKeys.LANG)
                                      .toString() ==
                                  null
                          ? InkWell(
                              onTap: () {
                                /*         Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => ChatScreen()),
                                );*/
                              },
                              child: memberDataList[index]
                                          .user!
                                          .userId
                                          .toString() ==
                                      PrefObj.preferences!
                                          .get(PrefKeys.USER_ID)
                                          .toString()
                                  ? Container()
                                  : InkWell(
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        child: Stack(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              child: Image.asset(
                                                  'assets/images/buttob2.png',
                                                  fit: BoxFit.contain),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.only(
                                                  top: 5, left: 9),
                                              child: Text(
                                                Translation.of(context)!
                                                    .translate('start_chat')!,
                                                // textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) => ChatScreen(
                                                    socket: _socket,
                                                    channel_id:
                                                        memberDataList[index]
                                                            .user!
                                                            .userId
                                                            .toString(),
                                                    to_user_id:
                                                        memberDataList[index]
                                                            .user!
                                                            .userId
                                                            .toString(),
                                                    to_user_name:
                                                        memberDataList[index]
                                                            .user!
                                                            .nameEn
                                                            .toString(),
                                                    lastUnseenMsgCount: 0,
                                                    img: memberDataList[index]
                                                        .user!
                                                        .profileImage)));
                                      }),
                            )
                          : InkWell(
                              onTap: () {
                                /*           Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => ChatScreen()),
                                );*/
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(40)),
                                child: Stack(
                                  children: [
                                    Container(
                                      //  alignment: Alignment.center,
                                      height: 24,
                                      child: Image.asset(
                                          'assets/images/buttob2.png',
                                          fit: BoxFit.contain),
                                    ),
                                    Container(
                                      alignment: Alignment.topCenter,
                                      margin: EdgeInsets.only(left: 12, top: 5),
                                      child: Text(
                                        Translation.of(context)!
                                            .translate('start_chat')!,
                                        // textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                );
              }),
        )
      ],
    );
  }

  Widget requestWidget() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(
                Translation.of(context)!.translate('members_req')!,
                style: TextStyle(
                    fontFamily: 'HelveticaNeueMedium',
                    color: Colors.black,
                    fontSize: 19),
              ),
            ),
          /*  Container(
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
          margin: EdgeInsets.only(left: 15, top: 6, bottom: 10),
          child: Text(
            /* '5 ' + Translation.of(context)!.translate('out_of')! + ' 10',*/
            'Total : ' + memberReqDataList.length.toString() + '',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: memberReqDataList.length,
              physics: ScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                  memberReqData == null
                                      ? ""
                                      : memberReqDataList[index]
                                          .user!
                                          .profileImage
                                          .toString(),
                                  //file:///image-vJQkle4EGXcCkTqCOqLqwDq1be057OvaP56fNE7w.png
                                ),
                              )),
                          Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                margin: EdgeInsets.only(left: 15),
                                child: Text(
                                  memberReqData == null
                                      ? ""
                                      : memberReqDataList[index]
                                          .user!
                                          .nameEn
                                          .toString(),
                                  maxLines: 5,
                                  style: TextStyle(
                                      fontFamily: 'HelveticaNeueMedium',
                                      color: Colors.black,
                                      fontSize: 16),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15, top: 6),
                                child: Text(
                                  '',
                                  style: TextStyle(
                                      fontFamily: 'HelveticaNeueMedium',
                                      color: Colors.black38,
                                      fontSize: 14),
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
                                padding: EdgeInsets.only(
                                    left: 12, right: 12, top: 2, bottom: 6),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(5, 119, 128, 1),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Text(
                                  Translation.of(context)!.translate('accept')!,
                                  style: TextStyle(
                                    fontFamily: 'HelveticaLight',
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                )),
                            onTap: () {
                              onAcceptDecline(
                                  "1",
                                  memberReqDataList[index]
                                      .groupMemberId
                                      .toString(),
                                  memberReqDataList[index]
                                      .group!
                                      .groupId
                                      .toString());
                            },
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          InkWell(
                            child: Container(
                                padding: EdgeInsets.only(
                                    left: 12, right: 12, top: 2, bottom: 6),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Text(
                                  Translation.of(context)!
                                      .translate('decline')!,
                                  style: TextStyle(
                                    fontFamily: 'HelveticaLight',
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                )),
                            onTap: () {
                              onAcceptDecline(
                                  "2",
                                  memberReqDataList[index]
                                      .groupMemberId
                                      .toString(),
                                  memberReqDataList[index]
                                      .group!
                                      .groupId
                                      .toString());
                            },
                          ),
                          SizedBox(
                            width: 6,
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }

  dynamic onAcceptDecline(
      String approveStatus, String memberid, String groupId) async {
    global().showLoader(context);
    final http.Response response =
        await repository.onAcceptDeclineApi(approveStatus, memberid, groupId);
    Map<String, dynamic> map = json.decode(response.body);
    global().hideLoader(context);
    if (response.statusCode == 200) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          GetMemberReq();
        });
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          GetGroupMember();
        });
      });
    } else {}
  }

  dynamic onRateGroupAdmin() async {
    global().showLoader(context);
    final http.Response response = await repository.onAdminRatingApi(
        ratingValu!,
        grpMemId.toString(),
        widget.groupId.toString(),
        addreview.text.toString());
    Map<String, dynamic> map = json.decode(response.body);
    global().hideLoader(context);
    if (response.statusCode == 200) {
      Navigator.pop(context);
      global().showSnackBarShowError(
          context, 'You Rated Group Admin Successfully !');
    } else {}
  }
}
