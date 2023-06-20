import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../global/PrefKeys.dart';
import '../global/config.dart';

class LoginApi {
  Future<dynamic> onLoginAPI(String mobile_code, String mobile) async {
    try {
      final uri = Uri.parse(Config.apiurl + Config.login);
      debugPrint("login url: $uri");

      var headers = {
        'Content-Type': 'application/json',
        'Accept':'application/json',
      };

      final body = {
        "device_token":
            '${PrefObj.preferences!.get(PrefKeys.MAMA_APP_DEVICE_TOKEN)}',
        "mobile_code": mobile_code,
        "mobile": mobile
      };
      debugPrint("body  : $body");

      var response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body), // use jsonEncode()
      );
      debugPrint("response  : $response");

        return response;


    } catch (exception) {
      print('exception---- $exception');
      return null;
    }
  }
}
