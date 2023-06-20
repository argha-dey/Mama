import 'package:flutter/material.dart';

import '../dashboard_screen.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileFillupScreenState();
}

class _ProfileFillupScreenState extends State<ProfileEditScreen> {
  TextEditingController _controller = TextEditingController();
  List gender = ["Male", "Female", "Mf"];
  String selectGenderType = "Male";

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
                  'Complete Profile',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'HelveticaNeueBold',
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
                  'Profile Image',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'HelveticaNeueBold',
                    fontSize: 19,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                  margin: EdgeInsets.only(top: 30, left: 15),
                  padding: EdgeInsets.all(7),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black26)),
                  child: Column(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        child: Image.asset(
                          'assets/images/profile.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        height: 9,
                      ),
                      Text(
                        'Upload Profile\n Image',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'HelveticaLight',
                            fontSize: 16,
                            color: Colors.black),
                      ),
                    ],
                  )),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(left: 15, top: 20),
                child: Text(
                  'Personal Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'HelveticaNeueBold',
                    fontSize: 19,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'name',
                  hintText: "Enter Your Name",
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
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(5, 119, 128, 1),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(5, 119, 128, 1),
                    ),
                  ),
                ),
                controller: _controller,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'email id',
                  hintText: "Enter Your Email Id",
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
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(5, 119, 128, 1),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(5, 119, 128, 1),
                    ),
                  ),
                ),
                controller: _controller,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'address',
                  hintText: "Enter Your Complete Address",
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
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(5, 119, 128, 1),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(5, 119, 128, 1),
                    ),
                  ),
                ),
                controller: _controller,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'birthday',
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
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(5, 119, 128, 1),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(5, 119, 128, 1),
                    ),
                  ),
                ),
                controller: _controller,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(left: 15, top: 20),
                child: Text(
                  'Select Your Community Group Type',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'HelveticaNeueBold',
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
                  child: addRadioButton(0, "Stockvel"),
                ),
                Expanded(
                  child: addRadioButton(1, "Burial \nSociety"),
                ),
                Expanded(
                  child: addRadioButton(2, "Both"),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(left: 15, top: 20),
                child: Text(
                  'Select Your Role',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'HelveticaNeueBold',
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
                  child: addRadioButton(0, "Chairman/Secretary"),
                ),
                Expanded(
                  child: addRadioButton(1, "Other Member"),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => DashboardScreen()),
                );
              },
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  padding: EdgeInsets.only(top: 13, bottom: 13),
                  margin: EdgeInsets.only(right: 15, top: 75, bottom: 20),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(5, 119, 128, 1),
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    "Save & Continue",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 19),
                  )),
            ),
            Align(
                alignment: Alignment.center,
                child: Container(
                  margin:
                      EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 60),
                  child: Text(
                    'Your Birthday Will Be Shared With Group Member But Your Age Will Not Be Shared With Group Members',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black38, fontFamily: 'HelveticaLight'),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Container addRadioButton(int btnValue, String title) {
    return Container(
        margin: EdgeInsets.only(left: 15),
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
                  //  selectGenderType = value.toString();
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
}
