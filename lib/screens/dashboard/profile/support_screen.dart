import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../global/config.dart';
import '../../../global/global.dart';
import '../../../model/support_model.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  SupportModel? supportData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  getNotificationListBloc.getNotificationListBlocSink();

    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        GetSupport();
      });
    });
  }

  Future<void> GetSupport() async {
    try {
      global().showLoader(context);
      final uri = Uri.parse(Config.apiurl + Config.support);
      debugPrint("support url: $uri");

      var requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Accept-Language': 'en'
      };

      final response = await http.get(uri, headers: requestHeaders);
      debugPrint(
          "support response : " + json.decode(response.body).toString());

      global().hideLoader(context);

      dynamic responseJson;
      if (response.statusCode == 200) {
        setState(() {
          responseJson = json.decode(response.body);
          supportData = SupportModel.fromJson(responseJson);
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
          "Support",
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
        child: Text(supportData?.data?.content == null
            ? ""
            : supportData!.data!.content!.toString()),
      ),
    );
  }
}
