import 'dart:async';
import 'package:flutter/material.dart';

import '../../global/PrefKeys.dart';
import '../dashboard/admin_function/admin_group_details_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../intro/intro_screen.dart';






class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // late SharedPreferences sharedPreferences;

/*  @override
  Future<void> initState() async {
    // TODO: implement initState
    super.initState();
    sharedPreferences = await SharedPreferences.getInstance();
    Timer(const Duration(seconds: 3), navigateUser);
  }*/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();  Timer(const Duration(seconds: 3), navigateUser);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/background.png',),fit: BoxFit.cover)
        ),
        child: Center(
          child:   Container(
            width: 300,
            height: 300,
            child: Image.asset('assets/images/koleka_white.png', fit: BoxFit.contain,),
          ),
        ),
      ),

    );
  }
  void navigateUser() {
    bool isRegister = PrefObj.preferences!.get(PrefKeys.IS_LOGIN_STATUS)==null ? false : PrefObj.preferences!.get(PrefKeys.IS_LOGIN_STATUS);
    debugPrint("IS REGISTER"+isRegister.toString());
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>  isRegister?  DashboardScreen():  IntroScreen()));
         //   builder: (context) =>  isRegister?  AdminGroupDetailsScreen():  IntroScreen()));




  }
}
