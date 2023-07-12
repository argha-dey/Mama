import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mama/screens/auth/success_otp_screen.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../global/global.dart';
import '../../localizations/app_localizations.dart';
import 'package:http/http.dart' as http;

import '../../repository/repository.dart';

class OTPScreen extends StatefulWidget {
  final String? phoneNo;
  final String? countryCode;
  final String? verificationId;
  const OTPScreen(
      {Key? key, this.phoneNo, this.countryCode, this.verificationId})
      : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  OtpFieldController otpFieldController = OtpFieldController();
  String pinValue = '';
  bool isTimeExpired = false;
  final repository = Repository();
  String? verificationId;
  Timer? _timer;
  int _start = 179;



  void verifyOTPFirebase(verificationId) async {
    try {
      global().showLoader(context);
      FirebaseAuth _auth = FirebaseAuth.instance;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: pinValue);


      await _auth.signInWithCredential(credential).

      catchError((e) async{
        pinValue = '';
        global().hideLoader(context);
        global().showSnackBarShowError(context, e.message);
      }
      ).then((value) {
        global().hideLoader(context);
        if (value.user != null) {


          /*  if (value.credential.token) {

        }  */
          //    debugPrint(" otp pin :" +value.credential!.token.toString());
          print("You are logged in successfully");
          pinValue = '';
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) =>
                OtpSuccessScreen(
                  phoneNo: widget.phoneNo,
                  countryCode: widget.countryCode,
                )),
          );
        } else {
          pinValue = '';
          global().showSnackBarShowError(context, "User Not Exist");
        }
      });
    } catch (e) {
      print("Error: $e");
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verificationId = widget.verificationId;

    Future.delayed(const Duration(seconds: 180), () {
      setState(() async { //Replace setState with your state management
        await FirebaseAuth.instance.signOut();
      });

    });
    startTimer();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);

    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            isTimeExpired = true;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }
  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 180,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(
                Translation.of(context)!.translate('verify_otp')!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'HelveticaNeueBold',
                  fontSize: 23,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(Translation.of(context)!.translate('enter_the_otp')!,
                  style: TextStyle(
                      color: Color.fromRGBO(128, 128, 128, 1),
                      fontSize: 15,
                      fontFamily: 'HelveticaNeueLight'),
                  textAlign: TextAlign.center),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            margin: EdgeInsets.only(left: 25, right: 25),
            child: OTPTextField(
              controller: otpFieldController,
              keyboardType: TextInputType.number,
              length: 6,
              width: MediaQuery.of(context).size.width,
              fieldWidth: 50,
              otpFieldStyle: OtpFieldStyle(
                  disabledBorderColor: Color.fromRGBO(5, 119, 128, 1),
                  enabledBorderColor: Color.fromRGBO(5, 119, 128, 1)),
              style: TextStyle(fontSize: 17),
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldStyle: FieldStyle.underline,
              onCompleted: (pin) {
                pinValue = pin;
                print("Completed: " + pinValue);
              },
              onChanged: (pin) {
                print("check : " + pin);
              },
            ),
          ),
          SizedBox(
            height: 70,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(
                Translation.of(context)!.translate('if_you_dont')!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(128, 128, 128, 1),
                    fontSize: 15,
                    fontFamily: 'HelveticaNeueLight'),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(child:  InkWell(
                onTap: (){
                  FirebaseSmsOtpReSend(widget.phoneNo.toString(),widget.countryCode.toString(),context);
                },
                child:  Container(
                  //  margin: EdgeInsets.only(left: 15),
                  child: Text(
                    Translation.of(context)!.translate('resend_otp')!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'HelveticaNeueLight',
                        fontSize: 15,
                        color: Color.fromRGBO(5, 119, 128, 1)),
                  ),
                ),
              ),
                visible: isTimeExpired,),


              Visibility(child:
              Container(
                //  margin: EdgeInsets.only(left: 15),
                child: Text(" " + Translation.of(context)!.translate('in')! +  "  $_start"+"s",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'HelveticaNeueLight',
                      fontSize: 15,
                      color: Color.fromRGBO(128, 128, 128, 1)),
                ),
              ),
                visible: !isTimeExpired,
              )
            ],
          ),
          SizedBox(
            height: 130,
          ),
          Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {

                  if(pinValue.toString().length == 6)
                  { verifyOTPFirebase(verificationId);
                  }
                  else{
                    global().showSnackBarShowError(context, "Please Input Proper OTP !");
                  }
                },
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
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
                            Translation.of(context)!.translate('verify')!,
                            // textAlign: TextAlign.center,
                            style:
                            TextStyle(color: Colors.white, fontSize: 19),
                          ),
                        ),
                      ],
                    )),
              )),
        ],
      ),
    );
  }

  Future<void> FirebaseSmsOtpReSend(String phone, String countryCode,BuildContext context) async {
    global().showLoader(context);
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
      phoneNumber: "+" + countryCode + phone,
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        //  Loader().hideLoader(context);
        //  print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        global().hideLoader(context);
        verificationId = verificationId;

      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Loader().hideLoader(context);
      },
    );
  }
  dynamic onLogin() async {
    // show loader
    global().showLoader(context);
    var countryCode = "+"+widget.countryCode!;
    final http.Response response = await repository.onLoginApi(countryCode.toString(),widget.phoneNo.toString());
    Map<String, dynamic> map = json.decode(response.body);
    var loginStatus = map["status"];
    global().hideLoader(context);
    if (loginStatus) {

      /*LoginModel loginModel = LoginModel.fromJson(jsonDecode(response.body));
      var loginotp = loginModel.data!.otp.toString();
      var loginphn = loginModel.data!.phoneNo.toString();*/
      //  debugPrint("login otp : $loginotp");
      //   showRedSnackBar(context, loginotp);


      // loginUser(phnNo.text, context);
      //    loginUser(phnNo.text,loginotp, context);


    } else {
      /* showRedSnackBar(context, Translation.of(context)!.translate('not_valid')!
      );*/

/*      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              signUpMsg,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xff128807),
              ),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.yellow,
                  ),
                  child: Text(
                    'OK',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    / /   Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StartingScreen2(),
                        ));*/ /*

                  },
                ),
              ),
            ],
          );
        },
      );*/
    }
  }
}
