import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../global/PrefKeys.dart';
import '../global/config.dart';
import '../model/group_model.dart';


class GroupApi {
  Future<dynamic> onGroupApi(
       String searchText
        ) async {
    try {
      final uri = Uri.parse(Config.apiurl + Config.group);
      debugPrint("group url: $uri");



      var headers = {
        'Content-Type':'application/json',
        "timezone":
        '${PrefObj.preferences!.get(PrefKeys.MAMA_APP_TIME_ZONE)}',
        'Authorization': 'Bearer  '+'${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}',
        'Accept-Language' : 'en'
      };

      final body = {
        "name_en":searchText,
        "name_fr":searchText
      };


      var response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body), // use jsonEncode()
      );
      //  final response = await http.post(uri, body: requestPostData, headers: requestHeaders);



      dynamic responseJson;

      if (response.statusCode == 200) {

        responseJson = json.decode(response.body);
        debugPrint("group response : $responseJson");
        return GroupModel.fromJson(responseJson);

      }  else {
        return null;
      }
    } catch (exception) {
      print('exception---- $exception');
      return null;
    }
  }
}
