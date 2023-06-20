import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import '../../../localizations/app_localizations.dart';

class GenerateEventQRCodeScreen extends StatefulWidget {
  final String? eventId;
  final String? groupId;
  final String? eventName;
  final String? eventDescribtion;
  final String? eventStartOn;
  final String? eventEndOn;
  final String? eventGroupName;
  GenerateEventQRCodeScreen(
      {Key? key,
      this.groupId,
      this.eventId,
      this.eventName,
      this.eventDescribtion,
      this.eventStartOn,
      this.eventEndOn,
      this.eventGroupName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => GenerateEventQRCodeScreenState();
}

class GenerateEventQRCodeScreenState extends State<GenerateEventQRCodeScreen> {
  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;

  GlobalKey? globalKey = new GlobalKey();
  String _dataString = "";
  String? _inputErrorText;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    final dataBody = {
      "project_name": "Mama",
      "event_id": widget.eventId.toString(),
      "group_id": widget.groupId.toString(),
      "event_name": widget.eventName.toString(),
      "event_description": widget.eventDescribtion.toString(),
      "event_start_on": widget.eventStartOn.toString(),
      "event_end_on": widget.eventEndOn.toString(),
      "event_group_name": widget.eventGroupName.toString(),
    };

    _dataString = jsonEncode(dataBody).toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _contentWidget(),
    );
  }

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary = globalKey!.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      final channel = const MethodChannel('channel:me.alfian.share/share');
      channel.invokeMethod('shareFile', 'image.png');
    } catch (e) {
      print(e.toString());
    }
  }

  _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height;
    return Container(
      color: const Color(0xFFFFFFFF),
      child: Column(
        children: <Widget>[
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
            height: 25,
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 10),
            child: Text(
              'Meeting Attendance QR Code',
              style: TextStyle(
                  fontFamily: 'HelveticaNeueMedium',
                  color: Colors.black,
                  fontSize: 17),
            ),
          ),
          SizedBox(
            height: 45,
          ),
          Container(
            child: Center(
              child: RepaintBoundary(
                key: globalKey,
                child: QrImage(
                  data: _dataString,
                  size: 320,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 35,
          ),
          Container(
            margin: EdgeInsets.only(left: 15),
            child: Text(
              '[ Scan QR ]',
              style: TextStyle(
                  fontFamily: 'HelveticaNeueMedium',
                  color: Colors.black,
                  fontSize: 26),
            ),
          )
        ],
      ),
    );
  }
}
