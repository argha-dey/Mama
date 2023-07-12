import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../global/PrefKeys.dart';
import '../../../global/config.dart';
import '../../../global/global.dart';
import '../../../localizations/app_localizations.dart';
import '../../../model/event_ceate_model.dart';
import 'admin_event_list_page.dart';
import 'generate_event_qr_code.dart';
import 'package:http/http.dart' as http;

class CreateEventPage extends StatefulWidget {
  final String? groupId;
  final String? groupName;
  final String? groupNumber;
  final String? groupCreateOn;
  const CreateEventPage(
      {Key? key,
      this.groupId,
      this.groupName,
      this.groupNumber,
      this.groupCreateOn})
      : super(key: key);

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  TextEditingController _start_date_time_controller = TextEditingController();
  TextEditingController _end_date_time_controller = TextEditingController();
  TextEditingController event_name_controller = TextEditingController();
  TextEditingController event_description = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dateTime = DateTime.now();
  bool showDate = false;
  bool showTime = false;
  bool showDateTime = false;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  String? endDateTime;
  String? startDateTime;

  EventCreateData? eventCreateData;
  bool isCeateQRcode = false;
  bool isSubmitEvent = true;
  bool editTextFieldReadOnly = false;

  // Select for Date
  Future<DateTime> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2045),
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

  Future _selectStartDateTime(BuildContext context) async {
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
      _start_date_time_controller.text = getDateTime();
      startDate = getDateTime().substring(0, 10);
      startTime = getDateTime().substring(12, 21);
      startDateTime = startDate.toString() + startTime.toString();
      debugPrint("start datetime " + startDateTime.toString());
    });
  }

  Future _selectEndDateTime(BuildContext context) async {
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

      _end_date_time_controller.text = getDateTime();
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

  Future<void> onAddEventCreate() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);
      final uri = Uri.parse(Config.apiurl + "event");
      debugPrint("member req url: $uri");

      var requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        "timezone":
        '${PrefObj.preferences!.get(PrefKeys.MAMA_APP_TIME_ZONE)}',
        'Authorization':
            'Bearer ' + '${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}',
        'Accept-Language': 'en'
      };

      final body = {
        "group_id": widget.groupId.toString(),
        "description": event_description.text,
        "start_on": startDateTime.toString(),
        "end_on": endDateTime.toString(),
        "name_en": event_name_controller.text,
        "name_fr": event_name_controller.text,
        "active_status": 1
      };

      debugPrint("body : " + jsonEncode(body).toString());

      var response = await http.post(
        uri,
        headers: requestHeaders,
        body: jsonEncode(body), // use jsonEncode()
      );

      debugPrint("response : " + json.decode(response.body).toString());

      Map<String, dynamic> map = json.decode(response.body);
      var messageShow = map["message"];
      dynamic responseJson;
      if (response.statusCode == 200 || response.statusCode == 201) {
        global().hideLoader(context);
        showSnackBarShowSuccess(context, "Event Create Successfully.");
        //   Navigator.pop(context);
        responseJson = json.decode(response.body);
        eventCreateData = EventCreateData.fromJson(responseJson);
        setState(() {
          isCeateQRcode = true;
          isSubmitEvent = false;
          editTextFieldReadOnly = true;
        });
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
                    InkWell(
                      child: Container(
                        //   margin: EdgeInsets.only(left: 45),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(5, 119, 128, 1),
                            borderRadius: BorderRadius.circular(5)),
                        alignment: Alignment.center,
                        width: 25,
                        height: 25,
                        child: Image.asset(
                          'assets/images/vote2.png',
                          fit: BoxFit.contain,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminEventListPage(
                                  groupId: widget.groupId.toString(),
                                  groupName: widget.groupName.toString(),
                                  groupCreateOn:
                                      widget.groupCreateOn.toString(),
                                  groupNumber: widget.groupNumber.toString())),
                        );
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(
                Translation.of(context)!.translate('create_event')!,
                style: TextStyle(
                    fontFamily: 'HelveticaNeueMedium',
                    color: Colors.black,
                    fontSize: 17),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 55,
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              child: TextField(
                readOnly: editTextFieldReadOnly,
                decoration: InputDecoration(
                  labelText: Translation.of(context)!.translate('event_name')!,
                  hintText: "Event name",
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
                    borderSide: BorderSide(color: Colors.blue[100]!),
                  ),
                ),
                controller: event_name_controller,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 55,
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              child: TextField(
                readOnly: editTextFieldReadOnly,
                decoration: InputDecoration(
                  suffix: InkWell(
                    onTap: () {
                      _selectStartDateTime(context);
                      showDateTime = true;
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 15, right: 10),
                        child: Image.asset('assets/images/calendar2.png',
                            height: 22, width: 22, fit: BoxFit.cover)),
                  ),
                  labelText: Translation.of(context)!.translate('start_date')!,
                  hintText: "YYYY-MM-DD | hh:mm:ss",
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
                    borderSide: BorderSide(color: Colors.blue[100]!),
                  ),
                ),
                controller: _start_date_time_controller,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 55,
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              child: TextField(
                readOnly: editTextFieldReadOnly,
                decoration: InputDecoration(
                  suffix: InkWell(
                    onTap: () {
                      _selectEndDateTime(context);
                      showDateTime = true;
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 15, right: 10),
                        child: Image.asset('assets/images/calendar2.png',
                            height: 22, width: 22, fit: BoxFit.cover)),
                  ),
                  labelText: Translation.of(context)!.translate('end_date')!,
                  hintText: "YYYY-MM-DD | hh:mm:ss",
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
                    borderSide: BorderSide(color: Colors.blue[100]!),
                  ),
                ),
                controller: _end_date_time_controller,
              ),
            ),
            SizedBox(
              height: 35,
            ),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 15, right: 15),
                child: TextField(
                  readOnly: editTextFieldReadOnly,
                  maxLines: 5,
                  decoration: InputDecoration(
                    //     labelText:                                     Translation.of(context)!.translate('name')!,

                    hintText: "Event Description",
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
                  controller: event_description,
                )),
            SizedBox(
              height: 30,
            ),
            Visibility(
                child: InkWell(
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 19),
                            ),
                          )
                        ],
                      )),
                  onTap: () {
                    if( event_description.text.isEmpty||
                    startDateTime.toString().isEmpty||
                     endDateTime.toString().isEmpty||
                     event_name_controller.text.isEmpty){
                      global().showSnackBarShowError(context, "Please fill up all fields properly !");
                    }
                    else{
                      onAddEventCreate();
                    }

                  },
                ),
                visible: isSubmitEvent),
            SizedBox(
              height: 10,
            ),
            Visibility(
              child: InkWell(
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
                            Translation.of(context)!
                                .translate('create_qr_code')!,
                            // textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 19),
                          ),
                        )
                      ],
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GenerateEventQRCodeScreen(
                              groupId: eventCreateData!.groupId.toString(),
                              eventId: eventCreateData!.event_id.toString(),
                              eventStartOn:
                                  eventCreateData!.start_on.toString(),
                              eventName: eventCreateData!.end_on.toString(),
                              eventGroupName: widget.groupName.toString(),
                              eventEndOn: eventCreateData!.end_on.toString(),
                              eventDescribtion:
                                  eventCreateData!.description.toString(),
                            )),
                  );
                },
              ),
              visible: isCeateQRcode,
            )
          ],
        ),
      ),
    );
  }
}
