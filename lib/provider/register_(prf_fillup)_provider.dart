

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../global/PrefKeys.dart';
import '../global/config.dart';


class RegisterPrfFillupApi {
  Future<dynamic> onRegisterPrfFillupApi(String name, String mobile, String mobile_code,String email,String address,String birth,int group_type,int rol,String img
      ) async {
    try {
      final uri = Uri.parse(Config.apiurl + Config.register);
      debugPrint("register url: $uri");



      var headers = {
        'Content-Type':'application/json',
         'Accept':'application/json',
        "Accept-Language":"en"
      };

      final body = {
        "device_token" :'${PrefObj.preferences!.get(PrefKeys.MAMA_APP_DEVICE_TOKEN)}',

        "name_en" : name,
        "name_fr" : name,
        "email" : email,
        "mobile_code": mobile_code,
        "mobile" : mobile,
        "address" : address,
        "date_of_birth": birth,
        "user_type":"member",
        "group_type" : group_type,
        "user_role" : rol,
        "profile_image" :"data:image/png;base64,"+ img

      };
      log("body  : $body");

      var response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body), // use jsonEncode()
      );
      //  final response = await http.post(uri, body: requestPostData, headers: requestHeaders);



      dynamic responseJson;

      if (response.statusCode == 200) {
        debugPrint("register response : ${json.decode(response.body)}");
        return response;

        // return LoginModel.fromJson(responseJson);
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
