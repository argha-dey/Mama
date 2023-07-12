import 'package:flutter/material.dart';

import '../auth/profile_fillup_screen.dart';

class VerifySuccessScreen extends StatefulWidget {
  const VerifySuccessScreen({Key? key}) : super(key: key);

  @override
  State<VerifySuccessScreen> createState() => _VerifySuccessScreenState();
}

class _VerifySuccessScreenState extends State<VerifySuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 120,
          ),
          Container(
            margin: EdgeInsets.only(left: 45),
            alignment: Alignment.center,
            width: 290,
            height: 250,
            child: Image.asset('assets/images/success_pic.png', fit: BoxFit.contain,),
          ),
          Container(
            margin: EdgeInsets.only(left: 45,top: 40),
            child:  Text('OTP Verified Successfully',textAlign: TextAlign.center,   style: TextStyle(fontFamily: 'Comfortaa',fontSize: 23, color:Colors.black),),
          ),

          InkWell(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ProfileFillupScreen()),
              );
            },
            child: Container(
                padding: EdgeInsets.only(left: 30, right: 30, top: 14, bottom: 14),
                margin: EdgeInsets.only(left: 45, top: 80, bottom: 40),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(78, 169, 160,0.7), borderRadius: BorderRadius.circular(20)),
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.white, fontSize: 21),
                )),
          )
        ],
      ),
    );
  }
}
