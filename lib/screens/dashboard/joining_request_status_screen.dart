import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import '../../global/PrefKeys.dart';
import '../../global/config.dart';
import '../../global/global.dart';
import '../../localizations/app_localizations.dart';
import '../../model/group_detail_model.dart';
import 'dashboard_screen.dart';

class JoinStatusScreen extends StatefulWidget {
  String? groupId;

   JoinStatusScreen({Key? key,this.groupId}) : super(key: key);

  @override
  State<JoinStatusScreen> createState() => _JoinStatusScreenState();
}

class _JoinStatusScreenState extends State<JoinStatusScreen> {
  double? ratingValu;
  GroupDetailModel? groupdetailData;


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
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);
      final uri = Uri.parse(Config.apiurl + Config.groupdetail + widget.groupId.toString());
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
        debugPrint("success");
        setState(() {
          responseJson = json.decode(response.body);
          groupdetailData =  GroupDetailModel.fromJson(responseJson);





        });


      } else {

        global().showSnackBarShowError(context,'Failed to get GroupDetailModel Data!');
      }
    }catch(e){

      print('==>Failed to get GroupDetailModel ');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  ListView(
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
                  margin: EdgeInsets.only(top: 5,left: 10),
                  child:     GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
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
            )
            ,
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text(
                    groupdetailData==null ? "":  groupdetailData!.data!.name!,
                    style: TextStyle(fontFamily: 'HelveticaNeueMedium',color: Colors.black,fontSize: 19),
                  ) ,
                ),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color:Colors.blue[50],

                  ),
                  margin: EdgeInsets.only(right: 15),
                  padding: EdgeInsets.only(top:5,bottom: 5,left: 12,right: 12),
                  child: Text(
                    Translation.of(context)!.translate('group')!,
                    style: TextStyle(fontWeight: FontWeight.normal,color: Colors.blue,),
                  ) ,
                ),


              ],
            ),
            Container(
              alignment: Alignment.topLeft,

              margin: EdgeInsets.only(left: 15,top: 5),
              child: Text(
                groupdetailData==null ? "":   groupdetailData!.data!.totalMember.toString()   +' '+  Translation.of(context)!.translate('members')! +' | '+Translation.of(context)!.translate('created_on')! + ' '+ groupdetailData!.data!.createdAt!,
                style: TextStyle(fontFamily: 'HelveticaNeueMedium',color: Colors.black38,),
              ) ,
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10,top: 10),
                  alignment: Alignment.topLeft,
                  child:     RatingBar.builder(
                    initialRating: groupdetailData == null ? 0.0 : groupdetailData!.data!.rating!.toDouble(),
                    itemSize: 27,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding:
                    EdgeInsets.symmetric(horizontal: 4.0),
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
                  child:  Text(
                    groupdetailData==null ? "":   groupdetailData!.data!.rating.toString(),
                    style: TextStyle(fontWeight: FontWeight.normal,color: Colors.black,fontSize: 19),
                  )  ,
                ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child:  Text(
                    '/5',
                    style: TextStyle(fontWeight: FontWeight.normal,color: Colors.black,),
                  )  ,
                ),

              ],
            ),
            SizedBox(
              height: 24,
            ),




            Container(
              alignment: Alignment.topLeft,

              margin: EdgeInsets.only(left: 15,top: 25),
              child: Text(
                Translation.of(context)!.translate('about_group')! ,
                style: TextStyle(fontFamily: 'HelveticaNeueMedium',color: Colors.black,fontSize: 19),
              ) ,
            ),
            Container(
              margin: EdgeInsets.only(right: 15,left: 15,top: 12,bottom: 12),
              child: Text(
                groupdetailData==null ? "":  groupdetailData!.data!.description.toString(),
                style: TextStyle(fontWeight: FontWeight.normal,color: Colors.black38,fontSize: 15,wordSpacing: 7),
              ) ,
            ),



            Container(
              alignment: Alignment.topLeft,

              margin: EdgeInsets.only(left: 15,top: 25),
              child: Text(
                Translation.of(context)!.translate('join_req_status')!,
                style: TextStyle(fontFamily: 'HelveticaNeueMedium',color: Colors.black,fontSize: 19),
              ) ,
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top: 10,left: 15),
              child:   Text(
                Translation.of(context)!.translate('join_req_succes')!,
                // textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize: 16,fontFamily: 'HelveticaNeueMedium'),
              ),
            ),

          ],
        )
    );
  }
}
