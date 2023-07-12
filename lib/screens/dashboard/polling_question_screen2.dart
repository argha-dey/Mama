import 'package:flutter/material.dart';
import 'package:mama/screens/dashboard/polling_submit_screen.dart';

import '../../localizations/app_localizations.dart';


class PollingQstnScreen2 extends StatefulWidget {
  const PollingQstnScreen2({Key? key}) : super(key: key);

  @override
  State<PollingQstnScreen2> createState() => _PollingQstnScreen2State();
}

class _PollingQstnScreen2State extends State<PollingQstnScreen2> {
  List gender = ["Stockvel", "Burial \nSociety","Both"];
  String selectGenderType = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child:  Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),


                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage:   AssetImage(
                        'assets/images/item.png',
                      ),
                    )

                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      child:   Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Text(
                          'lorem ipsum',
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 14),
                        ) ,
                      ) ,
                      onTap: (){
                        /*  Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ChatDetailsScreen()),
                );*/
                      },
                    )
                    ,
                    Container(
                      margin: EdgeInsets.only(left: 15,top: 4),
                      child: Text(
                        Translation.of(context)!.translate('submit_within')! +' 2 hrs',
                        style: TextStyle(fontWeight: FontWeight.normal,color: Colors.black,fontSize: 14),
                      ) ,
                    ) ,
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 15,right: 15),
                padding: EdgeInsets.only(top: 9,bottom: 9,left: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    /*  border: Border.all(
                color: Colors.blue,
            ),*/
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue[50]!,
                        blurRadius: 5.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10)
                ),
                child:  Row(
                  children: [
                    Container(
                      width: 295,
                      height: 9,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(5, 119, 128,1)

                          ,borderRadius: BorderRadius.circular(9)
                      ),
                    ),
                    SizedBox(width: 8,),
                    Container(
                      child: Text(
                        '10/10',
                        style: TextStyle(fontFamily: 'HelveticaNeueMedium',color: Colors.black,fontSize: 10),
                      ) ,
                    ),
                  ],
                )
            ),

            Container(
              margin: EdgeInsets.only(left: 15,top: 15,bottom: 20),
              alignment: Alignment.topLeft,
              child: Text(
                'What is lorem ipsum?',
                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 19),
              ) ,
            ),

            /*   Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 15,right: 15),
      padding: EdgeInsets.only(top: 12,bottom: 12,left: 15),
      decoration: BoxDecoration(
          border: Border.all(
              color: Color.fromRGBO(5, 119, 128,1)
          ),
        borderRadius: BorderRadius.circular(10)
      ),
      child:  Text('yes',textAlign: TextAlign.left,   style: TextStyle(fontFamily: 'Comfortaa',fontSize: 16, color:Colors.black),),
    ),*/
            addRadioButton(0, Translation.of(context)!.translate('yes')!),
            SizedBox(
              height: 20,
            ),
            addRadioButton(1, Translation.of(context)!.translate('no')!),
            /* Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 15,right: 15,top: 17),
      padding: EdgeInsets.only(top: 12,bottom: 12,left: 15),
      decoration: BoxDecoration(
          border: Border.all(
              color: Color.fromRGBO(5, 119, 128,1)
          ),
          borderRadius: BorderRadius.circular(10)
      ),
      child:  Text('no',textAlign: TextAlign.left,   style: TextStyle(fontFamily: 'Comfortaa',fontSize: 16, color:Colors.black),),
    ),*/
            InkWell(
              child: Container(


                  margin: EdgeInsets.only(top: 290),


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
                          Translation.of(context)!.translate('submit')!,
                          // textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 19),
                        ),
                      )

                    ],
                  )

              ),
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => PollingSubmitScreen()),
                );
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child:                 Text(  Translation.of(context)!.translate('skip')!,style: TextStyle(color: Color.fromRGBO(5, 119, 128,1),fontSize: 18,fontFamily: 'HelveticaNeueMedium'), ),

            ),    SizedBox(height: 30,)
          ],
        ),
      )

    );
  }


  Container addRadioButton(int btnValue, String title) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 15,right: 15),
        padding: EdgeInsets.only(top: 5,bottom: 5,left: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            /*  border: Border.all(
                color: Colors.blue,
            ),*/
            boxShadow: [
              BoxShadow(
                color: Colors.blue[50]!,
                blurRadius: 5.0,
              ),
            ],
            borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Radio<String>(
              activeColor: Theme.of(context).primaryColor,
              value: gender[btnValue],
              groupValue: selectGenderType,
              onChanged: (value) {
                setState(() {
                  print(value);
                    selectGenderType = value.toString();
                });
              },
            ),
            Text(title,textAlign: TextAlign.left,   style: TextStyle(fontFamily: 'Comfortaa',fontSize: 16, color:Colors.black),),
          ],
        ));
  }
}
