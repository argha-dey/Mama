import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../global/PrefKeys.dart';
import '../global/config.dart';

class AdminRatingApi {
  Future<dynamic> onAdminRatingApi(double point, String reviewable_id,String targetable_id, String description) async {
    try {
      final uri = Uri.parse(Config.apiurl + Config.rateAdmin);
      debugPrint("rate Admin url: $uri");

      var headers = {
        'Content-Type': 'application/json',
        'Accept':'application/json',
        "Accept-Language":"en",
        "Authorization":'Bearer '+'${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}'
      };

      final body = {
        "point": point,
        "reviewable_id": reviewable_id,
        "targetable_id": targetable_id,
        "description": description

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
