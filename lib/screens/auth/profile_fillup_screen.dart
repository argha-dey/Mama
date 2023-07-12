import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../global/PrefKeys.dart';
import '../../global/config.dart';
import '../../global/global.dart';
import '../../localizations/app_localizations.dart';
import '../../model/register_model.dart';
import '../../repository/repository.dart';
import '../dashboard/dashboard_screen.dart';
import 'dart:async';

import 'dart:io';

class ProfileFillupScreen extends StatefulWidget {
  final String? phoneNo;
  final String? countryCode;
  const ProfileFillupScreen({Key? key, this.phoneNo, this.countryCode})
      : super(key: key);

  @override
  State<ProfileFillupScreen> createState() => _ProfileFillupScreenState();
}

class _ProfileFillupScreenState extends State<ProfileFillupScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController phn = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController birthday = TextEditingController();
  List gender = ["Stockvel", "Burial Society", "Both"];
  List gender2 = ["Chairman/Secretary", "Other Member"];
  String selectGenderType = "";
  String selectGenderType2 = "";
  final repository = Repository();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dateTime = DateTime.now();
  bool showDate = false;
  bool showTime = false;
  bool showDateTime = false;
  String? strtDate;
//  bool showDate = false;
  final ImagePicker _picker = ImagePicker();
  String? _fileName = "";
  final picker = ImagePicker();
  String? imageBase64 = "";
  File? imageFile = null;
  XFile? _imageFileList;
  late Uint8List imagevalue;

  Future<DateTime> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        birthday.text = selectedDate.toString().substring(0, 10);
        debugPrint("select " + selectedDate.toString());
      });
    }
    return selectedDate;
  }

  String getDateTime() {
    // ignore: unnecessary_null_comparison
    if (dateTime == null) {
      return 'select date timer';
    } else {
      return DateFormat('yyyy-MM-dd').format(dateTime);
    }
  }

  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : value;
    _fileName = _imageFileList!.name;
    imageFile = File(value!.path);

/*    fileNames.add(_fileName!);
    print("fileNames $fileNames");*/
    imageBase64 = FileConverter.getBase64FormateFile(_imageFileList!.path);
  }

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        _fileName = imageFile!.path.split('/').last;
        imageBase64 =
            FileConverter.getBase64FormateFile(imageFile!.path.toString());

        //  log(""+imageBase64!);
      });
    }
  }

  Future<void> _imgFromCamera(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 25,
    );
    debugPrint("camera source : $source");
    setState(() {
      _setImageFileListFromFile(pickedFile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(left: 15, top: 90, bottom: 70),
                child: Text(
                  Translation.of(context)!.translate('complete_your')!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'HelveticaNeueMedium',
                    fontSize: 23,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(
                  left: 15,
                ),
                child: Text(
                  Translation.of(context)!.translate('profile_image')!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'HelveticaNeueMedium',
                    fontSize: 19,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            InkWell(
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: EdgeInsets.only(top: 30, left: 15),
                    padding: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26)),
                    child: Column(
                      children: [
                        Container(
                            width: 100,
                            height: 100,
                            child: imageFile == null
                                ? Container(
                                    width: 20,
                                    height: 20,
                                    child: Image.asset(
                                      'assets/images/profile.png',
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                : Image.file(imageFile!)),
                        SizedBox(
                          height: 9,
                        ),
                        Text(
                          Translation.of(context)!
                              .translate('upload_profile_image')!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'HelveticaLight',
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ],
                    )),
              ),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext bc) {
                      return SafeArea(
                        child: Container(
                          child: new Wrap(
                            children: <Widget>[
                              new ListTile(
                                  leading: new Icon(Icons.photo_library),
                                  title: new Text(Translation.of(context)!
                                      .translate('gallery')!),
                                  onTap: () {
                                    _getFromGallery();

                                    //_pickFiles();
                                    Navigator.pop(context);
                                  }),
                              new ListTile(
                                leading: new Icon(Icons.photo_camera),
                                title: new Text(Translation.of(context)!
                                    .translate('camera')!),
                                onTap: () {
                                  _imgFromCamera(ImageSource.camera);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(left: 15, top: 20),
                child: Text(
                  Translation.of(context)!.translate('personal_details')!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'HelveticaNeueMedium',
                    fontSize: 19,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              height: 60,
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              child: TextField(
                decoration: InputDecoration(
                  labelText: Translation.of(context)!.translate('name')!,
                  hintText: Translation.of(context)!.translate('enter_name')!,
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
            Container(
              height: 55,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              padding: EdgeInsets.only(left: 15, right: 15, top: 15),
              child: Text(widget.phoneNo.toString()),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue[100]!),
                  borderRadius: BorderRadius.circular(40)),

              /* TextField(
                   decoration: InputDecoration(
                     labelText:  widget.phoneNo,
                       enabled: false ,
                     labelStyle:TextStyle(fontFamily: 'HelveticaLight',fontSize: 16, color:Colors.black),
                     hintStyle:TextStyle(fontFamily: 'HelveticaLight',fontSize: 16, color:Colors.black26),

                     enabledBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(40),
                       borderSide:  BorderSide(color:Colors.blue[100]!,),

                     ),
                     focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(40),
                       borderSide:  BorderSide(color:Colors.blue[100]!, ),

                     ),

                   ),
                   controller: phn,

                 ),*/
            ),
            Container(
              height: 55,
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              child: TextField(
                decoration: InputDecoration(
                  labelText: Translation.of(context)!.translate('email')!,
                  hintText: Translation.of(context)!.translate('enter_email')!,
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
                    borderSide: BorderSide(color: Colors.blue[100]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(
                      color: Colors.blue[100]!,
                    ),
                  ),
                ),
                controller: email,
              ),
            ),
            Container(
              height: 60,
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              child: TextField(
                decoration: InputDecoration(
                  labelText: Translation.of(context)!.translate('address')!,
                  hintText:
                      Translation.of(context)!.translate('enter_address')!,
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
                controller: address,
              ),
            ),
            Container(
              height: 55,
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              child: TextField(
                decoration: InputDecoration(
                  suffix: InkWell(
                    onTap: () {
                      _selectDate(context);
                      showDate = true;
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 15, right: 10),
                        child: Image.asset('assets/images/calendar2.png',
                            height: 22, width: 22, fit: BoxFit.cover)),
                  ),
                  labelText: Translation.of(context)!.translate('birthday')!,
                  hintText: "DD/MM/YYYY",
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
                    borderSide: BorderSide(
                      color: Colors.blue[100]!,
                    ),
                  ),
                ),
                controller: birthday,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(left: 15, top: 20),
                child: Text(
                  Translation.of(context)!.translate('select_group_type')!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'HelveticaNeueMedium',
                    fontSize: 19,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                addRadioButton(
                    0, Translation.of(context)!.translate('stockvel')!),
                addRadioButton(
                    1, Translation.of(context)!.translate('burial_society')!),
                addRadioButton(2, Translation.of(context)!.translate('both')!),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(left: 15, top: 20),
                child: Text(
                  Translation.of(context)!.translate('select_role')!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'HelveticaNeueMedium',
                    fontSize: 19,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: addRadioButton2(
                    0,
                    Translation.of(context)!.translate('chairman')!,
                  ),
                ),
                Expanded(
                  child: addRadioButton2(
                    1,
                    Translation.of(context)!.translate('other_member')!,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                if (name.text.isEmpty ||
                    widget.phoneNo.toString() == "" ||
                    widget.countryCode.toString() == "" ||
                    email.text.isEmpty ||
                    address.text.isEmpty ||
                    birthday.text.toString() == "" ||
                    selectGenderType == "" ||
                    selectGenderType2 == "" ||
                    imageBase64!.isEmpty) {
                  showSnackBarShowError(context, "Please fill up all fields");
                } else {
                  onProfileFillup();
                }
              },
              child: Container(
                  margin: EdgeInsets.only(top: 90),
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
                        margin: EdgeInsets.only(
                          top: 13,
                        ),
                        child: Text(
                          Translation.of(context)!.translate('save_continue')!,
                          // textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )
                    ],
                  )),
            ),
            Align(
                alignment: Alignment.center,
                child: Container(
                  margin:
                      EdgeInsets.only(left: 25, right: 25, top: 25, bottom: 60),
                  child: Text(
                    Translation.of(context)!.translate('your_bday_will')!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(128, 128, 128, 1),
                        fontFamily: 'HelveticaLight'),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Container addRadioButton(
    int btnValue,
    String title,
  ) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio<String>(
          activeColor: Color.fromRGBO(5, 119, 128, 1),
          value: gender[btnValue],
          groupValue: selectGenderType,
          onChanged: (value) {
            setState(() {
              selectGenderType = value.toString();
              print(selectGenderType);
            });
          },
        ),
        Text(
          title,
          style: TextStyle(fontSize: 14),
        ),
      ],
    ));
  }

  Container addRadioButton2(
    int btnValue,
    String title,
  ) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio<String>(
          activeColor: Color.fromRGBO(5, 119, 128, 1),
          value: gender2[btnValue],
          groupValue: selectGenderType2,
          onChanged: (value) {
            setState(() {
              selectGenderType2 = value.toString();
              print(selectGenderType2);
            });
          },
        ),
        Text(
          title,
          style: TextStyle(fontSize: 14),
        ),
      ],
    ));
  }

  Future<void> onProfileFillup() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);
      final uri = Uri.parse(Config.apiurl + Config.register);
      debugPrint("register url: $uri");

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        "timezone":
        '${PrefObj.preferences!.get(PrefKeys.MAMA_APP_TIME_ZONE)}',
        "Accept-Language": "en"
      };

      final body = {
        "device_token":
        '${PrefObj.preferences!.get(PrefKeys.MAMA_APP_DEVICE_TOKEN)}',
        "name_en": name.text,
        "name_fr": name.text,
        "email": email.text,
        "timezone":
        '${PrefObj.preferences!.get(PrefKeys.MAMA_APP_TIME_ZONE)}',
        "mobile_code": widget.countryCode.toString(),
        "mobile": widget.phoneNo.toString(),
        "address": address.text,
        "date_of_birth": birthday.text.toString(),
        "user_type": "member",
        "group_type": selectGenderType == 'Stockvel'
            ? 1
            : selectGenderType == "Burial Society"
            ? 2
            : 3,
        "user_role": selectGenderType2 == "Chairman/Secretary" ? 1 : 2,
        "profile_image": "data:image/png;base64," + imageBase64!
      };

      debugPrint("body : " + jsonEncode(body).toString());

      var response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body), // use jsonEncode()
      );

      debugPrint("response : " + json.decode(response.body).toString());

      Map<String, dynamic> map = json.decode(response.body);
      var messageShow = map["message"];

      //  print('Response status: ${response.statusCode}');
      //  print('Response body: ${response.headers}');
      //   print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        global().hideLoader(context);
        RegisterModel model = RegisterModel.fromJson(jsonDecode(response.body));

        var tokenn = model.accessToken;
        var nameUser = model.user!.name.toString();
        var nameUserId = model.user!.userId.toString();
        String? token;
        token = tokenn;

        debugPrint("@@@ token : ${token}");
        debugPrint("@@@ token : ${nameUser}");
        debugPrint("@@@ token : ${nameUserId}");

        PrefObj.preferences!.put(PrefKeys.IS_LOGIN_STATUS, true);
        PrefObj.preferences!.put(PrefKeys.USER_ID, nameUserId);
        PrefObj.preferences!.put(PrefKeys.USER_NAME, nameUser);
        PrefObj.preferences!.put(PrefKeys.AUTH_TOKEN, token);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
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
}

class FileConverter {
  static String getBase64FormateFile(String path) {
    File file = File(path);
    print('File is = ' + file.toString());

    List<int> fileInByte = file.readAsBytesSync();
    String fileInBase64 = base64Encode(fileInByte);
    return fileInBase64;
  }
}
