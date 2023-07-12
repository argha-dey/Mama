import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../global/config.dart';
import '../../polling_question_screen.dart';

class ReplyCard extends StatelessWidget {
  final dynamic message;
  final String? time;
  final String? type;
  final String? sender_name;
  final String? is_redirect;
  final String? is_sent_by_system;
  final String? groupId;
  final String? polling_id;
  const ReplyCard(
      {Key? key,
      required this.message,
      required this.time,
      required this.sender_name,
      required this.type,
      this.is_redirect,
      this.is_sent_by_system,
      this.groupId,
      this.polling_id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: is_sent_by_system == "1"
              ? InkWell(
                  child: Card(
                    elevation: 0,
                    color: Color.fromRGBO(6, 169, 183, 1.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 2,
                          right: 5,
                          child: Row(
                            children: [
                              Text(
                                "~" + getInitials(sender_name.toString()),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 50,
                            top: 20,
                            bottom: 20,
                          ),
                          child: type == 'image'
                              ? CachedNetworkImage(
                                  imageUrl: Config.imageurl + message!,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.grey),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                )
                              : Text(
                                  message!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 10,
                          child: Text(
                            time!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    print(
                        "click on replay tag=>  is_sent_by_system: $is_sent_by_system +"
                        " is_redirect: $is_redirect");

                    print("groupId:  $groupId");
                    //TODO: Redirect to polling page is re-direct 1 and System sent

                    if (is_sent_by_system == "1" &&
                        is_redirect == "1" &&
                        polling_id != "null") {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => PollingQstnScreen(
                                  pollingId: polling_id.toString(),
                                )),
                      );
                    }
                  })
              : Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  // color: Color(0xffdcf8c6),
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 2,
                        right: 5,
                        child: Row(
                          children: [
                            Text(
                              "~" + getInitials(sender_name.toString()),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 50,
                          top: 20,
                          bottom: 20,
                        ),
                        child: type == 'image'
                            ? CachedNetworkImage(
                                imageUrl: Config.imageurl + message!,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.grey),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )
                            : Text(
                                message!,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 10,
                        child: Text(
                          time!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                )),
    );
  }

  String getInitials(bank_account_name) {
    List<String> names = bank_account_name.split(" ");
    String initials = "";
/*    int numWords = 2;

    if(numWords < names.length) {
      numWords = names.length;
    }
    for(var i = 0; i < numWords; i++){
      initials += '${names[i][0]}';
    }*/
    initials = names[0];
    return initials;
  }
}
