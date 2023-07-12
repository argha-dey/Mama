

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../global/PrefKeys.dart';
import '../global/config.dart';


class JoiningReqApi {
  Future<dynamic> onJoiningReqApi(
      String userid, String groupid
      ) async {
    try {
      final uri = Uri.parse(Config.apiurl + Config.joiningreq);
      debugPrint("joining req url: $uri");



      var headers = {
        'Content-Type':'application/json',
        'Accept':'application/json',
        "timezone":
        '${PrefObj.preferences!.get(PrefKeys.MAMA_APP_TIME_ZONE)}',
        "Accept-Language":"en",
        "Authorization":'Bearer '+'${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}'
      };

      final body = {

          "user_id": userid,
          "group_id": groupid,
          "approve_status": "0",
          "member_type": "member"

      };
      log("body  : $body");

      var response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body), // use jsonEncode()
      );
      //  final response = await http.post(uri, body: requestPostData, headers: requestHeaders);


      return response;
      dynamic responseJson;

      if (response.statusCode == 200) {
        debugPrint("joining req response : ${json.decode(response.body)}");
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
