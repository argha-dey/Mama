import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../global/PrefKeys.dart';
import '../../../global/config.dart';
import '../../../global/global.dart';
import '../../../localizations/app_localizations.dart';
import 'package:http/http.dart' as http;

import 'chat_details_screen.dart';

class RemoveMemberScreen extends StatefulWidget {
  String? memberId;
  String? name;
  String? dob;
  String? telephone;
  String? email;
  String? addrs;
  String? grpType;
  String? role;
  String? img;
  String? grpId;

  RemoveMemberScreen(
      {Key? key,
      this.memberId,
      this.name,
      this.dob,
      this.telephone,
      this.email,
      this.addrs,
      this.grpType,
      this.role,
      this.img,
      this.grpId})
      : super(key: key);

  @override
  State<RemoveMemberScreen> createState() => _RemoveMemberScreenState();
}

class _RemoveMemberScreenState extends State<RemoveMemberScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


   debugPrint("role "+widget.role.toString());
   debugPrint("group type "+widget.grpType.toString());


  }

  Future<void> DeleteMember() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);
      final uri = Uri.parse(
          Config.apiurl + Config.joiningreq + "/" + widget.memberId.toString());
      debugPrint("member delete url: $uri");

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

      final response = await http.delete(uri, headers: requestHeaders);
      debugPrint(
          "member delete response : " + json.decode(response.body).toString());

      global().hideLoader(context);

      dynamic responseJson;
      if (response.statusCode == 200) {
        global().showSnackBarShowError(
            context, 'Group Member Remove Successfully!');
        Navigator.pop(context);
/*
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) => ChatDetailsScreen(groupId: widget.grpId,)),
        );
*/

      } else {
        global().showSnackBarShowError(
            context, 'Failed to get Member delete Data!');
      }
    } catch (e) {
      global().hideLoader(context);
      print('==>Failed to get Member delete ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 30,
            ),
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
                            widget.img.toString(),
                            //file:///image-vJQkle4EGXcCkTqCOqLqwDq1be057OvaP56fNE7w.png
                          ),
                        )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Text(
                            widget.name.toString(),
                            style: TextStyle(
                                fontFamily: 'HelveticaNeueMedium',
                                color: Colors.black,
                                fontSize: 18),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15, top: 7),
                          child: Text(
                            'Employee | Unpaid',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black38,
                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            Container(
              margin: EdgeInsets.only(bottom: 12),
              child: Divider(
                color: Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text(
                    Translation.of(context)!.translate('personal_detail')!,
                    style: TextStyle(
                        fontFamily: 'HelveticaNeueMedium',
                        color: Colors.black,
                        fontSize: 18),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 15),
              child: Text(
                Translation.of(context)!.translate('date_of_join')! +
                    ' 22.01.2021',
                style: TextStyle(
                    fontFamily: 'HelveticaNeueMedium',
                    color: Colors.black38,
                    fontSize: 16),
              ),
            ),
            SizedBox(
              height: 20,
            ),

            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  width: 25,
                  height: 25,
                  child: Image.asset(
                    'assets/images/birthday.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        Translation.of(context)!.translate('date_of_birth')!,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black38,
                            fontSize: 13),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        widget.dob.toString(),
                        style: TextStyle(
                            fontFamily: "HelveticaNeueMedium",
                            color: Colors.black38,
                            fontSize: 15),
                      ),
                    ),
                  ],
                )
              ],
            ),

            SizedBox(
              height: 20,
            ),

            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  width: 25,
                  height: 25,
                  child: Image.asset(
                    'assets/images/telephone.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        Translation.of(context)!.translate('telephn_no')!,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black38,
                            fontSize: 13),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        widget.telephone.toString(),
                        style: TextStyle(
                            fontFamily: 'HelveticaNeueMedium',
                            color: Colors.black38,
                            fontSize: 15),
                      ),
                    ),
                  ],
                )
              ],
            ),

            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  width: 25,
                  height: 25,
                  child: Image.asset(
                    'assets/images/email.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        Translation.of(context)!.translate('email')!,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black38,
                            fontSize: 13),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        widget.email.toString(),
                        style: TextStyle(
                            fontFamily: 'HelveticaNeueMedium',
                            color: Colors.black38,
                            fontSize: 15),
                      ),
                    ),
                  ],
                )
              ],
            ),

            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  width: 25,
                  height: 25,
                  child: Image.asset(
                    'assets/images/location.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        Translation.of(context)!.translate('address')!,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black38,
                            fontSize: 13),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        widget.addrs.toString(),
                        maxLines: 2,
                        style: TextStyle(
                            fontFamily: 'HelveticaNeueMedium',
                            color: Colors.black38,
                            fontSize: 15,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ],
                )
              ],
            ),

            SizedBox(
              height: 20,
            ),

            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  width: 25,
                  height: 25,
                  child: Image.asset(
                    'assets/images/group.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        Translation.of(context)!
                            .translate('community_group_type')!,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black38,
                            fontSize: 13),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        widget.grpType.toString() == "0"
                            ? "Stockvel"
                            : widget.grpType.toString() == "1"
                                ? "Burial Society"
                                : "Both",
                        style: TextStyle(
                            fontFamily: 'HelveticaNeueMedium',
                            color: Colors.black38,
                            fontSize: 15),
                      ),
                    ),
                  ],
                )
              ],
            ),

            SizedBox(
              height: 20,
            ),

            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  width: 25,
                  height: 25,
                  child: Image.asset(
                    'assets/images/indivisual.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        Translation.of(context)!.translate('your_role')!,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black38,
                            fontSize: 13),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        widget.role.toString() == "0"
                            ? "Chairman/Secretary"
                            : "Other Member",
                        style: TextStyle(
                            fontFamily: 'HelveticaNeueMedium',
                            color: Colors.black38,
                            fontSize: 15),
                      ),
                    ),
                  ],
                )
              ],
            ),

            SizedBox(
              height: 20,
            ),

            ///send joining req
            /* InkWell(
              child: Container(
                alignment: Alignment.center,


                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/button.png', fit: BoxFit.contain),
                    ),
                    PrefObj.preferences!.get(PrefKeys.LANG).toString() ==
                        'en' ||
                        PrefObj.preferences!
                            .get(PrefKeys.LANG)
                            .toString() ==
                            null ?
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 14,),
                      child:   Text(
                        Translation.of(context)!.translate('send_join_req')!,
                        // textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )
                        :
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 4,),
                      child:   Text(
                        Translation.of(context)!.translate('send_join_req')!,
                        // textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )

                  ],
                ),
              ) ,
              onTap: (){
                */ /* showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      actions: <Widget>[

                        Align(
                          alignment: Alignment.center,
                          child:    Text(
                            Translation.of(context)!.translate('term_to')!
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
                                    Translation.of(context)!.translate('cancel')!
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
                                      Translation.of(context)!.translate('agree_continue')!,
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
                );*/ /*
              },
            ),*/
            SizedBox(
              height: 20,
            ),

            ///chat now
            /*    InkWell(
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
                        Translation.of(context)!.translate('chat_now')!,
                        // textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )

                  ],
                ),
              ) ,
              onTap: (){
                */ /* showDialog(
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
                );*/ /*
              },
            ),*/
            ///remove from group
            InkWell(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  top: 20,
                ),
                child: Text(
                  Translation.of(context)!.translate('remove_from')!,
                  // textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      fontFamily: 'HelveticaNeueMedium'),
                ),
              ),
              onTap: () {
                DeleteMember();
              },
            ),

            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
