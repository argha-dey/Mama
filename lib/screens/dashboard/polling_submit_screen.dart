import 'package:flutter/material.dart';
import 'package:mama/screens/dashboard/polling_screen.dart';

import '../../localizations/app_localizations.dart';
import 'dashboard_screen.dart';

class PollingSubmitScreen extends StatefulWidget {
  String? pollingId;
   PollingSubmitScreen({Key? key,this.pollingId}) : super(key: key);

  @override
  State<PollingSubmitScreen> createState() => _PollingSubmitScreenState();
}

class _PollingSubmitScreenState extends State<PollingSubmitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.4,
          ),
          Center(
            child:   Container(
              width: 120,
              height: 120,
              child: Image.asset('assets/images/submit.png', fit: BoxFit.contain,),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 25),
            child:  Text(  Translation.of(context)!.translate('data_submitted')!,textAlign: TextAlign.center,   style: TextStyle(fontFamily: 'HelveticaNeueLight',fontSize: 17, color:Colors.black),),
          ),
          InkWell(
            child:Container(


                margin: EdgeInsets.only(top: 90),


                child:   Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/button.png', fit: BoxFit.contain,),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 10),
                      child:   Text(
                        Translation.of(context)!.translate('continue')!,
                        // textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 19),
                      ),
                    )

                  ],
                )

            ),
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => DashboardScreen(

                )),
              );
            },
          ),
        ],
      ),
    );
  }
}
