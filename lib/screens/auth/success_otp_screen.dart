import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mama/screens/auth/profile_fillup_screen.dart';
import 'package:http/http.dart' as http;
import 'package:mama/screens/dashboard/dashboard_screen.dart';

import '../../global/PrefKeys.dart';
import '../../global/global.dart';
import '../../localizations/app_localizations.dart';
import '../../repository/repository.dart';

class OtpSuccessScreen extends StatefulWidget {
  final String? phoneNo;
  final String? countryCode;
  const OtpSuccessScreen({Key? key, this.phoneNo, this.countryCode})
      : super(key: key);

  @override
  State<OtpSuccessScreen> createState() => _OtpSuccessScreenState();
}

class _OtpSuccessScreenState extends State<OtpSuccessScreen> {
  final repository = Repository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
          ),
          Center(
            child: Container(
              width: 120,
              height: 120,
              child: Image.asset(
                'assets/images/succes.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 25),
            child: Text(
              Translation.of(context)!.translate('otp_verified')!,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'HelveticaNeueLight',
                  fontSize: 17,
                  color: Colors.green),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          InkWell(
            child: Container(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset('assets/images/button.png',
                        fit: BoxFit.contain),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      top: 10,
                    ),
                    child: Text(
                      Translation.of(context)!.translate('continue')!,
                      // textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 21),
                    ),
                  )
                ],
              ),
            ),
            onTap: () {
              // For Checking
              onLogin();
            },
          ),
        ],
      )),
    );
  }

  dynamic onLogin() async {
    global().showLoader(context);
    var countryCode = "+" + widget.countryCode!;
    final http.Response response = await repository.onLoginApi(
        countryCode.toString(), widget.phoneNo.toString());
    Map<String, dynamic> map = json.decode(response.body);
    var message = map["message"];
    global().hideLoader(context);

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      var access_token = map["access_token"];
      var userId = map["user"]["user_id"];
      var userType = map["user"]["user_type"];
      var name = map["user"]["name_en"];
      debugPrint("@@@ token : ${access_token}");
      debugPrint("@@@ userId : ${userId}");
      debugPrint("@@@ userType : ${userType}");
      debugPrint("@@@ userName : ${name}");

      PrefObj.preferences!.put(PrefKeys.AUTH_TOKEN, access_token);
      PrefObj.preferences!.put(PrefKeys.IS_LOGIN_STATUS, true);
      PrefObj.preferences!.put(PrefKeys.USER_ID, userId);
      PrefObj.preferences!.put(PrefKeys.USER_NAME, name);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => DashboardScreen()),
      );
    } else if (response.statusCode == 422) {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => ProfileFillupScreen(
                  countryCode: widget.countryCode,
                  phoneNo: widget.phoneNo,
                )),
      );
    } else if (response.statusCode == 406) {
      // For Inactive user from Admin
      global().showSnackBarShowError(context, message.toString());
    } else {
      global().showSnackBarShowError(context, message.toString());
    }
  }
}
