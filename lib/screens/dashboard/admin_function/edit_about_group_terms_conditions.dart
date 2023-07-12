import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../global/PrefKeys.dart';
import '../../../global/config.dart';
import '../../../global/global.dart';
import '../../../localizations/app_localizations.dart';
import 'package:http/http.dart' as http;

class EditAboutGroupTermsConditionScreen extends StatefulWidget {
  final String? groupDetails;
  final String? termCondition;
  final String? groupPolicy;
  final String? groupId;
  const EditAboutGroupTermsConditionScreen(
      {Key? key,
      this.groupId,
      this.groupDetails,
      this.termCondition,
      this.groupPolicy})
      : super(key: key);

  @override
  State<EditAboutGroupTermsConditionScreen> createState() =>
      _EditAboutGroupTermsConditionScreenState();
}

class _EditAboutGroupTermsConditionScreenState
    extends State<EditAboutGroupTermsConditionScreen> {
  TextEditingController about_group = TextEditingController();
  TextEditingController terms_and_conditions = TextEditingController();
  TextEditingController privacy_policy = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    about_group.text = widget.groupDetails!;

    var termConditionValue = widget.termCondition;

    if (termConditionValue != null) {
      terms_and_conditions.text = widget.termCondition!;
    } else {
      terms_and_conditions.text = 'No Data Available';
    }

    super.initState();
  }

  Future<void> onEditGroupDetailsOfTermAndCondition() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);
      final uri =
          Uri.parse(Config.apiurl + "group/" + widget.groupId.toString());
      debugPrint("member req url: $uri");

      var requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
            'Bearer ' + '${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}',
        'Accept-Language': 'en'
      };

      final body = {
        "description": about_group.text,
        "terms_and_condition": terms_and_conditions.text,
        "privacy_policy": "No Data Available" /*privacy_policy.text*/
      };

      debugPrint("body : " + jsonEncode(body).toString());

      var response = await http.put(
        uri,
        headers: requestHeaders,
        body: jsonEncode(body), // use jsonEncode()
      );

      debugPrint("response : " + json.decode(response.body).toString());

      Map<String, dynamic> map = json.decode(response.body);
      var messageShow = map["message"];
      if (response.statusCode == 200 || response.statusCode == 201) {
        global().hideLoader(context);
        showSnackBarShowSuccess(context, "Update Successfully");
        Navigator.pop(context);
      } else {
        global().hideLoader(context);
        showSnackBarShowError(context, messageShow.toString());
      }
    } catch (e) {
      global().hideLoader(context);
      showSnackBarShowError(context, e.toString());
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      showSnackBarShowError(BuildContext context, String title) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        content: Text(
          title,
          textAlign: TextAlign.center,
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      showSnackBarShowSuccess(BuildContext context, String title) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        content: Text(
          title,
          textAlign: TextAlign.center,
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 35,
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top: 5, left: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);

                  /*  Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: HomePage(),
                          ),
                        );*/
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Container(
                    /*   decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 3.0,
                                ),
                              ]),*/
                    child: const Icon(
                      Icons.keyboard_backspace,
                      color: Colors.black54,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 15, top: 15, bottom: 15),
              child: Text(
                Translation.of(context)!.translate('about_group')!,
                style: TextStyle(
                    fontFamily: 'HelveticaNeueMedium',
                    color: Colors.black,
                    fontSize: 19),
              ),
            ),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 15, right: 15),
                child: TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    //     labelText:                                     Translation.of(context)!.translate('name')!,

                    hintText: "Write Here",
                    labelStyle: TextStyle(
                        fontFamily: 'HelveticaLight',
                        fontSize: 16,
                        color: Colors.black26),
                    hintStyle: TextStyle(
                        fontFamily: 'HelveticaLight',
                        fontSize: 16,
                        color: Colors.black26),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: BorderSide(
                        color: Colors.blue[100]!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blue[100]!),
                    ),
                  ),
                  controller: about_group,
                )),
            SizedBox(
              height: 15,
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 15, top: 15, bottom: 15),
              child: Text(
                "Terms And Conditions",
                style: TextStyle(
                    fontFamily: 'HelveticaNeueMedium',
                    color: Colors.black,
                    fontSize: 19),
              ),
            ),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 15, right: 15),
                child: TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    //     labelText:                                     Translation.of(context)!.translate('name')!,

                    hintText: "Write Here",
                    labelStyle: TextStyle(
                        fontFamily: 'HelveticaLight',
                        fontSize: 16,
                        color: Colors.black26),
                    hintStyle: TextStyle(
                        fontFamily: 'HelveticaLight',
                        fontSize: 16,
                        color: Colors.black26),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: BorderSide(
                        color: Colors.blue[100]!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blue[100]!),
                    ),
                  ),
                  controller: terms_and_conditions,
                )),
            SizedBox(
              height: 15,
            ),
            /*   Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 15, top: 15,bottom: 15),
                child: Text(
                  "Privacy Policy",
                  style: TextStyle(
                      fontFamily: 'HelveticaNeueMedium',
                      color: Colors.black,
                      fontSize: 19),
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 15,right: 15),
                  child:   TextField(
                    maxLines: 5,
                    decoration: InputDecoration(

                      //     labelText:                                     Translation.of(context)!.translate('name')!,

                      hintText:"Write Here" ,
                      labelStyle:TextStyle(fontFamily: 'HelveticaLight',fontSize: 16, color:Colors.black26),
                      hintStyle:TextStyle(fontFamily: 'HelveticaLight',fontSize: 16, color:Colors.black26),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide:  BorderSide(color: Colors.blue[100]!, ),

                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:  BorderSide(color: Colors.blue[100]! ),

                      ),

                    ),
                    controller: privacy_policy,

                  )
              ),*/
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            InkWell(
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
                    margin: EdgeInsets.only(top: 12),
                    child: Text(
                      'Save',
                      // textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                ],
              ),
              onTap: _saveGroupRelatedDetailsSetByAdmin,
            )
          ],
        ),
      ),
    ));
  }

  _saveGroupRelatedDetailsSetByAdmin() {
    onEditGroupDetailsOfTermAndCondition();
  }
}
