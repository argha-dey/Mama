import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../global/PrefKeys.dart';
import '../../localizations/app_localizations.dart';
import '../auth/profile_fillup_screen.dart';
import '../auth/sign_up_screen.dart';
import '../dashboard/profile/privacy_policy_screen.dart';
import '../dashboard/profile/terms_conditions_screen.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    if (PrefObj.preferences!.get(PrefKeys.LANG).toString() == 'en' ||
        PrefObj.preferences!.get(PrefKeys.LANG) == null) {
      PrefObj.preferences!.put(PrefKeys.LANG, 'en');
    } else {
      PrefObj.preferences!.put(PrefKeys.LANG, 'fr');
    }
    Navigator.of(context).push(
      //MaterialPageRoute(builder: (_) => ProfileFillupScreen()),
      MaterialPageRoute(builder: (_) => SignUpScreen()),
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset(
      'assets/images/$assetName',
      fit: BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,

      rawPages: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/images/background.png',
                  ),
                  fit: BoxFit.cover)),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Container(
                width: 280,
                height: 280,
                child: Image.asset(
                  'assets/images/koleka_white.png',
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                Translation.of(context)!.translate('welcome_mama')!,
                textAlign: TextAlign.center,
                style: (TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontFamily: 'HelveticaNeueBold')),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(left: 35, right: 35),
                child: Text(Translation.of(context)!.translate('south_africa')!,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'HelveticaNeueMedium'),
                    textAlign: TextAlign.left),
              ),
              SizedBox(
                height: 95,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.14,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: EdgeInsets.only(left: 30, right: 20),
                    child: Text.rich(
                      TextSpan(
                        text: Translation.of(context)!.translate('read_our')!,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'HelveticaLight'),
                        children: <TextSpan>[
                          TextSpan(
                              text: Translation.of(context)!
                                  .translate('privacy_policy')!,
                              style: TextStyle(
                                  //   decoration: TextDecoration.underline,
                                  color: Colors.white,
                                  fontFamily: 'HelveticaNeueMedium',
                                  fontSize: 13),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PrivacyPolicyScreen()));
                                }),
                          TextSpan(
                            text: Translation.of(context)!
                                .translate('agree_to_our')!,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'HelveticaLight',
                                fontSize: 13),
                          ),
                          TextSpan(
                              text: Translation.of(context)!
                                  .translate('terms_condition')!,
                              style: TextStyle(
                                  //  decoration: TextDecoration.underline,
                                  color: Colors.white,
                                  fontFamily: 'HelveticaNeueMedium',
                                  fontSize: 13),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TermsConditionScreen()));
                                }),
                          // can add more TextSpans here...
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Container(
                width: 160,
                height: 160,
                child: Image.asset(
                  'assets/images/free.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                Translation.of(context)!.translate('free')!,
                textAlign: TextAlign.center,
                style: (TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                    fontFamily: 'HelveticaNeueBold')),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(left: 35, right: 35),
                child: Text(
                    Translation.of(context)!.translate('mama_provides')!,
                    style: TextStyle(
                        color: Color.fromRGBO(128, 128, 128, 1),
                        fontSize: 15,
                        fontFamily: 'HelveticaNeueMedium'),
                    textAlign: TextAlign.left),
              ),
              SizedBox(
                height: 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.14,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Text.rich(
                      TextSpan(
                        text: Translation.of(context)!.translate('read_our')!,
                        style: TextStyle(
                            color: Color.fromRGBO(128, 128, 128, 1),
                            fontFamily: 'HelveticaLight',
                            fontSize: 13),
                        children: <TextSpan>[
                          TextSpan(
                              text: Translation.of(context)!
                                  .translate('privacy_policy')!,
                              style: TextStyle(
                                  //   decoration: TextDecoration.underline,
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontFamily: 'HelveticaNeueMedium'),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PrivacyPolicyScreen()));
                                }),
                          TextSpan(
                            text: Translation.of(context)!
                                .translate('agree_to_our')!,
                            style: TextStyle(
                                color: Color.fromRGBO(128, 128, 128, 1),
                                fontSize: 13,
                                fontFamily: 'HelveticaLight'),
                          ),
                          TextSpan(
                              text: Translation.of(context)!
                                  .translate('terms_condition')!,
                              style: TextStyle(
                                  //  decoration: TextDecoration.underline,
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontFamily: 'HelveticaNeueMedium'),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TermsConditionScreen()));
                                }),

                          // can add more TextSpans here...
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Container(
                width: 160,
                height: 160,
                child: Image.asset(
                  'assets/images/chat.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                Translation.of(context)!.translate('community_chat')!,
                textAlign: TextAlign.center,
                style: (TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                    fontFamily: 'HelveticaNeueBold')),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(left: 35, right: 35),
                child: Text(Translation.of(context)!.translate('mama_allows')!,
                    style: TextStyle(
                        color: Color.fromRGBO(128, 128, 128, 1),
                        fontSize: 15,
                        fontFamily: 'HelveticaNeueMedium'),
                    textAlign: TextAlign.left),
              ),
              SizedBox(
                height: 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.12,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Text.rich(
                      TextSpan(
                        text: Translation.of(context)!.translate('read_our')!,
                        style: TextStyle(
                            color: Color.fromRGBO(128, 128, 128, 1),
                            fontFamily: 'HelveticaLight',
                            fontSize: 13),
                        children: <TextSpan>[
                          TextSpan(
                              text: Translation.of(context)!
                                  .translate('privacy_policy')!,
                              style: TextStyle(
                                  //   decoration: TextDecoration.underline,
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontFamily: 'HelveticaNeueMedium'),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PrivacyPolicyScreen()));
                                }),
                          TextSpan(
                            text: Translation.of(context)!
                                .translate('agree_to_our')!,
                            style: TextStyle(
                                color: Color.fromRGBO(128, 128, 128, 1),
                                fontSize: 13,
                                fontFamily: 'HelveticaLight'),
                          ),
                          TextSpan(
                              text: Translation.of(context)!
                                  .translate('terms_condition')!,
                              style: TextStyle(
                                  //  decoration: TextDecoration.underline,
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontFamily: 'HelveticaNeueMedium'),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TermsConditionScreen()));
                                }),

                          // can add more TextSpans here...
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Container(
                width: 160,
                height: 160,
                child: Image.asset(
                  'assets/images/meeting.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                Translation.of(context)!.translate('meeting_admin')!,
                textAlign: TextAlign.center,
                style: (TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                    fontFamily: 'HelveticaNeueBold')),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(left: 35, right: 35),
                child: Text(
                    Translation.of(context)!.translate('mama_provides_member')!,
                    style: TextStyle(
                        color: Color.fromRGBO(128, 128, 128, 1),
                        fontSize: 15,
                        fontFamily: 'HelveticaNeueMedium'),
                    textAlign: TextAlign.left),
              ),
              SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 106,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Text.rich(
                      TextSpan(
                        text: Translation.of(context)!.translate('read_our')!,
                        style: TextStyle(
                            color: Color.fromRGBO(128, 128, 128, 1),
                            fontFamily: 'HelveticaLight',
                            fontSize: 13),
                        children: <TextSpan>[
                          TextSpan(
                              text: Translation.of(context)!
                                  .translate('privacy_policy')!,
                              style: TextStyle(
                                  //   decoration: TextDecoration.underline,
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontFamily: 'HelveticaNeueMedium'),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PrivacyPolicyScreen()));
                                }),
                          TextSpan(
                            text: Translation.of(context)!
                                .translate('agree_to_our')!,
                            style: TextStyle(
                                color: Color.fromRGBO(128, 128, 128, 1),
                                fontSize: 13,
                                fontFamily: 'HelveticaLight'),
                          ),
                          TextSpan(
                              text: Translation.of(context)!
                                  .translate('terms_condition')!,
                              style: TextStyle(
                                  //  decoration: TextDecoration.underline,
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontFamily: 'HelveticaNeueMedium'),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TermsConditionScreen()));
                                }),

                          // can add more TextSpans here...
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Container(
                width: 160,
                height: 160,
                child: Image.asset(
                  'assets/images/payment.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                Translation.of(context)!.translate('payment_register')!,
                textAlign: TextAlign.center,
                style: (TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                    fontFamily: 'HelveticaNeueBold')),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(left: 35, right: 35),
                child: Text(Translation.of(context)!.translate('mama_reminds')!,
                    style: TextStyle(
                        color: Color.fromRGBO(128, 128, 128, 1),
                        fontSize: 15,
                        fontFamily: 'HelveticaNeueMedium'),
                    textAlign: TextAlign.left),
              ),
              SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.12,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Text.rich(
                      TextSpan(
                        text: Translation.of(context)!.translate('read_our')!,
                        style: TextStyle(
                            color: Color.fromRGBO(128, 128, 128, 1),
                            fontFamily: 'HelveticaLight',
                            fontSize: 13),
                        children: <TextSpan>[
                          TextSpan(
                              text: Translation.of(context)!
                                  .translate('privacy_policy')!,
                              style: TextStyle(
                                  //   decoration: TextDecoration.underline,
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontFamily: 'HelveticaNeueMedium'),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PrivacyPolicyScreen()));
                                }),
                          TextSpan(
                            text: Translation.of(context)!
                                .translate('agree_to_our')!,
                            style: TextStyle(
                                color: Color.fromRGBO(128, 128, 128, 1),
                                fontSize: 13,
                                fontFamily: 'HelveticaLight'),
                          ),
                          TextSpan(
                              text: Translation.of(context)!
                                  .translate('terms_condition')!,
                              style: TextStyle(
                                  //  decoration: TextDecoration.underline,
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontFamily: 'HelveticaNeueMedium'),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TermsConditionScreen()));
                                }),

                          // can add more TextSpans here...
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Container(
                width: 160,
                height: 160,
                child: Image.asset(
                  'assets/images/secure.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                Translation.of(context)!.translate('secure')!,
                textAlign: TextAlign.center,
                style: (TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                    fontFamily: 'HelveticaNeueBold')),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(left: 35, right: 35),
                child: Text(Translation.of(context)!.translate('mama_makes')!,
                    style: TextStyle(
                        color: Color.fromRGBO(128, 128, 128, 1),
                        fontSize: 15,
                        fontFamily: 'HelveticaNeueMedium'),
                    textAlign: TextAlign.left),
              ),
              SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(
                      'assets/images/Ellipse2.png',
                      fit: BoxFit.contain,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.13,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Text.rich(
                      TextSpan(
                        text: Translation.of(context)!.translate('read_our')!,
                        style: TextStyle(
                            color: Color.fromRGBO(128, 128, 128, 1),
                            fontFamily: 'HelveticaLight',
                            fontSize: 13),
                        children: <TextSpan>[
                          TextSpan(
                              text: Translation.of(context)!
                                  .translate('privacy_policy')!,
                              style: TextStyle(
                                  //   decoration: TextDecoration.underline,
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontFamily: 'HelveticaNeueMedium'),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PrivacyPolicyScreen()));
                                }),
                          TextSpan(
                            text: Translation.of(context)!
                                .translate('agree_to_our')!,
                            style: TextStyle(
                                color: Color.fromRGBO(128, 128, 128, 1),
                                fontSize: 13,
                                fontFamily: 'HelveticaLight'),
                          ),
                          TextSpan(
                              text: Translation.of(context)!
                                  .translate('terms_condition')!,
                              style: TextStyle(
                                  //  decoration: TextDecoration.underline,
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontFamily: 'HelveticaNeueMedium'),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TermsConditionScreen()));
                                }),

                          // can add more TextSpans here...
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      ],
/*
      pages: [

        PageViewModel(

          titleWidget: Text(""),
          bodyWidget: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/background.png',),fit: BoxFit.cover)
              ),
              padding: EdgeInsets.only(top: 20,left: 35,right: 35),
              child:       Column(
                children: [

                  Container(
                    width: MediaQuery.of(context).size.width*0.5,
                    height: MediaQuery.of(context).size.height*0.167,
                    child: Image.asset('assets/images/mamapic.png', fit: BoxFit.fill,),
                  ),
                  SizedBox(height: 60,),

                  Text('Welcome To Mama',textAlign: TextAlign.center,   style: TextStyle(fontFamily: 'Comfortaa',fontSize: 28,fontWeight: FontWeight.bold, color:Color.fromRGBO(78, 169, 160,0.7),),),
                  SizedBox(height: 20,),
                  Text("South Africa's Best Admin App\nFor Communities\nIt Is Free And Secure. ",style: TextStyle(color: Colors.black38,fontSize: 17),textAlign: TextAlign.center),
                  SizedBox(height: 10,),
                ],
              )


          ),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            pageColor: Colors.black,
            imageFlex: 1,
            bodyFlex: 1,
            titlePadding: EdgeInsets.only(top: 190,left: 20,right: 20
            ),
          ),

        ),
        PageViewModel(
          titleWidget: Text(""),
          bodyWidget: Container(
              padding: EdgeInsets.only(top: 20,left: 35,right: 35),
              child:       Column(
                children: [

                  Container(
                    width: MediaQuery.of(context).size.width*0.5,
                    height: MediaQuery.of(context).size.height*0.167,
                    child: Image.asset('assets/images/mamapic.png', fit: BoxFit.fill,),
                  ),
                  SizedBox(height: 60,),

                  Text('Free',textAlign: TextAlign.center,   style: TextStyle(fontFamily: 'Comfortaa',fontSize: 28,fontWeight: FontWeight.bold, color:Color.fromRGBO(78, 169, 160,0.7),),),
                  SizedBox(height: 20,),
                  Text("Mama Provides Data\nFree Community Chat.",style: TextStyle(color: Colors.black38,fontSize: 17),textAlign: TextAlign.center),
                  SizedBox(height: 10,),
                ],
              )


          ),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),

            imageFlex: 1,
            bodyFlex: 1,
            titlePadding: EdgeInsets.only(top: 190,left: 20,right: 20
            ),
          ),

        ),
        PageViewModel(
          titleWidget: Text(""),
          bodyWidget: Container(
              padding: EdgeInsets.only(top: 20,left: 35,right: 35),
              child:       Column(
                children: [

                  Container(
                    width: MediaQuery.of(context).size.width*0.5,
                    height: MediaQuery.of(context).size.height*0.167,
                    child: Image.asset('assets/images/mamapic.png', fit: BoxFit.fill,),
                  ),
                  SizedBox(height: 60,),

                  Text('Community Chat',textAlign: TextAlign.center,   style: TextStyle(fontFamily: 'Comfortaa',fontSize: 28,fontWeight: FontWeight.bold, color:Color.fromRGBO(78, 169, 160,0.7),),),
                  SizedBox(height: 20,),
                  Text("Mama Allows You To Chat Freely With Members Of Your Community Savings Group",style: TextStyle(color: Colors.black38,fontSize: 17),textAlign: TextAlign.center),
                  SizedBox(height: 10,),
                ],
              )


          ),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),

            imageFlex: 1,
            bodyFlex: 1,
            titlePadding: EdgeInsets.only(top: 190,left: 20,right: 20
            ),
          ),

        ),
        PageViewModel(
          titleWidget: Text(""),
          bodyWidget: Container(
              padding: EdgeInsets.only(top: 20,left: 35,right: 35),
              child:       Column(
                children: [

                  Container(
                    width: MediaQuery.of(context).size.width*0.5,
                    height: MediaQuery.of(context).size.height*0.167,
                    child: Image.asset('assets/images/mamapic.png', fit: BoxFit.fill,),
                  ),
                  SizedBox(height: 60,),

                  Text('Meeting Admin',textAlign: TextAlign.center,   style: TextStyle(fontFamily: 'Comfortaa',fontSize: 28,fontWeight: FontWeight.bold, color:Color.fromRGBO(78, 169, 160,0.7),),),
                  SizedBox(height: 20,),
                  Text("Mama Provides Members With The Ability To Vote,To See The Attence Register And To Share Minutes",style: TextStyle(color: Colors.black38,fontSize: 17),textAlign: TextAlign.center),
                  SizedBox(height: 10,),
                ],
              )


          ),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),

            imageFlex: 1,
            bodyFlex: 1,
            titlePadding: EdgeInsets.only(top: 190,left: 20,right: 20
            ),
          ),

        ),
        PageViewModel(
          titleWidget: Text(""),
          bodyWidget: Container(
              padding: EdgeInsets.only(top: 20,left: 35,right: 35),
              child:       Column(
                children: [

                  Container(
                    width: MediaQuery.of(context).size.width*0.5,
                    height: MediaQuery.of(context).size.height*0.167,
                    child: Image.asset('assets/images/mamapic.png', fit: BoxFit.fill,),
                  ),
                  SizedBox(height: 60,),

                  Text('Payment Register',textAlign: TextAlign.center,   style: TextStyle(fontFamily: 'Comfortaa',fontSize: 28,fontWeight: FontWeight.bold, color:Color.fromRGBO(78, 169, 160,0.7),),),
                  SizedBox(height: 20,),
                  Text("Mama Reminds Members When Payments Are Due And Automatically Updates Payment Register For All Members To See",style: TextStyle(color: Colors.black38,fontSize: 17),textAlign: TextAlign.center),
                  SizedBox(height: 10,),
                ],
              )


          ),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),

            imageFlex: 1,
            bodyFlex: 1,
            titlePadding: EdgeInsets.only(top: 190,left: 20,right: 20
            ),
          ),

        ),
        PageViewModel(
          titleWidget: Text(""),
          bodyWidget: Container(
              padding: EdgeInsets.only(top: 20,left: 35,right: 35),
              child:       Column(
                children: [

                  Container(
                    width: MediaQuery.of(context).size.width*0.5,
                    height: MediaQuery.of(context).size.height*0.167,
                    child: Image.asset('assets/images/mamapic.png', fit: BoxFit.fill,),
                  ),
                  SizedBox(height: 60,),

                  Text('Secure',textAlign: TextAlign.center,   style: TextStyle(fontFamily: 'Comfortaa',fontSize: 28,fontWeight: FontWeight.bold, color:Color.fromRGBO(78, 169, 160,0.7),),),
                  SizedBox(height: 20,),
                  Text("Mama Makes Sure That Only Your Fellow Community Members Can See Your Messages",style: TextStyle(color: Colors.black38,fontSize: 17),textAlign: TextAlign.center),
                  SizedBox(height: 10,),
                ],
              )


          ),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),

            imageFlex: 1,
            bodyFlex: 1,
            titlePadding: EdgeInsets.only(top: 190,left: 20,right: 20
            ),
          ),

        ),

      ],*/
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      dotsFlex: 3,

      skipOrBackFlex: 2,
      nextFlex: 3,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      dotsDecorator: DotsDecorator(
        //   activeColor:  Color.fromRGBO(78, 169, 160,0.7),
        color: Colors.transparent,
        activeColor: Colors.transparent,
      ),
      skip: Text(
        Translation.of(context)!.translate('skip')!,
        style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontFamily: 'HelveticaNeueMedium'),
      ),
      next: Container(
          padding: EdgeInsets.only(left: 7, right: 7, top: 7, bottom: 7),
          margin: EdgeInsets.only(left: 5),

          //  margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                ),
              ]),
          child: Row(
            children: [
              Text(
                Translation.of(context)!.translate('continue')!,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                width: 3,
              ),
              Container(
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20)))
            ],
          )),
      done: PrefObj.preferences!.get(PrefKeys.LANG) == 'en' ||
              PrefObj.preferences!.get(PrefKeys.LANG) == null
          ? Container(
              padding: EdgeInsets.only(left: 7, right: 5, top: 7, bottom: 7),
              margin: EdgeInsets.only(left: 1),

              //  margin: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),
                  ]),
              child: Row(
                children: [
                  Flexible(
                    flex: 3,
                    child: Text(
                      Translation.of(context)!.translate('start_now')!,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                      flex: 1,
                      child: Container(
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20)))),
                ],
              ),
            )
          : Container(
              padding: EdgeInsets.only(left: 7, right: 5, top: 7, bottom: 7),
              margin: EdgeInsets.only(left: 1),

              //  margin: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),
                  ]),
              child: Row(
                children: [
                  Flexible(
                    flex: 5,
                    child: Text(
                      Translation.of(context)!.translate('start_now')!,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  //  SizedBox(width: 5,),

                  Flexible(
                      flex: 1,
                      child: Container(
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 18,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(15)))),
                ],
              ),
            ),

      curve: Curves.fastLinearToSlowEaseIn,

      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
    );
  }
}
