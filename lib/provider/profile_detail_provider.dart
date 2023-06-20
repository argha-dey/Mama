import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../global/PrefKeys.dart';
import '../global/config.dart';
import '../model/group_model.dart';
import '../model/profile_detail_model.dart';


class ProfileDetailApi {
  Future<dynamic> onProfileDetailApi(
      ) async {
    try {
      final uri = Uri.parse(Config.apiurl + Config.profileDetail);
      debugPrint("profile detail url: $uri");



      var headers = {
        'Accept':'application/json',
        'Content-Type':'application/json',
        'Authorization': 'Bearer  '+'${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}',
        'Accept-Language' : 'en'
      };

      debugPrint("headers url: $headers");


      var response = await http.post(uri, headers: headers);
      //  final response = await http.post(uri, body: requestPostData, headers: requestHeaders);



      dynamic responseJson;

      if (response.statusCode == 200) {

        responseJson = json.decode(response.body);
        debugPrint("profile detail response : $responseJson");
        return ProfileDetailsModel.fromJson(responseJson);

      }  else {
        return null;
      }
    } catch (exception) {
      print('exception---- $exception');
      return null;
    }
  }
}
