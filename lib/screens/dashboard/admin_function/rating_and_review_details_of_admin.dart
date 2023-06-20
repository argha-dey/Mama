import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../global/PrefKeys.dart';
import '../../../global/config.dart';
import '../../../global/global.dart';
import '../../../localizations/app_localizations.dart';

import 'package:http/http.dart' as http;
import 'dart:async';

import '../../../model/group_detail_model.dart';

class ReviewAndRatingOfAdmin extends StatefulWidget {
  final String? groupId;
  const ReviewAndRatingOfAdmin({Key? key, this.groupId}) : super(key: key);

  @override
  State<ReviewAndRatingOfAdmin> createState() => _ReviewAndRatingOfAdminState();
}

class _ReviewAndRatingOfAdminState extends State<ReviewAndRatingOfAdmin> {
  GroupDetailModel? groupDetailsData;
  List<Review>? reviewList = [];

  Future<void> GetGroupDetailData() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);
      final uri = Uri.parse(
          Config.apiurl + Config.groupdetail + widget.groupId.toString());
      //  final uri = Uri.parse(Config.apiurl + Config.groupdetail + "12");
      debugPrint("group Detail url: $uri");

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
        setState(() {
          responseJson = json.decode(response.body);
          groupDetailsData = GroupDetailModel.fromJson(responseJson);
          reviewList = groupDetailsData!.data!.review;
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

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        GetGroupDetailData();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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
          Container(
            margin: EdgeInsets.only(left: 15),
            child: Text(
              Translation.of(context)!.translate('member_reviews')!,
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
            child: reviewList!.length > 0
                ? Expanded(
                    child: ListView.builder(
                        itemCount: reviewList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 16, right: 16, top: 10, bottom: 10),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: 22,
                                          backgroundImage: NetworkImage(
                                              "https://ui-avatars.com/api/?name=" +
                                                  reviewList![index]
                                                      .user!
                                                      .nameEn
                                                      .toString()
                                                      .toUpperCase()),
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
                                                  reviewList![index]
                                                      .user!
                                                      .nameEn
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 6,
                                                ),
                                                Text(
                                                  reviewList![index]
                                                      .description
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 12,
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
                                        margin:
                                            EdgeInsets.only(left: 10, top: 0),
                                        alignment: Alignment.topLeft,
                                        child: RatingBar.builder(
                                          ignoreGestures: true,
                                          initialRating: double.parse(
                                              reviewList![index]
                                                  .point
                                                  .toString()),
                                          itemSize: 15,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.orange,
                                            size: 10,
                                          ),
                                          onRatingUpdate: (rating) {},
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }))
                : Container(
                    height: MediaQuery.of(context).size.height - 220,
                    alignment: Alignment.center,
                    child: Text(
                      "No Reviews Found!",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
