import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:intl/intl.dart';
import 'package:mama/screens/polling/polling_result_screen.dart';
import 'package:http/http.dart' as http;

import '../../global/global.dart';
import '../../localizations/app_localizations.dart';
import '../../repository/repository.dart';
import '../dashboard/dashboard_screen.dart';
import '../dashboard/polling_screen.dart';
import 'admin_polling_screen.dart';

class PollingCreateScreen extends StatefulWidget {
  final String? groupId;
  const PollingCreateScreen({Key? key, this.groupId}) : super(key: key);

  @override
  State<PollingCreateScreen> createState() => _PollingCreateScreenState();
}

class _PollingCreateScreenState extends State<PollingCreateScreen> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController addqstn = TextEditingController();
  List<PollingQstnModel> pollQstnList = [];
  List gender = ["Yes", "No", "May be"];
  String selectGenderType = "";

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dateTime = DateTime.now();
  bool showDate = false;
  bool showTime = false;
  bool showDateTime = false;
  String? strtDate;
  String? endDate;
  String? strtTime;
  String? endTime;
  String? endDateTime;
  String? startDateTime;

  final repository = Repository();

  // Select for Date
  Future<DateTime> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
    return selectedDate;
  }

  // Select for Time
  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (selected != null && selected != selectedTime) {
      setState(() {
        selectedTime = selected;
      });
    }
    return selectedTime;
  }

  // select date time picker

  Future _selectDateTime(BuildContext context) async {
    final date = await _selectDate(context);
    if (date == null) return;

    final time = await _selectTime(context);

    if (time == null) return;
    setState(() {
      dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      _controller.text = getDateTime();
      strtDate = getDateTime().substring(0, 10);
      strtTime = getDateTime().substring(12, 21);
      startDateTime = strtDate.toString() + strtTime.toString();
      debugPrint("start datetime " + startDateTime.toString());
      //    debugPrint("start time"+strtTime.toString());
    });
  }

  Future _selectDateTime2(BuildContext context) async {
    final date = await _selectDate(context);
    if (date == null) return;

    final time = await _selectTime(context);

    if (time == null) return;
    setState(() {
      dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      _controller2.text = getDateTime();
      endDate = getDateTime().substring(0, 10);
      endTime = getDateTime().substring(12, 21);
      endDateTime = endDate.toString() + endTime.toString();

      debugPrint("end datetime " + endDateTime.toString());
    });
  }

  String getDateTime() {
    // ignore: unnecessary_null_comparison
    if (dateTime == null) {
      return 'select date timer';
    } else {
      return DateFormat('yyyy-MM-dd | HH:mm:ss').format(dateTime);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 45,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    /*         InkWell(
                      child: Container(
                        //   margin: EdgeInsets.only(left: 45),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color:Color.fromRGBO(5, 119, 128,1),

                            borderRadius: BorderRadius.circular(5)
                        ),
                        alignment: Alignment.center,
                        width: 25,
                        height: 25,
                        child: Image.asset('assets/images/pause.png', fit: BoxFit.contain,color: Colors.white,),
                      ) ,
                      onTap: (){

                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => PollingScreen()),
                        );
                      },
                    ),*/
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(
                /* Translation.of(context)!.translate('poll_detail')!,*/ 'Create a New Polling',
                style: TextStyle(
                    fontFamily: 'HelveticaNeueMedium',
                    color: Colors.black,
                    fontSize: 17),
              ),
            ),
            Container(
              height: 55,
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              child: TextField(
                decoration: InputDecoration(
                  labelText: Translation.of(context)!.translate('name')!,
                  hintText: "Polling 1",
                  labelStyle: TextStyle(
                      fontFamily: 'HelveticaLight',
                      fontSize: 16,
                      color: Colors.black26),
                  hintStyle: TextStyle(
                      fontFamily: 'HelveticaLight',
                      fontSize: 16,
                      color: Colors.black26),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(
                      color: Colors.blue[100]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(color: Colors.blue[100]!),
                  ),
                ),
                controller: name,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 55,
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              child: TextField(
                decoration: InputDecoration(
                  suffix: InkWell(
                    onTap: () {
                      _selectDateTime(context);
                      showDateTime = true;
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 15, right: 10),
                        child: Image.asset('assets/images/calendar2.png',
                            height: 22, width: 22, fit: BoxFit.cover)),
                  ),
                  labelText: Translation.of(context)!.translate('start_date')!,
                  hintText: "6 /03 /2022 | 11:20 ",
                  labelStyle: TextStyle(
                      fontFamily: 'HelveticaLight',
                      fontSize: 16,
                      color: Colors.black26),
                  hintStyle: TextStyle(
                      fontFamily: 'HelveticaLight',
                      fontSize: 16,
                      color: Colors.black26),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(
                      color: Colors.blue[100]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(color: Colors.blue[100]!),
                  ),
                ),
                controller: _controller,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 55,
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              child: TextField(
                decoration: InputDecoration(
                  suffix: InkWell(
                    onTap: () {
                      _selectDateTime2(context);
                      showDateTime = true;
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 15, right: 10),
                        child: Image.asset('assets/images/calendar2.png',
                            height: 22, width: 22, fit: BoxFit.cover)),
                  ),
                  labelText: Translation.of(context)!.translate('end_date')!,
                  hintText: "6 /03 /2022 | 16:20 ",
                  labelStyle: TextStyle(
                      fontFamily: 'HelveticaLight',
                      fontSize: 16,
                      color: Colors.black26),
                  hintStyle: TextStyle(
                      fontFamily: 'HelveticaLight',
                      fontSize: 16,
                      color: Colors.black26),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(
                      color: Colors.blue[100]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(color: Colors.blue[100]!),
                  ),
                ),
                controller: _controller2,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(
                Translation.of(context)!.translate('set_polling')!,
                style: TextStyle(
                    fontFamily: 'HelveticaNeueMedium',
                    color: Colors.black,
                    fontSize: 17),
              ),
            ),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      actions: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Add question here",
                            style: TextStyle(
                              fontSize: 19,
                              fontFamily: 'Comfortaa',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: TextField(
                              maxLines: 4,
                              decoration: InputDecoration(
                                //     labelText:                                     Translation.of(context)!.translate('name')!,

                                //    hintText:"Polling 1" ,
                                labelStyle: TextStyle(
                                    fontFamily: 'HelveticaLight',
                                    fontSize: 16,
                                    color: Colors.black26),
                                hintStyle: TextStyle(
                                    fontFamily: 'HelveticaLight',
                                    fontSize: 16,
                                    color: Colors.black26),

                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.blue[100]!,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.blue[100]!),
                                ),
                              ),
                              controller: addqstn,
                            )),
                        SizedBox(
                          height: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              child: Container(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 6, bottom: 6),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      fontFamily: 'Comfortaa',
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  )),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            InkWell(
                              child: Stack(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'assets/images/button3.png',
                                      fit: BoxFit.contain,
                                      width: 140,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 6, left: 15),
                                    child: Text(
                                      " Add question",
                                      // textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17),
                                    ),
                                  )
                                ],
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                setState(() {
                                  pollQstnList.add(PollingQstnModel(
                                      question_en: addqstn.text.toString(),
                                      question_fr: addqstn.text.toString(),
                                      option_1_en: "Yes",
                                      option_2_en: "No",
                                      option_3_en: "May Be",
                                      option_4_en: "NA",
                                      option_5_en: "NA",
                                      option_1_fr: "Oui",
                                      option_2_fr: "Non",
                                      option_3_fr: "Peut être",
                                      option_4_fr: "NA",
                                      option_5_fr: "NA",
                                      point: "0",
                                      answer: "0"));
                                  //  onPollingCreate(pollingQuestion: addqstn.text.toString());
                                });
                                FocusScope.of(context).unfocus();
                                addqstn.text = "";
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                margin: EdgeInsets.only(left: 25, right: 25, top: 15),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(12),
                  padding: EdgeInsets.all(6),
                  strokeWidth: 1,
                  color: Colors.blue,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    child: Container(
                      height: 35,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Text(
                        Translation.of(context)!.translate('add_new')!,
                        style: TextStyle(
                            color: Colors.blue, fontFamily: 'HelveticaLight'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: addpollingqstn(),
            ),
            InkWell(
              child: Container(
                  margin: EdgeInsets.only(top: 40),
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
                          Translation.of(context)!.translate('submit')!,
                          // textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 19),
                        ),
                      )
                    ],
                  )),
              onTap: () {
                if(name.text.isEmpty||
                startDateTime.toString().isEmpty||
                endDateTime.toString().isEmpty||
               pollQstnList.length<1){
               global().showSnackBarShowError(context, "Please fill up information properly !");
                }
              else{
                  onPollingCreate();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> addpollingqstn() {
    List<Widget> widgets = [];
    for (PollingQstnModel pollingData in pollQstnList!) {
      widgets.add(
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Card(
                  child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 15, bottom: 20),
                        alignment: Alignment.topLeft,
                        child: Text(
                          pollingData.question_en.toString(),
                          style: TextStyle(
                              fontFamily: 'HelveticaNeueMedium',
                              color: Colors.black,
                              fontSize: 15),
                        ),
                      ),
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.all(9),
                          margin: EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(25)),
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          child: Image.asset(
                            'assets/images/delete.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            debugPrint("after delete polling list: " +
                                pollingData.question_en);
                            pollQstnList.remove(pollingData);
                          });

                          /*   widgets.remove( Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10,right: 10),
                                  child: Card(
                                      child:
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(left: 15,top: 15,bottom: 20),
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  pollingData.question_name.toString(),
                                                  style: TextStyle(fontFamily: 'HelveticaNeueMedium',color: Colors.black,fontSize: 15),
                                                ) ,
                                              ),
                                              InkWell(
                                                child:   Container(
                                                  padding: EdgeInsets.all(9),
                                                  margin: EdgeInsets.only(right: 15),
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue[50],

                                                      borderRadius: BorderRadius.circular(25)
                                                  ),

                                                  alignment: Alignment.center,
                                                  width: 40,
                                                  height: 40,
                                                  child: Image.asset('assets/images/delete.png', fit: BoxFit.contain,),
                                                ),
                                                onTap: (){

                                                },
                                              )

                                            ],
                                          ),

                                          addRadioButton(0, Translation.of(context)!.translate('yes')!),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          addRadioButton(1, Translation.of(context)!.translate('no')!),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          addRadioButton(2, "May be"),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          */ /*   Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 15,right: 15),
                        padding: EdgeInsets.only(top: 15),
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(5, 119, 128,1)
                        ),
                        child:                 Text(  Translation.of(context)!.translate('add_option')!,textAlign: TextAlign.center,  style: TextStyle(fontFamily: 'HelveticaNeueMedium',fontSize: 16, color:Colors.white),),

                      ),
                      SizedBox(
                        height: 20,
                      ),*/ /*
                                        ],
                                      )
                                  ) ,
                                ),
                              ],
                            ),);*/
                        },
                      )
                    ],
                  ),
                  addRadioButton(0, Translation.of(context)!.translate('yes')!),
                  SizedBox(
                    height: 20,
                  ),
                  addRadioButton(1, Translation.of(context)!.translate('no')!),
                  SizedBox(
                    height: 20,
                  ),
                  addRadioButton(2, "May be"),
                  SizedBox(
                    height: 20,
                  ),
                  /*   Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 15,right: 15),
                        padding: EdgeInsets.only(top: 15),
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(5, 119, 128,1)
                        ),
                        child:                 Text(  Translation.of(context)!.translate('add_option')!,textAlign: TextAlign.center,  style: TextStyle(fontFamily: 'HelveticaNeueMedium',fontSize: 16, color:Colors.white),),

                      ),
                      SizedBox(
                        height: 20,
                      ),*/
                ],
              )),
            ),
          ],
        ),
      );
    }
    return widgets;
  }

  Container addRadioButton(int btnValue, String title) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 15, right: 15),
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 15),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
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
                Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: 'HelveticaNeueMedium',
                      fontSize: 16,
                      color: Colors.black),
                ),
              ],
            ),

            /*         Container(
              padding: EdgeInsets.all(9),
              margin: EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                  color: Colors.blue[50],

                  borderRadius: BorderRadius.circular(25)
              ),

              alignment: Alignment.center,
              width: 40,
              height: 40,
              child: Image.asset('assets/images/delete.png', fit: BoxFit.contain,),
            ),*/
          ],
        ));
  }

  dynamic onPollingCreate(/*{String? pollingQuestion}*/) async {
    // show loader
    global().showLoader(context);
    final http.Response response = await repository.onPollingCreateApi(
        name.text,
        startDateTime.toString(),
        endDateTime.toString(),
        addqstn.text.toString(),
        pollQstnList,
        widget.groupId.toString());
    Map<String, dynamic> map = json.decode(response.body);
    global().hideLoader(context);

    var createPollingStatus = map["message"];
    debugPrint(createPollingStatus);
    if (response.statusCode == 201 || response.statusCode == 200) {
      /*     RegisterModel model =
      RegisterModel.fromJson(jsonDecode(response.body));

      var tokenn = model.accessToken;
      String? token;
      token = tokenn;

      debugPrint("@@@ token : ${token}");
      PrefObj.preferences!.put(PrefKeys.AUTH_TOKEN, token);*/
      global().showSnackBarShowSuccess(context, "Polling Created successfully");
      Navigator.pop(context);
    } else {
      debugPrint("Polling not Created yet");
    }
  }
}

class PollingQstnModel {
  dynamic question_en;
  dynamic question_fr;
  dynamic option_1_en;
  dynamic option_2_en;
  dynamic option_3_en;
  dynamic option_4_en;
  dynamic option_5_en;
  dynamic option_1_fr;
  dynamic option_2_fr;
  dynamic option_3_fr;
  dynamic option_4_fr;
  dynamic option_5_fr;
  dynamic point;
  dynamic answer;

  PollingQstnModel({
    this.question_en,
    this.question_fr,
    this.option_1_en,
    this.option_2_en,
    this.option_3_en,
    this.option_4_en,
    this.option_5_en,
    this.option_1_fr,
    this.option_2_fr,
    this.option_3_fr,
    this.option_4_fr,
    this.option_5_fr,
    this.point,
    this.answer,
  });

  PollingQstnModel.fromJson(Map<String, dynamic> json) {
    question_en = json['question_en'];
    question_fr = json['question_fr'];
    option_1_en = json['option_1_en'];
    option_2_en = json['option_2_en'];
    option_3_en = json['option_3_en'];
    option_4_en = json['option_4_en'];
    option_5_en = json['option_5_en'];
    option_1_fr = json['option_1_fr'];
    option_2_fr = json['option_2_fr'];
    option_3_fr = json['option_3_fr'];
    option_4_fr = json['option_4_fr'];
    option_5_fr = json['option_5_fr'];
    point = json['point'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_en'] = this.question_en;
    data['question_fr'] = this.question_fr;
    data['option_1_en'] = this.option_1_en;
    data['option_2_en'] = this.option_2_en;
    data['option_3_en'] = this.option_3_en;
    data['option_4_en'] = this.option_4_en;
    data['option_5_en'] = this.option_5_en;
    data['option_1_fr'] = this.option_1_fr;
    data['option_2_fr'] = this.option_2_fr;
    data['option_3_fr'] = this.option_3_fr;
    data['option_4_fr'] = this.option_4_fr;
    data['option_5_fr'] = this.option_5_fr;
    data['point'] = this.point;
    data['answer'] = this.answer;
    return data;
  }
}
