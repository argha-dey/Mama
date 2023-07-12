import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../global/PrefKeys.dart';
import '../../../global/config.dart';
import '../../../global/global.dart';
import 'package:http/http.dart' as http;

import '../../../localizations/app_localizations.dart';
import '../../../model/payment_month_model.dart';
import '../../../repository/repository.dart';
class PaymentStatusScreen extends StatefulWidget {
  String? groupid;
  String? userid;
   PaymentStatusScreen({Key? key, required this.groupid, required this.userid}) : super(key: key);

  @override
  State<PaymentStatusScreen> createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen> {

  final repository = Repository();
  PaymentStatusModel? paymentData;
  int selectedmonth = DateTime.now().month;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  //  onPaymentMonth();


    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        onPaymentMonth();
      });
    });


  }

  Future<void> onPaymentMonth() async {

      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);
      final uri = Uri.parse(Config.apiurl + Config.paymentMonth);
      debugPrint("paymentstatus url: $uri");

      var requestHeaders = {
        'Content-Type':'application/json',
        'Accept':'application/json',
        "timezone":
        '${PrefObj.preferences!.get(PrefKeys.MAMA_APP_TIME_ZONE)}',
        "Accept-Language":"en",
        "Authorization":'Bearer '+'${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}'
      };

      final body = {

        "user_id": widget.userid,
        "group_id": widget.groupid,


      };

      debugPrint("paymentstatus body : " + jsonEncode(body).toString());

      var response = await http.post(
        uri,
        headers: requestHeaders,
        body: jsonEncode(body), // use jsonEncode()
      );

      debugPrint("response : " + json.decode(response.body).toString());

      Map<String, dynamic> map = json.decode(response.body);
      var messageShow = map["message"];
      dynamic responseJson;
      if (response.statusCode == 200 || response.statusCode == 201) {
        global().hideLoader(context);

        //   Navigator.pop(context);
        responseJson = json.decode(response.body);
        paymentData =  PaymentStatusModel.fromJson(responseJson);

      } else {
        global().hideLoader(context);
        global().showSnackBarShowError(context, "uuu");
      }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Color.fromRGBO(5, 119, 128, 1),
          leadingWidth: 70,
          titleSpacing: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back,
                  size: 24,
                ),

              ],
            ),
          ),
          title:  Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 15, ),
            child: Text(
             "Payment Status",
              style: TextStyle(
                  fontFamily: 'HelveticaNeueMedium',
                  color: Colors.white,
                  fontSize: 19),
            ),
          ) ,
        ),
      ),
      body:

          paymentData == null ?
          Container(
            alignment: Alignment.center,
            child: Text("No Payment Status Found"),
          )
     :   ListView.builder(
              itemCount: paymentData!.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return

                  Card     (
                    margin: EdgeInsets.only(left: 15,right: 15,top: 7,bottom: 7),
                    child:Container(
                        padding: EdgeInsets.only(top: 20,bottom: 20,left: 20,right: 20),
                        child:    Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: 15, ),
                              child: Text(
                                paymentData!.data![index].monthName.toString(),
                                style: TextStyle(
                                    fontFamily: 'HelveticaNeueMedium',
                                    color: Colors.blue,
                                    fontSize: 19),
                              ),
                            ),


                            InkWell(
                              child:   Container(
                                alignment: Alignment.topLeft,
                                decoration: BoxDecoration(
                                    color: paymentData!.data![index].status == "Paid"?Colors.green:Colors.red,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                margin: EdgeInsets.only(left: 15, ),
                                padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5 ),
                                child: Text(
                                  paymentData!.data![index].status.toString(),
                                  style: TextStyle(
                                      fontFamily: 'HelveticaNeueMedium',
                                      color: Colors.white,
                                      fontSize: 16),
                                ),
                              ),
                              onTap: (){

                                /*  showDialog(
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
                                      'Do You Paid Already?',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Comfortaa',
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        child: Container(  margin: EdgeInsets.only(
                                            left: 30,

                                            top: 6,
                                            bottom: 6),
                                            padding: EdgeInsets.only(
                                                left: 25,
                                                right: 25,
                                                top: 6,
                                                bottom: 6),
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                BorderRadius.circular(
                                                    30)),
                                            child: Text(
                                              "No",
                                              style: TextStyle(
                                                fontSize: 15,
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
                                                margin: EdgeInsets.only(

                                                    right: 30,
                                                    top: 6,
                                                    bottom: 6),
                                                padding: EdgeInsets.only(
                                                    left: 25,
                                                    right: 25,
                                                    top: 6,
                                                    bottom: 6),
                                                decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        30)),
                                                child: Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                          ],
                                        ),
                                        onTap: () {




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
                          );*/

                              },
                            )
                            /*    (paymentStatusList[index].month_id == selectedmonth )?
                          InkWell(
                            child:   Container(
                              alignment: Alignment.topLeft,
                              decoration: BoxDecoration(
                                  color:paymentStatusList[index].payment_status == "Paid"?Colors.green:Colors.red,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              margin: EdgeInsets.only(left: 15, ),
                              padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5 ),
                              child: Text(
                                paymentStatusList[index].payment_status,
                                style: TextStyle(
                                    fontFamily: 'HelveticaNeueMedium',
                                    color: Colors.white,
                                    fontSize: 16),
                              ),
                            ),
                            onTap: (){

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
                                          'Do You Paid Already?',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Comfortaa',
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            child: Container(  margin: EdgeInsets.only(
                                                left: 30,

                                                top: 6,
                                                bottom: 6),
                                                padding: EdgeInsets.only(
                                                    left: 25,
                                                    right: 25,
                                                    top: 6,
                                                    bottom: 6),
                                                decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        30)),
                                                child: Text(
                                            "No",
                                                  style: TextStyle(
                                                    fontSize: 15,
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
                                                    margin: EdgeInsets.only(

                                                        right: 30,
                                                        top: 6,
                                                        bottom: 6),
                                                    padding: EdgeInsets.only(
                                                        left: 25,
                                                        right: 25,
                                                        top: 6,
                                                        bottom: 6),
                                                    decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                    child: Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                      ),
                                                    )),
                                              ],
                                            ),
                                            onTap: () {




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
                          )
                    :
                      Container(
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                            color:paymentStatusList[index].payment_status == "Paid"?Colors.green:Colors.grey[100],
                            borderRadius: BorderRadius.circular(10)
                        ),
                        margin: EdgeInsets.only(left: 15, ),
                        padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5 ),
                       *//* child: Text(
                          paymentStatusList[index].payment_status,
                          style: TextStyle(
                              fontFamily: 'HelveticaNeueMedium',
                              color: Colors.white,
                              fontSize: 16),
                        ),*//*
                      )*/
                            ,
                          ],
                        )

                    ) ,
                  );
              })


    );
  }




}
class PaymentStatusModel {
  List<Data>? data;

  PaymentStatusModel({this.data});

  PaymentStatusModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? monthName;
  String? status;

  Data({this.monthName, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    monthName = json['month_name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month_name'] = this.monthName;
    data['status'] = this.status;
    return data;
  }
}

class EmptyModel {
  dynamic month_name;
  dynamic month_id;
  dynamic payment_status;


  EmptyModel({
    this.month_name,
    this.month_id,
    this.payment_status,
  });

  EmptyModel.fromJson(Map<String, dynamic> json) {
    month_name = json['month_name'];
    month_id = json['month_id'];
    payment_status = json['payment_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month_name'] = this.month_name;
    data['month_id'] = this.month_id;
    data['payment_status'] = this.payment_status;
    return data;
  }
}