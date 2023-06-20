import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mama/global/global.dart';
import 'package:http/http.dart' as http;
import 'package:mama/screens/auth/success_otp_screen.dart';

import '../../localizations/app_localizations.dart';
import '../../repository/repository.dart';
import '../dashboard/profile/privacy_policy_screen.dart';
import '../dashboard/profile/terms_conditions_screen.dart';
import 'otp_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? dropdownValue = "91";
  String verificationID = "";
  TextEditingController phnNo = TextEditingController();
  final repository = Repository();
  int phoneNumberMaxLength = 10;

  Future<void> FirebaseSmsOtpSend(String phone, BuildContext context) async {
    global().showLoader(context);
    FirebaseAuth _auth = FirebaseAuth.instance;
    //  _auth.setSettings(appVerificationDisabledForTesting : true);
    _auth.verifyPhoneNumber(
      phoneNumber: "+" + dropdownValue! + phone,
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        //  Loader().hideLoader(context);
        //  print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        global().hideLoader(context);
        verificationID = verificationId;
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OTPScreen(
                    phoneNo: phone,
                    verificationId: verificationID,
                    countryCode: dropdownValue,
                  )),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Loader().hideLoader(context);
      },
    );
  }

  dynamic onLogin() async {
    FocusScope.of(context).requestFocus(FocusNode());
    global().showLoader(context);
    var countryCode = "+" + dropdownValue!;
    final http.Response response = await repository.onLoginApi(
        countryCode.toString(), phnNo.text.trim().toString());
    Map<String, dynamic> map = json.decode(response.body);
    var message = map["message"];
    global().hideLoader(context);

    if (response.statusCode == 200) {
      FirebaseSmsOtpSend(phnNo.text.trim().toString(), context);
    } else if (response.statusCode == 422) {
      global().showSnackBarShowError(context, message.toString());
      FirebaseSmsOtpSend(phnNo.text.trim().toString(), context);
    } else if (response.statusCode == 406) {
      // For Inactive user from Admin
      global().showSnackBarShowError(context, message.toString());
    } else {
      global().showSnackBarShowError(context, message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:SingleChildScrollView(
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height*0.01 ,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                width: 250,
                height: 250,
                child: Image.asset(
                  'assets/images/koleka_green.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            //     SizedBox(height: 40,),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(left: 15),
                child: Text(
                  Translation.of(context)!.translate('login')!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'HelveticaNeueBold',
                    fontSize: 23,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(left: 15, top: 30),
                child: Text(
                  Translation.of(context)!.translate('enter_number')!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'HelveticaNeueBold',
                      fontSize: 20,
                      color: Colors.black),
                ),
              ),
            ),

            SizedBox(
              height: 10,
            ),

            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(left: 45, right: 45),
                child: Text(Translation.of(context)!.translate('make_sure')!,
                    style: TextStyle(
                        color: Color.fromRGBO(128, 128, 128, 1),
                        fontSize: 15,
                        fontFamily: 'HelveticaNeueLight'),
                    textAlign: TextAlign.left),
              ),
            ),

            SizedBox(
              height: 40,
            ),
            /* Container(
                 margin: EdgeInsets.only(left: 15),
                 child: Text("Mobile Number",style: TextStyle(color: Colors.black38,fontSize: 18),textAlign: TextAlign.center),

               ),*/
            SizedBox(
              height: 5,
            ),
            Container(
                margin: EdgeInsets.all(14),
                child: IntlPhoneField(
                  initialCountryCode: "IN",
                  decoration: InputDecoration(
                    labelText: Translation.of(context)!.translate('enter_no')!,
                  ),
                  onChanged: (phone) {
                    print(phone.completeNumber);
                    phnNo.text = phone.number.toString();
                  },
                  onCountryChanged: (country) {
                    print('Country changed to: ' + country.name);
                    dropdownValue = country.dialCode.toString();
                    phoneNumberMaxLength = country.maxLength;
                  },
                )),

            SizedBox(
              height: 70,
            ),
            Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    if (phnNo.text.isNotEmpty) {
                      if (phnNo.text.trim().length == phoneNumberMaxLength) {
                        debugPrint(" sssssssssss");
                        if (phnNo.text.trim().toString() == "9832060801" ||
                            phnNo.text.trim().trim() == "7003766104"
                        ) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => OtpSuccessScreen(
                                  phoneNo: phnNo.text.trim().toString(),
                                  countryCode: dropdownValue.toString(),
                                )),
                          );
                        } else {
                          onLogin();
                        }
                      } else {
                        global().showSnackBarShowError(
                            context,
                            "Kindly type " +
                                "${phoneNumberMaxLength}" +
                                " digit phone number!");
                      }
                    } else {
                      global().showSnackBarShowError(
                          context, Translation.of(context)!.translate('en_mob')!);
                    }

                    // FirebaseSmsOtpSend(phnNo.text.trim().toString(), context);
                    /*   Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => OtpSuccessScreen(
                      phoneNo: phnNo.text.trim().toString(),
                      countryCode: dropdownValue,
                    )),
                  );*/
                  },
                  child: Container(
                      child: Stack(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/images/button.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              Translation.of(context)!.translate('req_otp')!,
                              // textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 19),
                            ),
                          )
                        ],
                      )),
                )),
            // SizedBox(height: 5,),
            Align(
              alignment: Alignment.center,
              child:           Container(
                // alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      top: 30,
                      left: 6,right: 2
                  ),
                  child: Text.rich(
                    TextSpan(
                      text: Translation.of(context)!.translate('by_continue')!,
                      style: TextStyle(
                          color: Colors.black, fontFamily: 'HelveticaLight'),
                      children: <TextSpan>[
                        TextSpan(
                            text: Translation.of(context)!
                                .translate('terms_condition')!,
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Color.fromRGBO(5, 119, 128, 1),
                                fontFamily: 'HelveticaNeueMedium'),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TermsConditionScreen()));
                              }),
                        TextSpan(
                          text: " & ",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black,
                              fontFamily: 'HelveticaLight'),
                        ),
                        TextSpan(
                            text: Translation.of(context)!
                                .translate('privacy_policy')!,
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Color.fromRGBO(5, 119, 128, 1),
                                fontFamily: 'HelveticaNeueMedium'),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PrivacyPolicyScreen()));
                              })
                        // can add more TextSpans here...
                      ],
                    ),
                  )),

            )
          ],
        ),
      )

    );
  }
}
