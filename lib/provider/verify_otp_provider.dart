import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../global/PrefKeys.dart';
import '../global/config.dart';


class VerifyOTPApi {
  Future<dynamic> onVerifyOTPApi(String otp,String mobile,String code
      ) async {
    try {
      final uri = Uri.parse(Config.apiurl + Config.verifyOtp);
      debugPrint("verify otp url: $uri");



      var headers = {
        "timezone":
        '${PrefObj.preferences!.get(PrefKeys.MAMA_APP_TIME_ZONE)}',
        'Content-Type':'application/json',


      };

      final body = {
        "device_token" :'${PrefObj.preferences!.get(PrefKeys.MAMA_APP_DEVICE_TOKEN)}',
        "lang" : "en",
        "mobile" : mobile,
        "code" : code,
        "OTP": otp
      };


      var response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body), // use jsonEncode()
      );
      //  final response = await http.post(uri, body: requestPostData, headers: requestHeaders);



      dynamic responseJson;

      if (response.statusCode == 200) {

        //  responseJson = json.decode(response.body);
        debugPrint("verifyotp response : ${json.decode(response.body)}");
        return response;
      }
      if (response.statusCode == 403) {

        //  responseJson = json.decode(response.body);
        debugPrint("verifyotp response : ${json.decode(response.body)}");
        return response;
      }
      else {
        return null;
      }

    } catch (exception) {
      print('exception---- $exception');
      return null;
    }
  }
}
