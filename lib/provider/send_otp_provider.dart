import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../global/PrefKeys.dart';
import '../global/config.dart';

class SendOtpApi {
  Future<dynamic> onSendOtpApi(String mobile_code, String mobile) async {
    try {
      final uri = Uri.parse(Config.apiurl + Config.register);
      debugPrint("send otp url: $uri");

      var headers = {
        'Content-Type': 'application/json',
      };

      final body = {
        "device_token":
        '${PrefObj.preferences!.get(PrefKeys.MAMA_APP_DEVICE_TOKEN)}',
        "lang": "en",
        "mobile_code": mobile_code,
        "mobile": mobile
      };
      debugPrint("body  : $body");

      var response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body), // use jsonEncode()
      );
      //  final response = await http.post(uri, body: requestPostData, headers: requestHeaders);

      dynamic responseJson;

      if (response.statusCode == 200) {
        debugPrint("login response : ${json.decode(response.body)}");
        return response;

        // return LoginModel.fromJson(responseJson);
      } else {
        return null;
      }
    } catch (exception) {
      print('exception---- $exception');
      return null;
    }
  }
}
