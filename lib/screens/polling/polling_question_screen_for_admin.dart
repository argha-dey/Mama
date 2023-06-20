/*
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mama/screens/dashboard/polling_question_screen2.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../global/PrefKeys.dart';
import '../../global/config.dart';
import '../../global/global.dart';
import '../../localizations/app_localizations.dart';
import 'package:http/http.dart' as http;

import '../../model/polling_qstn_detail_model.dart';


class PollingQstnScreen extends StatefulWidget {
  String? pollingId;
   PollingQstnScreen({Key? key,this.pollingId}) : super(key: key);

  @override
  State<PollingQstnScreen> createState() => _PollingQstnScreenState();
}

class _PollingQstnScreenState extends State<PollingQstnScreen> {
  ItemScrollController _scrollController = ItemScrollController();

  String selectOptionType = "";
  PollingQstnDetailsModel? pollingQstnDetailsModel;
  List<PollingQuestion> pollQstnList=[];
  List<PollingQuestion> pollQstWithAnsnList=[];

  final double _height = 600.0;
  int questionListIndex = 0;
  Future<void> GetPollingDetails() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);
      final uri = Uri.parse(Config.apiurl + Config.pollingCreate +"/"+ widget.pollingId.toString());
      debugPrint("polling Detail url: $uri");



      var requestHeaders = {
        'Content-Type':'application/json',
        'Accept':'application/json',
        'Authorization': 'Bearer '+'${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}',
        'Accept-Language' : 'en'
      };
      debugPrint("requestHeaders : $requestHeaders");
      final requestBody = {

      };




      dynamic responseJson;
      var response = await http.get(uri, headers: requestHeaders);
      global().hideLoader(context);
      debugPrint("polling Detail response : "+json.decode(response.body).toString());

      if (response.statusCode == 200) {

        setState(() {
          responseJson = json.decode(response.body);
          pollingQstnDetailsModel =  PollingQstnDetailsModel.fromJson(responseJson);
          pollQstnList = pollingQstnDetailsModel!.data!.pollingQuestion!;
        });
      } else {

        global().showSnackBarShowError(context,'Failed to get polling details Data!');
      }
    }catch(e){
      global().hideLoader(context);
      print('==>Failed ');
    }
  }
  void _animateToNext() {
    if (pollQstnList.length == questionListIndex) {

    }  else {
      questionListIndex = questionListIndex + 1;
      _scrollController.scrollTo(
          index: questionListIndex, duration: Duration(seconds: 1));
    }
  }

  void _animateToPrev() {
    if (questionListIndex==0) {

    }  else{
      questionListIndex = questionListIndex - 1;
      _scrollController.scrollTo(index:questionListIndex, duration: Duration(seconds: 1));
    }


  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        GetPollingDetails();
      });
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
body: SingleChildScrollView(
  child: Column(
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
             pollingQstnDetailsModel == null?"" :pollingQstnDetailsModel!.data!.name!,
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 14),
                  ) ,
                ) ,
                onTap: (){
                  */
/*  Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ChatDetailsScreen()),
                );*/ /*

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
              */
/*  border: Border.all(
                color: Colors.blue,
            ),*/ /*

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
                    color: Colors.blue[50],borderRadius: BorderRadius.circular(9)
                ),
              ),
              SizedBox(width: 8,),
              Container(
                child: Text(
                  '0/10',
                  style: TextStyle(fontFamily: 'HelveticaNeueMedium',color: Colors.black,fontSize: 10),
                ) ,
              ),
            ],
          )
      ),
      SizedBox(
        height: 25,
      ),
*/
/*      Container(
          height: 270,
          child:    ListView.builder(
              controller: _controller,
              itemCount:pollQstnList.length,
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return   Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15,bottom: 10),
                      alignment: Alignment.topLeft,
                      child: Text(
                        pollQstnList[index].question.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 19),
                      ) ,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    addRadioButton(0, Translation.of(context)!.translate('yes')!,  pollQstnList[index]),
                    SizedBox(
                      height: 20,
                    ),
                    addRadioButton(1, Translation.of(context)!.translate('no')!,  pollQstnList[index]),
                    SizedBox(
                      height: 20,
                    ),
                    addRadioButton(2, "May be",  pollQstnList[index]),
                  ],
                )
               ;
              }
          )
      ),*/ /*

    Container(
        height: 270,
        child:  ScrollablePositionedList.builder(
        itemScrollController: _scrollController,
        itemCount:pollQstnList.length,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
         return   Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 15,bottom: 10),
                alignment: Alignment.topLeft,
                child: Text(
                  pollQstnList[index].question.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 19),
                ) ,
              ),
              SizedBox(
                height: 20,
              ),
              addRadioButton( pollQstnList[index].option1, Translation.of(context)!.translate('yes')!,  pollQstnList[index]),
              SizedBox(
                height: 20,
              ),
              addRadioButton(pollQstnList[index].option2, Translation.of(context)!.translate('no')!,  pollQstnList[index]),
              SizedBox(
                height: 20,
              ),
              addRadioButton(pollQstnList[index].option3, "May be",  pollQstnList[index]),
            ],
          );
        },
      )
    ),

      */
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
    ),*/ /*


      */
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
    ),*/ /*

      InkWell(
        child: Container(


            margin: EdgeInsets.only(top: 260),


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
                    Translation.of(context)!.translate('next')!,
                    // textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 19),
                  ),
                )

              ],
            )

        ),

          onTap: () => _animateToNext(),
        */
/*  Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => PollingQstnScreen2()),
          );*/ /*


      ),
      InkWell(
        onTap: (){
          _animateToPrev();
        },
        child:      Container(
          margin: EdgeInsets.only(top: 20),
          child:                 Text(  Translation.of(context)!.translate('skip')!,style: TextStyle(color: Color.fromRGBO(5, 119, 128,1),fontSize: 18,fontFamily: 'HelveticaNeueMedium'), ),

        ) ,
      ),

      SizedBox(height: 30,)
    ],
  ),
)

    );
  }


  Container addRadioButton(String btnValue, String title ,PollingQuestion pollingQuestion) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        margin: EdgeInsets.only(left: 15,right: 15),
        padding: EdgeInsets.only(top: 5,bottom: 5,left: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          */
/*  border: Border.all(
                color: Colors.blue,
            ),*/ /*

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
              value: btnValue,
              groupValue:selectOptionType,
              onChanged: (value) {
                setState(() {
                  print(value);
                //   selectOptionType = value.toString();

                  debugPrint("selectOptionType:"+    selectOptionType.toString());
                  debugPrint("question name :"+    pollingQuestion.question.toString());
                });
              },
            ),
            Text(title,textAlign: TextAlign.left,   style: TextStyle(fontFamily: 'Comfortaa',fontSize: 16, color:Colors.black),),
          ],
        ));
  }
}
*/
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../global/PrefKeys.dart';
import '../../global/config.dart';
import '../../global/global.dart';
import '../../localizations/app_localizations.dart';
import '../../model/polling_qstn_detail_model.dart';
import '../../radio_group/grouped_buttons_orientation.dart';
import '../../radio_group/radio_button_group..dart';
import '../../repository/repository.dart';
import '../dashboard/polling_question_screen.dart';

class PollingQstnScreenForAdmin extends StatefulWidget {
  String? pollingId;
  PollingQstnScreenForAdmin({Key? key, this.pollingId}) : super(key: key);

  @override
  State<PollingQstnScreenForAdmin> createState() =>
      _PollingQstnScreenForAdminState();
}

//https://mamaapi.developerconsole.link/api/polling/98851bb8-e4e9-4f8c-ae73-efa0a7546565

class _PollingQstnScreenForAdminState extends State<PollingQstnScreenForAdmin> {
  ItemScrollController _scrollController = ItemScrollController();
  Map<int, String> selectedValues = new Map<int, String>();
  String selectOptionType = "";
  PollingQstnDetailsModel? pollingQstnDetailsModel;
  List<PollingQuestion> pollQstnList = [];
  List<PollingQuestion> pollQstWithAnsnList = [];
  List<PollingAnsDetails> pollingAnsListAdmin = [];
  final repository = Repository();
  bool isNextButtonVisible = true;
  bool isSubmitButtonVisible = false;
  bool isPrevButtonVisible = true;

  final double _height = 600.0;
  int questionListIndex = 1;

  Future<void> GetPollingDetails() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);
      final uri = Uri.parse(Config.apiurl +
          Config.pollingCreate +
          "/" +
          widget.pollingId.toString());

      debugPrint("polling Detail url: $uri");

      var requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
            'Bearer ' + '${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}',
        'Accept-Language': 'en'
      };
      debugPrint("requestHeaders : $requestHeaders");
      final requestBody = {};

      dynamic responseJson;
      var response = await http.get(uri, headers: requestHeaders);
      global().hideLoader(context);
      debugPrint(
          "polling Detail response : " + json.decode(response.body).toString());

      if (response.statusCode == 200) {
        setState(() {
          responseJson = json.decode(response.body);
          pollingQstnDetailsModel =
              PollingQstnDetailsModel.fromJson(responseJson);
          pollQstnList = pollingQstnDetailsModel!.data!.pollingQuestion!;
          if (pollQstnList.length == 1) {
            isNextButtonVisible = false;
            isSubmitButtonVisible = false;
          }
        });
      } else {
        global().showSnackBarShowError(
            context, 'Failed to get polling details Data!');
      }
    } catch (e) {
      global().hideLoader(context);
      print('==>Failed ');
    }
  }

  Future<void> submitPollingQuestionWithAnsDetails() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);
      final uri = Uri.parse(Config.apiurl + Config.pollingCreate + "/" + "4");

      debugPrint("polling Detail url: $uri");

      var _requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
            'Bearer ' + '${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}',
        'Accept-Language': 'en'
      };
      debugPrint("requestHeaders : $_requestHeaders");

      final _requestBody = {};

      dynamic responseJson;
      var response =
          await http.post(uri, headers: _requestHeaders, body: _requestBody);
      global().hideLoader(context);
      debugPrint("polling Question Ans  Detail response : " +
          json.decode(response.body).toString());

      if (response.statusCode == 200) {
        setState(() {});
      } else {
        global().showSnackBarShowError(
            context, 'Failed to get polling details Data!');
      }
    } catch (e) {
      global().hideLoader(context);
      print('==>Failed ');
    }
  }

  void _animateToNext() {
    if (pollQstnList.length == questionListIndex) {
    } else {
      _scrollController.scrollTo(
          index: questionListIndex, duration: Duration(seconds: 1));
      questionListIndex = questionListIndex + 1;
      if (pollQstnList.length == questionListIndex) {
        setState(() {
          isNextButtonVisible = false;
          isSubmitButtonVisible = false;
        });
      }
    }
  }

  void _animateToPrev() {
    setState(() {
      isNextButtonVisible = true;
      isSubmitButtonVisible = false;
    });
    if (questionListIndex == 1) {
    } else {
      questionListIndex = questionListIndex - 1;
      _scrollController.scrollTo(
          index: questionListIndex - 1, duration: Duration(seconds: 1));
    }
  }

  String getTimeString(int value) {
    final int hour = value ~/ 60;
    final int minutes = value % 60;
    return '${hour.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        GetPollingDetails();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 35, left: 10),
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
              SizedBox(
                height: 10,
              ),
              pollingQstnDetailsModel == null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: CircleAvatar(
                              radius: 22,
                              backgroundImage: NetworkImage(
                                  "https://ui-avatars.com/api/?name=TestDemo"),
                            )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              child: Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Text(
                                  '',
                                ),
                              ),
                              onTap: () {
                                /*  Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ChatDetailsScreen()),
                );*/
                              },
                            ),
                            pollingQstnDetailsModel == null
                                ? Container(
                                    margin: EdgeInsets.only(left: 15, top: 4),
                                    child: Text(
                                      Translation.of(context)!
                                          .translate('submit_within')!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                          fontSize: 14),
                                    ),
                                  )
                                :
                            pollingQstnDetailsModel!.data!.currentTimeBetween! == false ?
                            Container(
                              margin: EdgeInsets.only(left: 15, top: 4),
                              child: Text(
                                "This polling expired",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                    fontSize: 14),
                              ),
                            ):
                            Container(
                                    margin: EdgeInsets.only(left: 15, top: 4),
                                    child: Text(
                                      Translation.of(context)!
                                              .translate('submit_within')! +
                                          " " +
                                          getTimeString(pollingQstnDetailsModel!
                                              .data!.pollingHour!),
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                          fontSize: 14),
                                    ),
                                  ),
                          ],
                        )
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: CircleAvatar(
                              radius: 22,
                              backgroundImage: NetworkImage(
                                  "https://ui-avatars.com/api/?name=" +
                                      pollingQstnDetailsModel!.data!.name
                                          .toString()
                                          .toUpperCase()),
                            )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              child: Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Text(
                                  pollingQstnDetailsModel!.data == null
                                      ? ""
                                      : pollingQstnDetailsModel!.data!.name!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 14),
                                ),
                              ),
                              onTap: () {
                                /*  Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ChatDetailsScreen()),
                );*/
                              },
                            ),
                            pollingQstnDetailsModel == null
                                ? Container(
                                    margin: EdgeInsets.only(left: 15, top: 4),
                                    child: Text(
                                      Translation.of(context)!
                                          .translate('submit_within')!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                          fontSize: 14),
                                    ),
                                  )
                                :   pollingQstnDetailsModel!.data!.currentTimeBetween! == false ?
                            Container(
                              margin: EdgeInsets.only(left: 15, top: 4),
                              child: Text(
                                "This polling expired",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                    fontSize: 14),
                              ),
                            )
                                    : Container(
                                        margin:
                                            EdgeInsets.only(left: 15, top: 4),
                                        child: Text(
                                          Translation.of(context)!
                                                  .translate('submit_within')! +
                                              " " +
                                              getTimeString(
                                                  pollingQstnDetailsModel!
                                                      .data!.pollingHour!) +
                                              " hrs",
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                      ),
                          ],
                        )
                      ],
                    ),
              SizedBox(
                height: 20,
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 15, right: 15),
                  padding: EdgeInsets.only(top: 9, bottom: 9, left: 15),
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
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Container(
                        width: 295,
                        height: 12,
                        child: LinearPercentIndicator(
                          percent: pollQstnList.length > 0
                              ? (((questionListIndex / pollQstnList.length) *
                                      100)) /
                                  100.toDouble()
                              : 0.0,
                          backgroundColor: Colors.grey[500],
                          progressColor: Colors.blue,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        child: Text(
                          questionListIndex.toString() +
                              '/' +
                              pollQstnList.length.toString(),
                          style: TextStyle(
                              fontFamily: 'HelveticaNeueMedium',
                              color: Colors.black,
                              fontSize: 10),
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                height: 25,
              ),
              pollQstnList.length > 0
                  ? Container(
                      height: 270,
                      child: ScrollablePositionedList.builder(
                        itemScrollController: _scrollController,
                        itemCount: pollQstnList.length,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 15, bottom: 10),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  pollQstnList[index].question.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 19),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              RadioButtonGroup(
                                orientation: GroupedButtonsOrientation.VERTICAL,
                                margin: const EdgeInsets.only(left: 12.0),
                                onSelected: (String selected) => setState(() {
                                  // selectedValues[index] = selected;
                                }),
                                labels: <String>[
                                  "Yes",
                                  "No",
                                  "May Be",
                                ],
                                picked: '3',
                                itemBuilder: (Radio rb, Text txt, int i) {
                                  return Row(children: <Widget>[
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        margin: EdgeInsets.only(
                                            left: 15, right: 10, bottom: 10),
                                        padding: EdgeInsets.only(
                                            top: 5, bottom: 5, left: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.blue[50]!,
                                                blurRadius: 6.0,
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Row(
                                          children: <Widget>[
                                            rb,
                                            txt,
                                          ],
                                        ))
                                  ]);
                                },
                                activeColor: Colors.indigoAccent,
                                disabled: [],
                                onChange: (String label, int index) {},
                              ),
                            ],
                          );
                        },
                      ))
                  : Container(),
              Visibility(
                  visible: isSubmitButtonVisible,
                  child: InkWell(
                    child: Container(
                        margin: EdgeInsets.only(top: 260),
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
                                "Submit",
                                // textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 19),
                              ),
                            )
                          ],
                        )),
                    onTap: () {
                      /*        if (selectedValues.length == pollQstnList.length) {
                      } else {
                        global().showSnackBarShowError(context,
                            "You are not ans all the questions.Kindly ans all");
                      }*/
                    },
                  )),
              SizedBox(
                height: 100,
              ),
              Visibility(
                visible: isNextButtonVisible,
                child: InkWell(
                  child: Container(
                      margin: EdgeInsets.only(top: 1),
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
                              Translation.of(context)!.translate('next')!,
                              // textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 19),
                            ),
                          )
                        ],
                      )),
                  onTap: () => _animateToNext(),
                  /*  Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => PollingQstnScreen2()),
          );*/
                ),
              ),
              questionListIndex == 1
                  ? Container()
                  : InkWell(
                      onTap: () {
                        _animateToPrev();
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
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
                                "Previous",
                                // textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 19),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ));
  }
}
