import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../localizations/app_localizations.dart';
import '../localizations/language_model.dart';

import 'PrefKeys.dart';

class global {
  void showLoader(BuildContext context) {
    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
              ],
            ));
      },
    );
  }

  /*void turnOffLoader(BuildContext context){
    Container();
  }*/

  void hideLoader(BuildContext context) {
    Navigator.of(context,rootNavigator: true).pop(false);
  }

  static void showAlertDialog(
      String title, String message, BuildContext context) {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new InkWell(
              child: Text(
                "CLOSE",
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Comfortaa',
                    fontWeight: FontWeight.normal,
                    color: Colors.red),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
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
        duration: const Duration(seconds: 3),
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
}
