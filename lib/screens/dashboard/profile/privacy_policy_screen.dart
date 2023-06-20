import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../global/PrefKeys.dart';
import '../../../global/config.dart';
import '../../../global/global.dart';
import '../../../model/privacy_policy_model.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  PrivacyModel? privacyData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  getNotificationListBloc.getNotificationListBlocSink();

    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        GetPrivacyPolicy();
      });
    });
  }

  Future<void> GetPrivacyPolicy() async {
    try {

      global().showLoader(context);
      final uri = Uri.parse(Config.apiurl + Config.privacy);
      debugPrint("privacy policy url: $uri");

      var requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
        'Bearer ' + '${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}',
        'Accept-Language': 'en'
      };

      final requestBody = {};
      //   debugPrint("polling list url: $requestHeaders");

      final response = await http.get(uri, headers: requestHeaders);
      debugPrint("privacy  response : " + json.decode(response.body).toString());

      global().hideLoader(context);

      dynamic responseJson;
      if (response.statusCode==201||response.statusCode==200) {
        setState(() {

          responseJson = json.decode(response.body);
          privacyData = PrivacyModel.fromJson(responseJson);

        });
      } else {
        global()
            .showSnackBarShowError(context, 'Failed to get Data!');
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
          "Privacy Policy",
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
        margin: EdgeInsets.only(left: 20,top: 5),
        child: Text(privacyData?.data?.content == null ? "": privacyData!.data!.content!.toString()),
      ),
    );;
  }
}
