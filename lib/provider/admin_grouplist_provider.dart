import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../global/PrefKeys.dart';
import '../global/config.dart';
import '../model/admin_grouplist_model.dart';
import '../model/group_model.dart';


class AdminGroupListApi {
  Future<dynamic> onAdminGroupListApi(
      String searchText
      ) async {
    try {
      final uri = Uri.parse(Config.apiurl + Config.adminGrouplist);
      debugPrint("admin group list url: $uri");



      var headers = {
        'Content-Type':'application/json',
        'Authorization': 'Bearer  '+'${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}',
        'Accept-Language' : 'en'
      };

      final body = {
        "member_type":"admin"
      };


      var response = await http.get(
        uri,
        headers: headers,
        //body: jsonEncode(body), // use jsonEncode()
      );
      //  final response = await http.post(uri, body: requestPostData, headers: requestHeaders);



      dynamic responseJson;

      if (response.statusCode == 200) {

        responseJson = json.decode(response.body);
        debugPrint("admin group list response : $responseJson");
        return AdminGroupListModel.fromJson(responseJson);

      }  else {
        return null;
      }
    } catch (exception) {
      print('exception---- $exception');
      return null;
    }
  }
}
