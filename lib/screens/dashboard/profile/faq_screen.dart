import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../global/PrefKeys.dart';
import '../../../global/config.dart';
import '../../../global/global.dart';
import '../../../model/faq_model.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  FaqModel? faqData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  getNotificationListBloc.getNotificationListBlocSink();

    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        GetFaq();
      });
    });
  }

  Future<void> GetFaq() async {
    try {
      global().showLoader(context);
      final uri = Uri.parse(Config.apiurl + Config.faq);
      debugPrint("faq url: $uri");

      var requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        "timezone":
        '${PrefObj.preferences!.get(PrefKeys.MAMA_APP_TIME_ZONE)}',
        'Accept-Language': 'en'
      };

      final response = await http.get(uri, headers: requestHeaders);
      debugPrint(
          "faq response : " + json.decode(response.body).toString());

      global().hideLoader(context);

      dynamic responseJson;
      if (response.statusCode == 200) {
        setState(() {
          responseJson = json.decode(response.body);
          faqData = FaqModel.fromJson(responseJson);
          debugPrint("success");
        });
      } else {
        global().showSnackBarShowError(context, 'Failed to get Data!');
      }
    } catch (e) {
      global().hideLoader(context);
      print('==>Failed ');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:  Color.fromRGBO(5, 119, 128,1),
        title: Text(
          "Faq",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 19),
        ),
        leading: IconButton(
            icon: new Icon(Icons.keyboard_backspace_outlined),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20, top: 5),
        child: Text(faqData?.data?.content == null
            ? ""
            : faqData!.data!.content!.toString()),
      ),
    );
  }
}
