

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../global/PrefKeys.dart';
import '../global/config.dart';
import '../screens/polling/polling_create_screen.dart';


class PollingCreateApi {
  Future<dynamic> onPollingCreateApi(
      String pollingName, String startDateTime,String endDateTime,String pollingQuestion,List<PollingQstnModel> pollQstnList
      ,String groupId ) async {
    try {
      final uri = Uri.parse(Config.apiurl + Config.pollingCreate);
      debugPrint("polling create url: $uri");


      //    String pollQstnListjson =  json.encode(pollQstnList);

      //  debugPrint("pollQstnListjson: $pollQstnListjson");

      Map<String, dynamic> _requestBody = <String, dynamic>{

        "name_en": pollingName,
        "name_fr": pollingName,
        "image": "image",
        "description": "description",
        "active_status": 1,
        "start_on": startDateTime,
        "end_on": endDateTime,
        "group_id":groupId,
        "created_by":PrefObj.preferences!.get(PrefKeys.USER_ID).toString(),
        "polling_question":List<dynamic>.from(pollQstnList.map((x) => x)),

      };
      var _body = json.encode(_requestBody);

      debugPrint("_body: $_body");

      var headers = {
        'Content-Type':'application/json',
        'Accept':'application/json',
        "timezone":
        '${PrefObj.preferences!.get(PrefKeys.MAMA_APP_TIME_ZONE)}',
        "Accept-Language":"en",
        'Authorization': 'Bearer '+'${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}',

      };



/*      final body =
      {
        "name_en": pollingName,
        "name_fr": pollingName,
        "image": "image",
        "description": "description",
        "active_status": 1,
        "start_on": startDateTime,
        "end_on": endDateTime,
        "created_by": 1,
        "polling_question":jsonVar


      };*/


      var response = await http.post(
        uri,
        headers: headers,
        body: _body, // use jsonEncode()
      );
      //  final response = await http.post(uri, body: requestPostData, headers: requestHeaders);



      /*dynamic responseJson;

      if (response.statusCode == 200) {
        debugPrint("polling create response : ${json.decode(response.body)}");
        return response;

        // return LoginModel.fromJson(responseJson);
      }
      else {
        return null;
      }*/
      return response;

    } catch (exception) {
      print('exception---- $exception');
      return null;
    }
  }
}
