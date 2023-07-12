import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../global/PrefKeys.dart';
import '../global/config.dart';

class AcceptDeclineApi {
  Future<dynamic> onAcceptDeclineApi(String approveStatus,String memberId,String groupId) async {
    try {
      final uri = Uri.parse(Config.apiurl + Config.joiningreq +"/"+memberId );
      debugPrint("accept-decline url: $uri");

      var headers = {
        'Content-Type':'application/json',
        'Accept':'application/json',
        "Accept-Language":"en",
        "timezone":
        '${PrefObj.preferences!.get(PrefKeys.MAMA_APP_TIME_ZONE)}',
        "Authorization":'Bearer '+'${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}'
      };

      final body = {
    /*    "user_id": memberId,
        "group_id": groupId,*/
        "approve_status": approveStatus,

      };
      debugPrint("accept-decline body  : $body");

      var response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode(body), // use jsonEncode()
      );
      //  final response = await http.post(uri, body: requestPostData, headers: requestHeaders);



      dynamic responseJson;

      if (response.statusCode == 200) {
        debugPrint("accept decline response : ${json.decode(response.body)}");
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
