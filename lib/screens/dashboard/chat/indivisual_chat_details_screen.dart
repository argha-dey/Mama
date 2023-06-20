import 'package:flutter/material.dart';

class IndivisualChatDetailsScreen extends StatefulWidget {
  const IndivisualChatDetailsScreen({Key? key}) : super(key: key);

  @override
  State<IndivisualChatDetailsScreen> createState() => _IndivisualChatDetailsScreenState();
}

class _IndivisualChatDetailsScreenState extends State<IndivisualChatDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                width: 400,
                height: 125,
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage("assets/images/group_info.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 5,left: 10),
                child:     GestureDetector(
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
            ],
          ),

          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.only(left: 15),
            child: Text(
              'lorem ipsum',
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 21),
            ) ,
          ) ,
          SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 15),
            child: Text(
              'Date Of Joining: 22.01.2021',
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 16),
            ) ,
          ) ,
          SizedBox(
            height: 8,
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 15),
            child: Text(
              'D0B: 22th March,1993',
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 16),
            ) ,
          ) ,
          SizedBox(
            height: 8,
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 15),
            child: Text(
              '+91 - 99999999',
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 16),
            ) ,
          ) ,
          SizedBox(
            height: 8,
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 15),
            child: Text(
              'abc@gmail.com',
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 16),
            ) ,
          ) ,
          SizedBox(
            height: 8,
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 15),
            child: Text(
              'Kalyani,a-block,pin-39993939',
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 16),
            ) ,
          ) ,
          SizedBox(
            height: 8,
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 15),
            child: Text(
              'Community Group Type:Stockvel',
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 16),
            ) ,
          ) ,
          SizedBox(
            height: 8,
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 15),
            child: Text(
              'Your Role:Chairman',
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 16),
            ) ,
          ),

          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
