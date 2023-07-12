import 'dart:convert';

import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../../../global/PrefKeys.dart';
import '../../../global/config.dart';
import '../../../global/global.dart';
import '../../../localizations/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';

import '../../../model/admin_grouplist_model.dart';
import '../../../model/payment_group_member_model.dart';

class PaymentManagementPage extends StatefulWidget {
  final String? groupId;
  const PaymentManagementPage({Key? key, this.groupId}) : super(key: key);

  @override
  State<PaymentManagementPage> createState() => _PaymentManagementPageState();
}

class _PaymentManagementPageState extends State<PaymentManagementPage> {
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
  bool sendNotification = false;

  String? selectedMonth;
  String? selectedMonth2;

  String? selectPaymentStartDate;
  String? selectPaymentEndDate;
  var selectedIndexesCheckBox = [];
  List<NotificationUserModel> notificationUserList = [];
  bool statusLanguage = false;
  TextEditingController _start_date_time_controller = TextEditingController();
  TextEditingController _end_date_time_controller = TextEditingController();
  PaymentGroupMemberModel? paymentGroupMemberData;
  List<PaymentGroupMember> paymentGroupMemberList = [];

  Future<void> GetPaymentMemberGroupList() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);
      final uri = Uri.parse(Config.apiurl +
          "group/${widget.groupId}/payment-collection?start_date=" +
          _start_date_time_controller.text.toString() +
          "&end_date=" +
          _end_date_time_controller.text.toString());

      debugPrint("admin group list url: $uri");

      var requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
            'Bearer ' + '${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}',
        'Accept-Language': 'en'
      };

      final requestBody = {};
      debugPrint("group Detail url: $requestHeaders");

      final response = await http.get(uri, headers: requestHeaders);
      debugPrint("response : " + json.decode(response.body).toString());

      global().hideLoader(context);

      dynamic responseJson;
      if (response.statusCode == 200) {
        debugPrint("success ");
        setState(() {
          responseJson = json.decode(response.body);
          paymentGroupMemberData =
              PaymentGroupMemberModel.fromJson(responseJson);
          paymentGroupMemberList = paymentGroupMemberData!.data!;
          //  paymentGroupMemberList = paymentGroupMemberList;
          /*   .where((msg) => (msg.memberType != 'admin'))
              .toList();*/
        });
      } else {
        global().showSnackBarShowError(
            context, 'Failed to get GroupDetailModel Data!');
      }
    } catch (e) {
      global().hideLoader(context);
      print('==>Failed to get GroupDetailModel ');
    }
  }

  Future<void> postPaymentMember(String userId) async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);
      //  final uri = Uri.parse(Config.apiurl + "group/12/payment-collection");

      final uri = Uri.parse(Config.apiurl + "payment-collection");

      debugPrint("admin group list url: $uri");

      var requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
            'Bearer ' + '${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}',
        'Accept-Language': 'en'
      };

      final requestBody = {
        "group_id": widget.groupId.toString(),
        "user_id": userId,
        "start_date": selectPaymentStartDate,
        "end_date": selectPaymentEndDate,
        "payment_status": '1',
        "remarks": 'Payment done by Admin',
      };

      debugPrint("body : " + jsonEncode(requestBody).toString());

      var response = await http.post(
        uri,
        headers: requestHeaders,
        body: jsonEncode(requestBody), // use jsonEncode()
      );

      debugPrint("response : " + json.decode(response.body).toString());

      Map<String, dynamic> map = json.decode(response.body);
      var messageShow = map["message"];

      global().hideLoader(context);

      dynamic responseJson;
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("success ");
        setState(() {
          responseJson = json.decode(response.body);
          GetPaymentMemberGroupList();
        });
      } else {
        global().showSnackBarShowError(context, 'Failed to get  Data!');
      }
    } catch (e) {
      global().hideLoader(context);
      print('==>Failed to get GroupDetailModel ');
    }
  }

  Future<void> sendNotificationToUsers() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);
      //  final uri = Uri.parse(Config.apiurl + "group/12/payment-collection");
      notificationUserList = [];
      if (selectedIndexesCheckBox.length > 0) {
        for (int pos = 0; pos < selectedIndexesCheckBox.length; pos++) {
          notificationUserList.add(NotificationUserModel(
              user_id: paymentGroupMemberList[selectedIndexesCheckBox[pos]]
                  .user!
                  .userId,
              group_id: widget.groupId,
              sender_id: PrefObj.preferences!.get(PrefKeys.USER_ID),
              start_date: _start_date_time_controller.text,
              end_date: _end_date_time_controller.text));
        }
      }

      final uri = Uri.parse(Config.apiurl + "payment-due-notification-sent");

      debugPrint("admin group list url: $uri");

      var requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
            'Bearer ' + '${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}',
        'Accept-Language': 'en'
      };

      final requestBody = {
        "data": List<dynamic>.from(notificationUserList.map((x) => x)),
      };

      debugPrint("body : " + jsonEncode(requestBody).toString());

      var response = await http.post(
        uri,
        headers: requestHeaders,
        body: jsonEncode(requestBody), // use jsonEncode()
      );

      debugPrint("response : " + json.decode(response.body).toString());

      Map<String, dynamic> map = json.decode(response.body);
      var messageShow = map["message"];

      global().hideLoader(context);

      dynamic responseJson;
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("success ");
        setState(() {
          responseJson = json.decode(response.body);
          global().showSnackBarShowSuccess(context, messageShow.toString());
          selectedIndexesCheckBox = [];
        });
      } else {
        global().showSnackBarShowError(context, messageShow.toString());
      }
    } catch (e) {
      global().hideLoader(context);
      print('==>Failed to get GroupDetailModel ');
    }
  }

  @override
  void initState() {
    var now = new DateTime.now();
    var firstDayThisMonth = new DateTime(now.year, now.month, 1);

// Find the last day of the month.
    var beginningNextMonth = (now.month < 12)
        ? new DateTime(now.year, now.month + 1, 1)
        : new DateTime(now.year + 1, 1, 1);
    var lastDay = beginningNextMonth.subtract(new Duration(days: 1)).day;
    var firstDayNextMonth =
        new DateTime(firstDayThisMonth.year, firstDayThisMonth.month, lastDay);

    _start_date_time_controller.text =
        firstDayThisMonth.toString().substring(0, 10);

    debugPrint("select month:" +
        _start_date_time_controller.text.toString().substring(6, 7));
    if (_start_date_time_controller.text.toString().substring(6, 7) == "1") {
      selectedMonth = "January";
    }
    if (_start_date_time_controller.text.toString().substring(6, 7) == "2") {
      selectedMonth = "February";
    }
    if (_start_date_time_controller.text.toString().substring(6, 7) == "3") {
      selectedMonth = "March";
    }
    if (_start_date_time_controller.text.toString().substring(6, 7) == "4") {
      selectedMonth = "April";
    }
    if (_start_date_time_controller.text.toString().substring(6, 7) == "5") {
      selectedMonth = "May";
    }
    if (_start_date_time_controller.text.toString().substring(6, 7) == "6") {
      selectedMonth = "June";
    }
    if (_start_date_time_controller.text.toString().substring(6, 7) == "7") {
      selectedMonth = "July";
    }
    if (_start_date_time_controller.text.toString().substring(6, 7) == "8") {
      selectedMonth = "August";
    }
    if (_start_date_time_controller.text.toString().substring(6, 7) == "9") {
      selectedMonth = "September";
    }
    if (_start_date_time_controller.text.toString().substring(6, 7) == "10") {
      selectedMonth = "October";
    }
    if (_start_date_time_controller.text.toString().substring(6, 7) == "11") {
      selectedMonth = "November";
    }
    if (_start_date_time_controller.text.toString().substring(6, 7) == "12") {
      selectedMonth = "December";
    }

    _end_date_time_controller.text =
        firstDayNextMonth.toString().substring(0, 10);

    if (_end_date_time_controller.text.toString().substring(6, 7) == "1") {
      selectedMonth2 = "January";
    }
    if (_end_date_time_controller.text.toString().substring(6, 7) == "2") {
      selectedMonth2 = "February";
    }
    if (_end_date_time_controller.text.toString().substring(6, 7) == "3") {
      selectedMonth2 = "March";
    }
    if (_end_date_time_controller.text.toString().substring(6, 7) == "4") {
      selectedMonth2 = "April";
    }
    if (_end_date_time_controller.text.toString().substring(6, 7) == "5") {
      selectedMonth2 = "May";
    }
    if (_end_date_time_controller.text.toString().substring(6, 7) == "6") {
      selectedMonth2 = "June";
    }
    if (_end_date_time_controller.text.toString().substring(6, 7) == "7") {
      selectedMonth2 = "July";
    }
    if (_end_date_time_controller.text.toString().substring(6, 7) == "8") {
      selectedMonth2 = "August";
    }
    if (_end_date_time_controller.text.toString().substring(6, 7) == "9") {
      selectedMonth2 = "September";
    }
    if (_end_date_time_controller.text.toString().substring(6, 7) == "10") {
      selectedMonth2 = "October";
    }
    if (_end_date_time_controller.text.toString().substring(6, 7) == "11") {
      selectedMonth2 = "November";
    }
    if (_end_date_time_controller.text.toString().substring(6, 7) == "12") {
      selectedMonth2 = "December";
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        GetPaymentMemberGroupList();
      });
    });

    super.initState();
  }

  // Select for Date
  Future<DateTime> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
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

  Future<DateTime> _selectStartDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2050),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        _start_date_time_controller.text =
            selectedDate.toString().substring(0, 10);

        if (_start_date_time_controller.text.toString().substring(6, 7) ==
            "1") {
          selectedMonth = "January";
        }
        if (_start_date_time_controller.text.toString().substring(6, 7) ==
            "2") {
          selectedMonth = "February";
        }
        if (_start_date_time_controller.text.toString().substring(6, 7) ==
            "3") {
          selectedMonth = "March";
        }
        if (_start_date_time_controller.text.toString().substring(6, 7) ==
            "4") {
          selectedMonth = "April";
        }
        if (_start_date_time_controller.text.toString().substring(6, 7) ==
            "5") {
          selectedMonth = "May";
        }
        if (_start_date_time_controller.text.toString().substring(6, 7) ==
            "6") {
          selectedMonth = "June";
        }
        if (_start_date_time_controller.text.toString().substring(6, 7) ==
            "7") {
          selectedMonth = "July";
        }
        if (_start_date_time_controller.text.toString().substring(6, 7) ==
            "8") {
          selectedMonth = "August";
        }
        if (_start_date_time_controller.text.toString().substring(6, 7) ==
            "9") {
          selectedMonth = "September";
        }
        if (_start_date_time_controller.text.toString().substring(6, 7) ==
            "10") {
          selectedMonth = "October";
        }
        if (_start_date_time_controller.text.toString().substring(6, 7) ==
            "11") {
          selectedMonth = "November";
        }
        if (_start_date_time_controller.text.toString().substring(6, 7) ==
            "12") {
          selectedMonth = "December";
        }

        debugPrint("select " + selectedDate.toString());
      });
    }
    return selectedDate;
  }

  Future<DateTime> _selectEndDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2050),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        _end_date_time_controller.text =
            selectedDate.toString().substring(0, 10);

        if (_end_date_time_controller.text.toString().substring(6, 7) == "1") {
          selectedMonth2 = "January";
        }
        if (_end_date_time_controller.text.toString().substring(6, 7) == "2") {
          selectedMonth2 = "February";
        }
        if (_end_date_time_controller.text.toString().substring(6, 7) == "3") {
          selectedMonth2 = "March";
        }
        if (_end_date_time_controller.text.toString().substring(6, 7) == "4") {
          selectedMonth2 = "April";
        }
        if (_end_date_time_controller.text.toString().substring(6, 7) == "5") {
          selectedMonth2 = "May";
        }
        if (_end_date_time_controller.text.toString().substring(6, 7) == "6") {
          selectedMonth2 = "June";
        }
        if (_end_date_time_controller.text.toString().substring(6, 7) == "7") {
          selectedMonth2 = "July";
        }
        if (_end_date_time_controller.text.toString().substring(6, 7) == "8") {
          selectedMonth2 = "August";
        }
        if (_end_date_time_controller.text.toString().substring(6, 7) == "9") {
          selectedMonth2 = "September";
        }
        if (_end_date_time_controller.text.toString().substring(6, 7) == "10") {
          selectedMonth2 = "October";
        }
        if (_end_date_time_controller.text.toString().substring(6, 7) == "11") {
          selectedMonth2 = "November";
        }
        if (_end_date_time_controller.text.toString().substring(6, 7) == "12") {
          selectedMonth2 = "December";
        }
        debugPrint("select " + selectedDate.toString());
      });
    }
    return selectedDate;
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 35,
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
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 15),
                child: Text(
                  Translation.of(context)!.translate('payment_collection')!.toString(),
                  style: TextStyle(
                      fontFamily: 'HelveticaNeueMedium',
                      color: Colors.black,
                      fontSize: 18),
                ),
              ),
              (selectedMonth == selectedMonth2)?
              Container(
                margin: EdgeInsets.only(left: 15),
                child: Text(
                  selectedMonth.toString() +
              " "+
                      _start_date_time_controller.text
                          .toString()
                          .substring(0, 4),
                  style: TextStyle(
                      fontFamily: 'HelveticaNeueMedium',
                      color: Colors.black,
                      fontSize: 18),
                ),
              ):
              Container(
                margin: EdgeInsets.only(left: 15),
                child: Text(
                  selectedMonth.toString() +
                      " - " +
                      selectedMonth2.toString() +
                      " " +
                      _start_date_time_controller.text
                          .toString()
                          .substring(0, 4),
                  style: TextStyle(
                      fontFamily: 'HelveticaNeueMedium',
                      color: Colors.black,
                      fontSize: 18),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 55,
            margin: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextField(
              decoration: InputDecoration(
                suffix: InkWell(
                  onTap: () {
                    _selectStartDate(context);
                    showDateTime = true;
                  },
                  child: Container(
                      margin: EdgeInsets.only(top: 15, right: 10),
                      child: Image.asset('assets/images/calendar2.png',
                          height: 22, width: 22, fit: BoxFit.cover)),
                ),
                labelText: Translation.of(context)!
                    .translate('start_date_with_out_time')!,
                hintText: "YYYY-MM-DD",
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
              controller: _start_date_time_controller,
            ),
          ),
          Container(
            height: 55,
            margin: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextField(
              decoration: InputDecoration(
                suffix: InkWell(
                  onTap: () {
                    _selectEndDate(context);
                    showDateTime = true;
                  },
                  child: Container(
                      margin: EdgeInsets.only(top: 15, right: 10),
                      child: Image.asset('assets/images/calendar2.png',
                          height: 22, width: 22, fit: BoxFit.cover)),
                ),
                labelText: Translation.of(context)!
                    .translate('end_date_with_out_time')!,
                hintText: "YYYY-MM-DD",
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
              controller: _end_date_time_controller,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Visibility(
              child: InkWell(
                child: Container(
                    margin: EdgeInsets.only(top: 0),
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
                  GetPaymentMemberGroupList();
                  if (paymentGroupMemberList.length < 1) {
                    global().showSnackBarShowError(
                        context, 'Please select member first!');
                  }
                },
              ),
              visible: true),
          SizedBox(
            height: 20,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 15, bottom: 1),
                  child: Text(
                    Translation.of(context)!
                        .translate('payment_status_of_group_member')!,
                    style: TextStyle(
                        fontFamily: 'HelveticaNeueMedium',
                        color: Colors.black,
                        fontSize: 18),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: FlutterSwitch(
                      width: 50,
                      height: 25,
                      activeTextColor: Colors.white,
                      inactiveTextColor: Colors.white,
                      activeTextFontWeight: FontWeight.w400,
                      inactiveTextFontWeight: FontWeight.w400,
                      activeColor: Colors.green,
                      inactiveColor: Colors.red,
                      toggleSize: 22,
                      activeText: '',
                      inactiveText: '',
                      value: sendNotification,
                      showOnOff: true,
                      onToggle: (bool val) {
                        if (!sendNotification) {
                          if (selectedIndexesCheckBox.length > 0) {
                            sendNotification = val;
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  actions: <Widget>[
                                    SizedBox(
                                      height: 28,
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Do You Want to Send Notification Message?',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Comfortaa',
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 6,
                                                  bottom: 6),
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              child: Text(
                                                Translation.of(context)!
                                                    .translate('cancel')!,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              )),
                                          onTap: () {
                                            sendNotification = false;
                                            Navigator.pop(context);
                                          },
                                        ),
                                        InkWell(
                                          child: Stack(
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      left: 15,
                                                      right: 15,
                                                      top: 6,
                                                      bottom: 6),
                                                  decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30)),
                                                  child: Text(
                                                    'Send',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                            sendNotificationToUsers();
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
                          } else {
                            global().showSnackBarShowError(context,
                                "Kindly select member for send notification");
                          }
                        }
                      }),
                ),
              ]),
          SizedBox(
            height: 5,
          ),
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(right: 5),
            child: Text(
              "Send Notification",
              style: TextStyle(
                  fontFamily: 'HelveticaNeueMedium',
                  color: Colors.black,
                  fontSize: 12),
            ),
          ),
          Container(
            child: paymentGroupMemberList.length > 0
                ? Expanded(
                    child: ListView.builder(
                        itemCount: paymentGroupMemberList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 0, right: 10, top: 10, bottom: 10),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      child: paymentGroupMemberList[index]
                                              .has_payment!
                                          ? Checkbox(
                                              value: false,
                                              onChanged: (value) {})
                                          : Checkbox(
                                              value: selectedIndexesCheckBox
                                                  .contains(index),
                                              onChanged: (value) {
                                                if (selectedIndexesCheckBox
                                                    .contains(index)) {
                                                  selectedIndexesCheckBox
                                                      .remove(
                                                          index); // unselect
                                                } else {
                                                  selectedIndexesCheckBox
                                                      .add(index); // select
                                                }

                                                print(selectedIndexesCheckBox
                                                    .toString());
                                              })),
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        paymentGroupMemberList[index]
                                                    .user!
                                                    .profileImage ==
                                                null
                                            ? CircleAvatar(
                                                radius: 22,
                                                backgroundImage: NetworkImage(
                                                    "https://ui-avatars.com/api/?name=" +
                                                        paymentGroupMemberList[
                                                                index]
                                                            .user!
                                                            .nameEn
                                                            .toString()
                                                            .toUpperCase()),
                                              )
                                            : CircleAvatar(
                                                radius: 22,
                                                backgroundImage: NetworkImage(
                                                    /*Config.imageurl +*/
                                                    paymentGroupMemberList[
                                                            index]
                                                        .user!
                                                        .profileImage
                                                        .toString()),
                                              ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  paymentGroupMemberList[index]
                                                      .user!
                                                      .nameEn
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 6,
                                                ),
                                                Text(
                                                  paymentGroupMemberList[index]
                                                      .memberType
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 0),
                                        child: FlutterSwitch(
                                            width: 74,
                                            height: 30,
                                            activeTextColor: Colors.white,
                                            inactiveTextColor: Colors.white,
                                            activeTextFontWeight:
                                                FontWeight.w400,
                                            inactiveTextFontWeight:
                                                FontWeight.w400,
                                            activeText: "Paid",
                                            inactiveText: "Due",
                                            activeColor: Colors.green,
                                            inactiveColor: Colors.red,
                                            toggleSize: 26,
                                            value: paymentGroupMemberList[index]
                                                .has_payment!,
                                            showOnOff: true,
                                            onToggle: (val) {
                                              if (!paymentGroupMemberList[index]
                                                  .has_payment!) {
                                                showCustomDateRangePicker(
                                                  context, dismissible: true,
                                                  minimumDate: DateTime.now()
                                                      .subtract(const Duration(
                                                          days: 30)),
                                                  maximumDate: DateTime.now()
                                                      .add(const Duration(
                                                          days: 30)),
                                                  // endDate: endDate,
                                                  // startDate: startDate,
                                                  backgroundColor: Colors.white,
                                                  primaryColor: Colors.green,
                                                  onApplyClick: (start, end) {
                                                    setState(() {
                                                      selectPaymentStartDate =
                                                          start
                                                              .toString()
                                                              .substring(0, 10);
                                                      selectPaymentEndDate = end
                                                          .toString()
                                                          .substring(0, 10);
                                                      print(
                                                          selectPaymentEndDate);
                                                      print(
                                                          selectPaymentStartDate);

                                                      if (selectPaymentEndDate !=
                                                              null &&
                                                          selectPaymentStartDate !=
                                                              null) {
                                                        Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    500), () {
                                                          setState(() {
                                                            postPaymentMember(
                                                                paymentGroupMemberList[
                                                                        index]
                                                                    .user!
                                                                    .userId
                                                                    .toString());
                                                          });
                                                        });
                                                      }
                                                    });
                                                  },
                                                  onCancelClick: () {
                                                    setState(() {
                                                      selectPaymentEndDate =
                                                          null;
                                                      selectPaymentStartDate =
                                                          null;
                                                    });
                                                  },
                                                );
                                              }
                                            }),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }))
                : Container(
                    height: 200,
                    alignment: Alignment.center,
                    child: Text(
                      "No Members found",
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}

class NotificationUserModel {
  dynamic user_id;
  dynamic group_id;
  dynamic sender_id;
  dynamic start_date;
  dynamic end_date;
  NotificationUserModel({
    this.user_id,
    this.group_id,
    this.sender_id,
    this.start_date,
    this.end_date,
  });

  NotificationUserModel.fromJson(Map<String, dynamic> json) {
    user_id = json['user_id'];
    group_id = json['group_id'];
    sender_id = json['sender_id'];
    start_date = json['start_date'];
    end_date = json['end_date'];
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': this.user_id,
      'group_id': this.group_id,
      'sender_id': this.sender_id,
      'start_date': this.start_date,
      'end_date': this.end_date,
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.user_id;
    data['group_id'] = this.group_id;
    data['sender_id'] = this.sender_id;
    data['start_date'] = this.start_date;
    data['end_date'] = this.end_date;
    return data;
  }
}
