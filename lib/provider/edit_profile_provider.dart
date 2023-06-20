

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../global/PrefKeys.dart';
import '../global/config.dart';


class EditProfileApi {
  Future<dynamic> onEditProfileApiApi(String userid,String name,String email,String address,String birth,int group_type,int rol,String img
      ) async {
    try {
      final uri = Uri.parse(Config.apiurl + Config.editprofile + userid);
      debugPrint("edit profile url: $uri");



      var headers = {
        'Content-Type':'application/json',
        'Accept':'application/json',
        "Accept-Language":"en",
        "Authorization":'Bearer '+'${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}'
      };
      final body;


      img.isEmpty|| img==""?   body = {
        "device_token" :'${PrefObj.preferences!.get(PrefKeys.MAMA_APP_DEVICE_TOKEN)}',
        "name_en" : name,
        "name_fr" : name,
        "email" : email,
        "address" : address,
        "date_of_birth": birth,
        "user_type":"member",
        "group_type" : group_type,
        "user_role" : rol,

      }:
      body = {
        "device_token" :'${PrefObj.preferences!.get(PrefKeys.MAMA_APP_DEVICE_TOKEN)}',

        "name_en" : name,
        "name_fr" : name,
        "email" : email,
        "address" : address,
        "date_of_birth": birth,
        "user_type":"member",
        "group_type" : group_type,
        "user_role" : rol,
        "profile_image":"data:image/png;base64,"+ img
      };

      log("body  : $body");

      var response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode(body), // use jsonEncode()
      );
      //  final response = await http.post(uri, body: requestPostData, headers: requestHeaders);



      dynamic responseJson;

      if (response.statusCode == 200) {
        debugPrint("edit profile response : ${json.decode(response.body)}");
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
