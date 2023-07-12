import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mama/screens/dashboard/chat/chat_details_screen.dart';
import 'package:mama/screens/dashboard/polling_screen.dart';
import 'package:mama/screens/dashboard/profile/about_us_screen.dart';
import 'package:mama/screens/dashboard/profile/faq_screen.dart';
import 'package:mama/screens/dashboard/profile/privacy_policy_screen.dart';
import 'package:mama/screens/dashboard/profile/support_screen.dart';
import 'package:mama/screens/dashboard/profile/terms_conditions_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../bloc/group_bloc.dart';
import '../../bloc/profile_detail_bloc.dart';
import '../../global/PrefKeys.dart';
import '../../global/config.dart';
import '../../global/global.dart';
import '../../global/global_socket_connection.dart';
import '../../global/rotating_icon_button.dart';
import '../../localizations/app_localizations.dart';
import '../../localizations/language_model.dart';
import '../../model/admin_grouplist_model.dart';
import '../../model/edit_profile_model.dart';
import '../../model/group_detail_model.dart';
import '../../model/group_model.dart';
import '../../model/profile_detail_model.dart';
import '../../repository/repository.dart';
import '../auth/profile_fillup_screen.dart';
import '../auth/sign_up_screen.dart';
import '../scanner/generate_screen.dart';
import '../scanner/scanner_screen.dart';
import 'admin_function/admin_group_details_screen.dart';
import 'chat/group_chat_screen.dart';
import 'chat/indivisual_chat_screen.dart';
import 'chat/select_group_for_payment_status_screen.dart';
import 'joining_request_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:math' as math;
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'notification/notification_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  int? _lastTimeBackButtonWasTapped;
  static const exitTimeInMillis = 2000;
  AnimationController? _animationController;
  TextEditingController name = TextEditingController();
  TextEditingController phn = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController birthday = TextEditingController();
  TextEditingController groupSearchController = TextEditingController();
  TextEditingController _avlGroupSearchController = TextEditingController();
  TextEditingController _searchPersonTextController = TextEditingController();
  String prev = "";
  String? img;
  var nextPageUrl;
  var loadCompleted = false;
  ScrollController _scrollControllerIndividual = new ScrollController();
  late TabController _tabController;

  ProfileDetailsModel? profileDetails;
  GroupModel? groupData;

  List<IndividualUser> avlGroupDataList = [];
  List<IndividualUser> allReadyJoinGroupDataList = [];
  List<IndividualUser> groupIndividualMemberDataList = [];

  List<IndividualUser> searchResultForIndividual = [];
  late IO.Socket _socket;
  int? tabIndex;

  bool onTap = false;
  bool onTap2 = false;
  List gender = ["Stockvel", "Burial \nSociety", "Both"];
  List gender2 = ["Chairman/Secretary", "Other Member"];
  String selectGenderType = "";
  String selectGenderType2 = "";

  final GlobalKey<ExpansionTileCardState> _languageKeys = GlobalKey();
  LangModel? languageModel;
  late String dropLanguageValue;

  final repository = Repository();
  File? imageFile = null;

  final ImagePicker _picker = ImagePicker();
  String? _fileName = "";
  final picker = ImagePicker();
  String? imageBase64 = "";
  XFile? _imageFileList;
  late Uint8List imagevalue;
  DateTime selectedDate = DateTime.now();
  String? strtDate;
  DateTime dateTime = DateTime.now();
  bool showDate = false;
  GroupDetailModel? groupdetailData;
  AdminGroupListModel? adminGroupList;
  String? mem_name;
  String? from_user_id;

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

  _connectSocket() async {
    _socket = await GlobalSocketConnection()
        .connectSocket(PrefObj.preferences!.get(PrefKeys.USER_ID).toString());
    _socket.onConnect((data) => print('Connection established Successfully'));

    _socket.on('connect', (data) => print(' socketid : ${_socket.id}'));

    _socket.onConnectError((data) => print('Connect Error: $data'));

    _getAvlGroupListListen();

    _socket.on(
        'receive_avl_group_list_${from_user_id}', _receiveAvlGroupListListen);

//    socket.on('receive_avl_group_list_for_all', receiveAvlGroupListListenAll);

    _getAllReadyJoinGroupListListen();

    _socket.on(
        'receive_chat_group_list_${from_user_id}', _receiveChatGroupListListen);

    _getUserChatListListen();

    _socket.on(
        'receive_chat_user_list_${from_user_id}', _receiveChatUserListListen);
  }

  _reconnectSocket() async {
    _socket = await GlobalSocketConnection()
        .connectSocket(PrefObj.preferences!.get(PrefKeys.USER_ID).toString());
    _socket.onConnect((data) => print('Connection established Successfully'));
    _socket.on(
        'connect', (_) => print('Connection to _socketid : ${_socket.id}'));
    _socket.onConnectError((data) => print('Connect Error: $data'));
  }

  _receiveChatUserListListen(data) {
    log('chat_user_list : $data');
    log('user_id=> : $from_user_id');
    List jsonResponse = json.decode(data);
    groupIndividualMemberDataList =
        jsonResponse.map((job) => new IndividualUser.fromJson(job)).toList();
  }

  _receiveChatGroupListListen(data) {
    log('get_chat_group_list=> : $data');
    log('user_id=> : $from_user_id');
    List jsonResponse = json.decode(data);
    allReadyJoinGroupDataList =
        jsonResponse.map((job) => new IndividualUser.fromJson(job)).toList();
  }

  _getUserChatListListen() {
    log('user_id=> : $from_user_id');
    _socket.emit('get_chat_user_list', {
      json.encode({'user_id': from_user_id, 'keyword': ''})
    });
  }

  _getAvlGroupListListen() {
    log('user_id=> : $from_user_id');
    _socket.emit('get_avl_group_list', {
      json.encode({'user_id': from_user_id, 'keyword': ''})
    });
  }

  _getAllReadyJoinGroupListListen() {
    log('user_id=> : $from_user_id');
    _socket.emit('get_chat_group_list', {
      json.encode({'user_id': from_user_id, 'keyword': ''})
    });
  }

  _receiveAvlGroupListListen(data) {
    log('receive_avl_group_list=> : $data');
    log('user_id=> : $from_user_id');
    List jsonResponse = json.decode(data);
    avlGroupDataList =
        jsonResponse.map((job) => new IndividualUser.fromJson(job)).toList();
  }

  @override
  void initState() {
    _connectSocket();
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 300));

    from_user_id = PrefObj.preferences!.get(PrefKeys.USER_ID).toString();
    onTap = false;
    _tabController = new TabController(vsync: this, length: 5);
//    _tabController.addListener(_handleTabSelection);
    PrefObj.preferences!.get(PrefKeys.LANG).toString() == 'fr'
        ? dropLanguageValue = 'French'
        : dropLanguageValue = 'English';

    groupSearchController.addListener(_groupSearch);
    _searchPersonTextController.addListener(_indiVidualSearch);
    _avlGroupSearchController.addListener(_avlGroupSearch);

/*    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        GetGroupData();
      });
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        GetProfileDetails();
      });
    });*/

    super.initState();
  }

/*  void _handleTabSelection() {

    if (_tabController.index==3) {

    }

  }*/

  Future<void> GetProfileDetails() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);
      final uri = Uri.parse(Config.apiurl + Config.profileDetail);
      debugPrint("profileDetail url: $uri");

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
      debugPrint("response : " + json.decode(response.body).toString());

      if (response.statusCode == 200) {
        setState(() {
          responseJson = json.decode(response.body);
          profileDetails = ProfileDetailsModel.fromJson(responseJson);
          name.text = profileDetails!.data!.nameEn ?? "";
          phn.text = profileDetails!.data!.mobile ?? "";
          email.text = profileDetails!.data!.email ?? "";
          address.text = profileDetails!.data!.address ?? "";
          birthday.text = profileDetails!.data!.dateOfBirth ?? "";
          img = profileDetails!.data!.profileImage!;
          debugPrint("need img" + profileDetails!.data!.profileImage!);
          selectGenderType = profileDetails!.data!.groupType == '0'
              ? 'Stockvel'
              : profileDetails!.data!.groupType == '1'
                  ? 'Burial \nSociety'
                  : 'Both';
          if (profileDetails!.data!.userRole.toString() == "0") {
            selectGenderType2 = "Chairman/Secretary";
          } else {
            selectGenderType2 = "Other Member";
          }

          debugPrint("need " + profileDetails!.data!.userRole.toString());
        });
      } else {
        global().showSnackBarShowError(context, 'Failed to get profile Data!');
      }
    } catch (e) {
      print('==>Failed to register the doctor ');
    }
  }

/*  Future<void> GetGroupData() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);
      final uri = Uri.parse(Config.apiurl + Config.group);
      debugPrint("group url: $uri");



      var requestHeaders = {
        'Content-Type':'application/json',
        'Accept':'application/json',
        'Authorization': 'Bearer '+'${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}',
        'Accept-Language' : 'en'
      };

      final requestBody = {

      };
      debugPrint("group url: $requestHeaders");




      final response = await http.get(uri, headers: requestHeaders);
      debugPrint("response : "+json.decode(response.body).toString());

      global().hideLoader(context);

      dynamic responseJson;
      if (response.statusCode == 200) {

        setState(() {
          groupDataList = [];
          responseJson = json.decode(response.body);
          groupData =  GroupModel.fromJson(responseJson);
          groupDataList = groupData!.data!;

        });
      } else {

        global().showSnackBarShowError(context,'Failed to get GroupModel Data!');
      }
    }catch(e){
      global().hideLoader(context);
      print('==>Failed to get GroupModel ');
    }
  }

  Future<void> GetGroupDataSearch(String searchText) async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);
      final uri = Uri.parse(Config.apiurl + Config.group+"?"+"name_en="+searchText+"&"+"name_fr=""");
      debugPrint("group url: $uri");



      var requestHeaders = {
        'Content-Type':'application/json',
        'Accept':'application/json',
        'Authorization': 'Bearer '+'${PrefObj.preferences!.get(PrefKeys.AUTH_TOKEN)}',
        'Accept-Language' : 'en'
      };


      debugPrint("group url: $requestHeaders");




      final response = await http.get(uri, headers: requestHeaders);
      debugPrint("response : "+json.decode(response.body).toString());

      global().hideLoader(context);

      dynamic responseJson;
      if (response.statusCode == 200) {

        setState(() {
          groupDataList = [];
          responseJson = json.decode(response.body);
          groupData =  GroupModel.fromJson(responseJson);
          groupDataList = groupData!.data!;
        });
      } else {

        global().showSnackBarShowError(context,'Failed to get GroupModel Data!');
      }
    }catch(e){
      global().hideLoader(context);
      print('==>Failed to get GroupModel ');
    }
  }*/

  Future<void> GetGroupDetailData() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);
      final uri = Uri.parse(Config.apiurl + Config.groupdetail + "5");
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
        debugPrint("success ");
        setState(() {
          responseJson = json.decode(response.body);
          groupdetailData = GroupDetailModel.fromJson(responseJson);

          for (int index = 0;
              index < groupdetailData!.data!.groupMember!.length;
              index++) {
            mem_name = groupdetailData!.data!.groupMember![index].user!.nameEn
                .toString();
          }

          debugPrint(" user name : " +
              PrefObj.preferences!.get(PrefKeys.USER_NAME).toString());
          debugPrint("member name  : " + mem_name.toString());

          if (mem_name ==
              PrefObj.preferences!.get(PrefKeys.USER_NAME).toString()) {
            /*     Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => PollingScreen()),
            );*/
            //   isAlreadyJoinedVisible = true;
          } else {
            showSnackBarShowError(context, "No polling found.");
            //  isAlreadyJoinedVisible = false;
          }
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

  Future<void> GetAdminGroupList() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      global().showLoader(context);
      final uri = Uri.parse(Config.apiurl + "my-group?member_type=admin");

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
          adminGroupList = AdminGroupListModel.fromJson(responseJson);
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
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          _tabSwapUsingBackButton(context, tabIndex!);
          return false;
        },
        child: DefaultTabController(
          length: 5,
          child: Scaffold(
              appBar: AppBar(
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  bottom: TabBar(
                    onTap: (index) {
                      debugPrint("index $index");
                      setState(() {
                        if (index == 4) {
                          tabIndex = 4;
                          onTap = false;
                          GetProfileDetails();
                        } else if (index == 3) {
                          tabIndex = 3;
                          onTap = false;
                          GetAdminGroupList();
                        } else if (index == 0) {
                          tabIndex = 0;
                          _getAvlGroupListListen();
                        } else if (index == 1) {
                          tabIndex = 1;
                          _getAllReadyJoinGroupListListen();
                        } else if (index == 2) {
                          tabIndex = 2;
                          _getUserChatListListen();
                        }
                      });
                    },
                    indicatorColor: Colors.black,
                    controller: _tabController,
                    tabs: [
                      Tab(
                        child: Container(
                          width: 20,
                          height: 20,
                          child: _tabController.index == 0
                              ? Image.asset(
                                  'assets/images/selhome.png',
                                  fit: BoxFit.contain,
                                )
                              : Image.asset(
                                  'assets/images/home.png',
                                  fit: BoxFit.contain,
                                ),
                        ),
                      ),
                      Tab(
                        child: Container(
                            width: 20,
                            height: 20,
                            child: _tabController.index == 1
                                ? Image.asset(
                                    'assets/images/selgroup.png',
                                    fit: BoxFit.contain,
                                  )
                                : Image.asset(
                                    'assets/images/group.png',
                                    fit: BoxFit.contain,
                                  )),
                      ),
                      Tab(
                        child: Container(
                          width: 20,
                          height: 20,
                          child: _tabController.index == 2
                              ? Image.asset(
                                  'assets/images/seluser.png',
                                  fit: BoxFit.contain,
                                )
                              : Image.asset(
                                  'assets/images/indivisual.png',
                                  fit: BoxFit.contain,
                                ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          width: 20,
                          height: 20,
                          child: _tabController.index == 3
                              ? Image.asset(
                                  'assets/images/admin_function2.png',
                                  fit: BoxFit.contain,
                                )
                              : Image.asset(
                                  'assets/images/admin_function.png',
                                  fit: BoxFit.contain,
                                ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          width: 20,
                          height: 20,
                          child: _tabController.index == 4
                              ? Image.asset(
                                  'assets/images/selprof.png',
                                  fit: BoxFit.contain,
                                )
                              : Image.asset(
                                  'assets/images/user.png',
                                  fit: BoxFit.contain,
                                ),
                        ),
                      ),
                    ],
                  ),
                  title: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 110,
                          height: 110,
                          child: Image.asset(
                            'assets/images/koleka_green.png',
                            fit: BoxFit.contain,
                          ),
                        ),

                        /* Container(

                  child: Text(
                    'MAMA',
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                  ) ,
                ),*/
                        Row(
                          children: [
                            /*                     InkWell(
                              child: Container(
                                //   margin: EdgeInsets.only(left: 45),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.blue[50],

                                    borderRadius: BorderRadius.circular(25)
                                ),
                                alignment: Alignment.center,
                                width: 25,
                                height: 25,
                                child: Image.asset('assets/images/polling.png', fit: BoxFit.contain,),
                              ) ,
                              onTap: (){
setState(() {
  GetGroupDetailData();
});



                              },
                            ),*/

                            SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => ScanScreen()),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(25)),
                                alignment: Alignment.center,
                                width: 25,
                                height: 25,
                                child: Image.asset(
                                  'assets/images/barcode_scanner.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => NotificationScreen()),
                                );
                              },
                              child: Container(
                                //  margin: EdgeInsets.only(left: 45),
                                padding: EdgeInsets.all(5),

                                decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(25)),
                                alignment: Alignment.center,
                                width: 25,
                                height: 25,
                                child: Image.asset(
                                  'assets/images/bell.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                          ],
                        ),
                      ],
                    ),
                    color: Colors.white,
                  )),
              body: WillPopScope(
                onWillPop: () async => false,
                child: ScopedModelDescendant<LangModel>(
                    builder: (context, child, model) {
                  languageModel = model;

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      onTap2 == false
                          ? Visibility(
                              child: homeTab(),
                              visible: true,
                            )
                          : Visibility(
                              child: groupTab(),
                              visible: true,
                            ),
                      groupTab(),
                      indivisualTab(),
                      adminGroupListTab(),
                      onTap == false
                          ? Visibility(
                              child: profileTab(),
                              visible: true,
                            )
                          : Visibility(
                              child: editProfile(),
                              visible: true,
                            ),
                    ],
                  );
                }),
              )),
        ));
  }

  Widget english() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          // ignore: prefer_const_literals_to_create_immutables
        ),
        child: ExpansionTileCard(
          key: _languageKeys,
          onExpansionChanged: (value) {
            setState(() {
              // print(checkExpansionTile);
            });
            setState(() {});
          },
          children: [
            dropLanguageValue == 'English'
                ? ListTile(
                    title: Text(
                      "French",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        dropLanguageValue = 'French';
                        PrefObj.preferences!.put(PrefKeys.LANG, 'fr');
                        languageModel!.changeLanguage('fr');
                        _languageKeys.currentState?.collapse();
                      });
                    },
                  )
                : ListTile(
                    title: Text(
                      "English",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                    ),
                    onTap: () {
                      dropLanguageValue = 'English';
                      PrefObj.preferences!.put(PrefKeys.LANG, 'en');

                      languageModel!.changeLanguage('en');
                      _languageKeys.currentState?.collapse();
                    },
                  )
          ],
          title: Text(
            dropLanguageValue!,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 14,
            ),
          ),
        ));
  }

  Widget editProfile() {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(left: 15, top: 25),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.only(top: 30, left: 15),
                      padding: EdgeInsets.all(7),
                      child: imageFile == null
                          ? Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                  profileDetails == null ? "" : img.toString(),
                                  //file:///image-vJQkle4EGXcCkTqCOqLqwDq1be057OvaP56fNE7w.png
                                ),
                              ))
                          : Image.file(
                              imageFile!,
                              width: 45,
                              height: 45,
                            ),
                    ),
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

                /*   Container(
                  padding: EdgeInsets.all(9),
                  margin: EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                      color: Colors.blue[50],

                      borderRadius: BorderRadius.circular(25)
                  ),

                  alignment: Alignment.center,
                  width: 35,
                  height: 35,
                  child: Image.asset('assets/images/delete.png', fit: BoxFit.contain,),
                ),*/
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(left: 15, top: 20),
                child: Text(
                  Translation.of(context)!.translate('personal_detail')!,
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
              height: 60,
              margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
              padding: EdgeInsets.only(
                left: 5,
                right: 5,
              ),
              child: TextFormField(
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
              child: Text(profileDetails!.data!.mobile.toString()),
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
            /*  Container(
              height: 55,
              margin: EdgeInsets.only(left: 15,right: 15,top: 15),
              child: TextField(
                decoration: InputDecoration(

                  labelText: Translation.of(context)!.translate('telephn_no')!,
                  hintText:"+27 - 9000000" ,
                  labelStyle:TextStyle(fontFamily: 'HelveticaLight',fontSize: 16, color:Colors.black26),
                  hintStyle:TextStyle(fontFamily: 'HelveticaLight',fontSize: 16, color:Colors.black26),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide:  BorderSide(color:Colors.blue[100]!, ),

                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide:  BorderSide(color:Colors.blue[100]!, ),

                  ),

                ),
                controller: phn,

              ),
            ),*/
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
                    email.text.isEmpty ||
                    address.text.isEmpty ||
                    birthday.text.isEmpty) {
                  showSnackBarShowError(context, "Please fill up all fields");
                } else {
                  setState(() {
                    onEditProfile();
                    //   onTap = false;
                  });
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
                        margin: EdgeInsets.only(top: 12),
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
                      EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 60),
                  child: Text(
                    Translation.of(context)!.translate('your_bday_will')!,
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

  Container addRadioButton2(int btnValue, String title) {
    return Container(
        margin: EdgeInsets.only(left: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Radio<String>(
              activeColor: Color.fromRGBO(5, 119, 128, 1),
              value: gender2[btnValue],
              groupValue: selectGenderType2,
              onChanged: (value) {
                setState(() {
                  print(value);
                  selectGenderType2 = value.toString();
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

  Widget homeTab() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 30),
            height: 40,
            child: TextField(
              controller: _avlGroupSearchController,
              decoration: InputDecoration(
                labelText:
                    "Search Available Group" /*Translation.of(context)!.translate('search_group')!*/,
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontFamily: 'HelveticaLight',
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 25,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(color: Colors.black26)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
              ),
              //  controller: _controller,
            ),
          ),
          SizedBox(
            height: 35,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(
                    left: 15,
                  ),
                  child: Text(
                    Translation.of(context)!.translate('available_group')!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'HelveticaNeueMedium',
                      fontSize: 19,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              RotatingIconButton(
                onTap: () {
                  _getAvlGroupListListen();
                },
                rotateType: RotateType.full,
                clockwise: true,
                background: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: const Icon(
                  Icons.refresh,
                  color: Color.fromRGBO(5, 119, 128, 1),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          avlGroupDataList.length > 0
              ? Container(
                  height: 130,
                  child: ListView.builder(
                      itemCount: avlGroupDataList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => JoiningRequestSCreen(
                                        groupid: avlGroupDataList[index]
                                            .id
                                            .toString(),
                                        userid: PrefObj.preferences!
                                            .get(PrefKeys.USER_ID)
                                            .toString(),
                                      )),
                            );
                          },
                          child: Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.all(6),
                                child: avlGroupDataList[index].image == null
                                    ? Image.network(
                                        "https://ui-avatars.com/api/?name=" +
                                            avlGroupDataList[index]
                                                .name_en!
                                                .toString()
                                                .toUpperCase(),
                                        fit: BoxFit.contain,
                                        width: 90,
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: Config.imageurl +
                                            avlGroupDataList[index]
                                                .image!
                                                .toString(),
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: 90,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              //image size fill
                                              image: imageProvider,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            Container(
                                              width: 90,
                                              height: 90,
                                          color: Colors.grey.withOpacity(0.6),
                                        ),
                                        //show progress  while loading image
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 90,
                                height: 42,
                                color: Color.fromRGBO(5, 119, 128, 1),
                                /*  .withOpacity(0.8),*/
                                margin: EdgeInsets.only(left: 6, top: 55),
                                child: Text(
                                  avlGroupDataList[index].name_en!,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }))
              : Container(
                  margin: EdgeInsets.only(left: 15, bottom: 15),
                  child: Text(
                    "Please Wait For A Moment Please!",
                    style: TextStyle(
                        fontFamily: "HelveticaNeueMedium",
                        color: Colors.grey,
                        fontSize: 14),
                  ),
                ),
          /*      Container(
              height: 130,
              child:    ListView.builder(
                  itemCount: 20,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return  InkWell(
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => JoiningRequestSCreen()),
                        );
                      },
                      child:    Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.all(6),

                            child: Image.asset('assets/images/item.png', fit: BoxFit.contain,width: 90,),
                          ),
                          Container(
                            width: 90,
                            height: 40,
                            color: Color.fromRGBO(5, 119, 128,1).withOpacity(0.6),
                            margin: EdgeInsets.only(left: 6,top: 55),
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              'Railway\nlovers',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,),
                            ) ,
                          ),
                        ],
                      ),
                    )

                    ;


                  })),*/
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: 15, bottom: 15),
              child: Text(
                Translation.of(context)!.translate('your_chats')!,
                style: TextStyle(
                    fontFamily: "HelveticaNeueMedium",
                    color: Colors.black,
                    fontSize: 19),
              ),
            ),
          ),
          allReadyJoinGroupDataList.length > 0
              ? Expanded(
                  child: ListView.builder(
                      itemCount: allReadyJoinGroupDataList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var group_name =
                            allReadyJoinGroupDataList[index].name_en.toString();
                        var group_id =
                            allReadyJoinGroupDataList[index].id.toString();
                        var group_image =
                            allReadyJoinGroupDataList[index].image;

                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => GroupChatScreen(
                                      to_user_id: group_id,
                                      to_user_name: group_name,
                                      socket: _socket,
                                      img: group_image == null
                                          ? "https://ui-avatars.com/api/?name=" +
                                              group_name.toUpperCase()
                                          : Config.imageurl + group_image)),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, top: 10, bottom: 10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      allReadyJoinGroupDataList[index].image ==
                                              null
                                          ? CircleAvatar(
                                              radius: 22,
                                              backgroundImage: NetworkImage(
                                                  "https://ui-avatars.com/api/?name=" +
                                                      allReadyJoinGroupDataList[
                                                              index]
                                                          .name_en
                                                          .toString()
                                                          .toUpperCase()),
                                            )
                                          : CircleAvatar(
                                              radius: 22,
                                              backgroundImage: NetworkImage(
                                                  Config.imageurl +
                                                      allReadyJoinGroupDataList[
                                                              index]
                                                          .image),
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
                                                allReadyJoinGroupDataList[index]
                                                    .name_en
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
                                              allReadyJoinGroupDataList[index]
                                                          .last_message ==
                                                      null
                                                  ? Text(
                                                      "No new message available",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors
                                                              .grey.shade600,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    )
                                                  : allReadyJoinGroupDataList[
                                                                  index]
                                                              .last_message
                                                              .toString()
                                                              .contains(
                                                                  '.jpg') ||
                                                          allReadyJoinGroupDataList[
                                                                  index]
                                                              .last_message
                                                              .toString()
                                                              .contains('.png')
                                                      ? imagePreviewWidget()
                                                      : Text(
                                                          allReadyJoinGroupDataList[
                                                                  index]
                                                              .last_message
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors
                                                                .grey.shade600,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                          maxLines: 1,
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
                                    allReadyJoinGroupDataList[index]
                                                .last_message ==
                                            null
                                        ? Container()
                                        : Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: Text(
                                              allReadyJoinGroupDataList[index]
                                                  .last_message_time
                                                  .toString()
                                                  .substring(11, 16),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                  fontSize: 12),
                                            ),
                                          ),
                                    allReadyJoinGroupDataList[index].unseen != 0
                                        ? Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.transparent),
                                            margin: EdgeInsets.only(
                                                right: 10, top: 5),
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              allReadyJoinGroupDataList[index]
                                                  .unseen
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.transparent,
                                                  fontSize: 8),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }))
              : Text("No Joined Group(s) found",
                  style: TextStyle(fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget groupTab() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 30),
            height: 40,
            child: TextField(
              controller: groupSearchController,
              decoration: InputDecoration(
                labelText: Translation.of(context)!.translate('search_group')!,
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontFamily: 'HelveticaLight',
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 25,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(color: Colors.black26)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
              ),
              //      controller: _controller,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          allReadyJoinGroupDataList.length > 0
              ? Expanded(
                  child: ListView.builder(
                      itemCount: allReadyJoinGroupDataList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var group_name =
                            allReadyJoinGroupDataList[index].name_en.toString();
                        var group_id =
                            allReadyJoinGroupDataList[index].id.toString();
                        var group_image =
                            allReadyJoinGroupDataList[index].image;

                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => GroupChatScreen(
                                        to_user_id: group_id,
                                        to_user_name: group_name,
                                        socket: _socket,
                                        img: group_image == null
                                            ? "https://ui-avatars.com/api/?name=" +
                                                group_name.toUpperCase()
                                            : Config.imageurl + group_image,
                                      )),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, top: 10, bottom: 10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      allReadyJoinGroupDataList[index].image ==
                                              null
                                          ? CircleAvatar(
                                              radius: 22,
                                              backgroundImage: NetworkImage(
                                                  "https://ui-avatars.com/api/?name=" +
                                                      allReadyJoinGroupDataList[
                                                              index]
                                                          .name_en
                                                          .toString()
                                                          .toUpperCase()),
                                            )
                                          : CircleAvatar(
                                              radius: 22,
                                              backgroundImage: NetworkImage(
                                                  Config.imageurl +
                                                      allReadyJoinGroupDataList[
                                                              index]
                                                          .image
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
                                                allReadyJoinGroupDataList[index]
                                                    .name_en
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
                                              allReadyJoinGroupDataList[index]
                                                          .last_message ==
                                                      null
                                                  ? Text(
                                                      "No new message available",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors
                                                              .grey.shade600,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    )
                                                  : allReadyJoinGroupDataList[
                                                                  index]
                                                              .last_message
                                                              .toString()
                                                              .contains(
                                                                  '.jpg') ||
                                                          allReadyJoinGroupDataList[
                                                                  index]
                                                              .last_message
                                                              .toString()
                                                              .contains('.png')
                                                      ? imagePreviewWidget()
                                                      : Text(
                                                          allReadyJoinGroupDataList[
                                                                  index]
                                                              .last_message
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.grey
                                                                  .shade600,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                          maxLines: 1,
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
                                    allReadyJoinGroupDataList[index]
                                                .last_message ==
                                            null
                                        ? Container()
                                        : Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: Text(
                                              allReadyJoinGroupDataList[index]
                                                  .last_message_time
                                                  .toString()
                                                  .substring(11, 16),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                  fontSize: 12),
                                            ),
                                          ),
                                    allReadyJoinGroupDataList[index].unseen != 0
                                        ? Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.transparent,
                                            ),
                                            margin: EdgeInsets.only(
                                                right: 10, top: 5),
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              allReadyJoinGroupDataList[index]
                                                  .unseen
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.transparent,
                                                  fontSize: 8),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }))
              : Text(
                  "No Joined Group(s) found",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
        ],
      ),
    );
  }

  Widget adminGroupListTab() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          adminGroupList == null
              ? Container(
                  margin: EdgeInsets.only(top: 150),
                  child: Text("No Group found"),
                )
              : adminGroupList!.data!.length > 0
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: adminGroupList!.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => AdminGroupDetailsScreen(
                                            groupId: adminGroupList!
                                                .data![index].groupId
                                                .toString(),
                                          )),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 16, right: 16, top: 10, bottom: 10),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Row(
                                        children: <Widget>[
                                          adminGroupList!.data![index].image ==
                                                  null
                                              ? CircleAvatar(
                                                  radius: 22,
                                                  backgroundImage: NetworkImage(
                                                      "https://ui-avatars.com/api/?name=" +
                                                          adminGroupList!
                                                              .data![index].name
                                                              .toString()
                                                              .toUpperCase()),
                                                )
                                              : CircleAvatar(
                                                  radius: 22,
                                                  backgroundImage: NetworkImage(
                                                      Config.imageurl +
                                                          adminGroupList!
                                                              .data![index]
                                                              .image
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
                                                    adminGroupList!
                                                        .data![index].name
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
                                                    "Admin",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors
                                                            .grey.shade600,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Text(
                                            "",
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                                fontSize: 12),
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
                      alignment: Alignment.center,
                      child: Text(
                        "No Admin Groups found",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
        ],
      ),
    );
  }

  Widget indivisualTab() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 30),
            height: 40,
            child: TextField(
              controller: _searchPersonTextController,
              decoration: InputDecoration(
                labelText: Translation.of(context)!.translate('search_person')!,
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontFamily: 'HelveticaLight',
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 25,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(color: Colors.black26)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
              ),
              // controller: _controller,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          groupIndividualMemberDataList.length > 0
              ? Expanded(
                  child: ListView.builder(
                      controller: _scrollControllerIndividual,
                      itemCount: groupIndividualMemberDataList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var name = groupIndividualMemberDataList[index]
                            .name_en
                            .toString();
                        var userId =
                            groupIndividualMemberDataList[index].id.toString();
                        var user_image =
                            groupIndividualMemberDataList[index].profile_image;

                        return InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                      builder: (_) => ChatScreen(
                                          socket: _socket,
                                          channel_id: userId,
                                          to_user_id: userId,
                                          to_user_name: name,
                                          lastUnseenMsgCount:
                                              groupIndividualMemberDataList[
                                                      index]
                                                  .unseen,
                                          img: groupIndividualMemberDataList[
                                                          index]
                                                      .profile_image ==
                                                  null
                                              ? "https://ui-avatars.com/api/?name=" +
                                                  name.toUpperCase()
                                              : "https://mama-chat.s3.ap-northeast-1.amazonaws.com/" +
                                                  user_image)),
                                )
                                .then((value) => _getUserChatListListen());
                            /*  GetChatChannelCreate(
                            groupMemberDataList[index].name_en.toString(),
                            groupMemberDataList[index].id.toString());*/
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, top: 10, bottom: 10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      groupIndividualMemberDataList[index]
                                                  .profile_image ==
                                              null
                                          ? CircleAvatar(
                                              radius: 22,
                                              backgroundImage: NetworkImage(
                                                  "https://ui-avatars.com/api/?name=" +
                                                      groupIndividualMemberDataList[
                                                              index]
                                                          .name_en
                                                          .toString()
                                                          .toUpperCase()),
                                            )
                                          : CircleAvatar(
                                              radius: 22,
                                              backgroundImage: NetworkImage(
                                                  "https://mama-chat.s3.ap-northeast-1.amazonaws.com/" +
                                                      groupIndividualMemberDataList[
                                                              index]
                                                          .profile_image),
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
                                                groupIndividualMemberDataList[
                                                        index]
                                                    .name_en
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
                                              groupIndividualMemberDataList[
                                                              index]
                                                          .last_message ==
                                                      null
                                                  ? Text(
                                                      "No new message available",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors
                                                              .grey.shade600,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    )
                                                  : groupIndividualMemberDataList[
                                                                  index]
                                                              .last_message
                                                              .toString()
                                                              .contains(
                                                                  '.jpg') ||
                                                          groupIndividualMemberDataList[
                                                                  index]
                                                              .last_message
                                                              .toString()
                                                              .contains('.png')
                                                      ? imagePreviewWidget()
                                                      : Text(
                                                          groupIndividualMemberDataList[
                                                                  index]
                                                              .last_message
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.grey
                                                                  .shade600,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                          maxLines: 1,
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
                                    groupIndividualMemberDataList[index]
                                                .last_message ==
                                            null
                                        ? Container()
                                        : Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: Text(
                                              groupIndividualMemberDataList[
                                                      index]
                                                  .last_message_time
                                                  .toString()
                                                  .substring(11, 16),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                  fontSize: 12),
                                            ),
                                          ),
                                    groupIndividualMemberDataList[index]
                                                .unseen !=
                                            0
                                        ? Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Color.fromRGBO(
                                                  5, 119, 128, 1),
                                            ),
                                            margin: EdgeInsets.only(
                                                right: 10, top: 5),
                                            padding: EdgeInsets.all(6),
                                            child: Text(
                                              groupIndividualMemberDataList[
                                                      index]
                                                  .unseen
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.white,
                                                  fontSize: 9),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }))
              : Text(
                  "No Joined Member(s) found",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
        ],
      ),
    );
  }

  Widget profileTab() {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                            profileDetails == null
                                ? ""
                                : profileDetails!.data!.profileImage.toString(),
                            //file:///image-vJQkle4EGXcCkTqCOqLqwDq1be057OvaP56fNE7w.png
                          ),
                        )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          margin: EdgeInsets.only(left: 15),
                          child: Text(
                            profileDetails == null
                                ? ""
                                : profileDetails!.data!.nameEn.toString(),
                            maxLines: 7,
                            style: TextStyle(
                                fontFamily: 'HelveticaNeueMedium',
                                color: Colors.black,
                                fontSize: 18),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15, top: 7),
                          child: Text(
                            'Member',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black38,
                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    /*  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ProfileEditScreen()),
                    );*/
                    setState(() {
                      onTap = true;
                    });
                    GetProfileDetails();
                  },
                  child: Container(
                    padding: EdgeInsets.all(9),
                    margin: EdgeInsets.only(right: 22),
                    decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(25)),
                    alignment: Alignment.center,
                    width: 35,
                    height: 35,
                    child: Image.asset(
                      'assets/images/pen.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 12),
              child: Divider(
                color: Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text(
                    Translation.of(context)!.translate('personal_detail')!,
                    style: TextStyle(
                        fontFamily: 'HelveticaNeueMedium',
                        color: Colors.black,
                        fontSize: 18),
                  ),
                ),
                InkWell(
                  onTap: () {
                    /* Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ProfileEditScreen()),
                    );*/
                    setState(() {
                      onTap = true;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(9),
                    margin: EdgeInsets.only(right: 22),
                    decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(25)),
                    alignment: Alignment.center,
                    width: 35,
                    height: 35,
                    child: Image.asset(
                      'assets/images/pen.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 15),
              child: Text(
                Translation.of(context)!.translate('date_of_join')! +
                    ' 22.01.2021',
                style: TextStyle(
                    fontFamily: 'HelveticaNeueMedium',
                    color: Colors.black38,
                    fontSize: 16),
              ),
            ),
            SizedBox(
              height: 20,
            ),

            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  width: 25,
                  height: 25,
                  child: Image.asset(
                    'assets/images/birthday.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        Translation.of(context)!.translate('date_of_birth')!,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black38,
                            fontSize: 13),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        profileDetails == null
                            ? ""
                            : profileDetails!.data!.dateOfBirth.toString(),
                        style: TextStyle(
                            fontFamily: "HelveticaNeueMedium",
                            color: Colors.black38,
                            fontSize: 15),
                      ),
                    ),
                  ],
                )
              ],
            ),

            SizedBox(
              height: 20,
            ),

            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  width: 25,
                  height: 25,
                  child: Image.asset(
                    'assets/images/telephone.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        Translation.of(context)!.translate('telephn_no')!,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black38,
                            fontSize: 13),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        profileDetails == null
                            ? ""
                            : profileDetails!.data!.mobile.toString(),
                        style: TextStyle(
                            fontFamily: 'HelveticaNeueMedium',
                            color: Colors.black38,
                            fontSize: 15),
                      ),
                    ),
                  ],
                )
              ],
            ),

            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  width: 25,
                  height: 25,
                  child: Image.asset(
                    'assets/images/email.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        Translation.of(context)!.translate('email')!,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black38,
                            fontSize: 13),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        profileDetails == null
                            ? ""
                            : profileDetails!.data!.email.toString(),
                        style: TextStyle(
                            fontFamily: 'HelveticaNeueMedium',
                            color: Colors.black38,
                            fontSize: 15),
                      ),
                    ),
                  ],
                )
              ],
            ),

            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  width: 25,
                  height: 25,
                  child: Image.asset(
                    'assets/images/location.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        Translation.of(context)!.translate('address')!,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black38,
                            fontSize: 13),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        profileDetails == null
                            ? ""
                            : profileDetails!.data!.address.toString(),
                        maxLines: 6,
                        style: TextStyle(
                            fontFamily: 'HelveticaNeueMedium',
                            color: Colors.black38,
                            fontSize: 15),
                      ),
                    ),
                  ],
                )
              ],
            ),

            SizedBox(
              height: 20,
            ),

            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  width: 25,
                  height: 25,
                  child: Image.asset(
                    'assets/images/group.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        Translation.of(context)!
                            .translate('community_group_type')!,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black38,
                            fontSize: 13),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        profileDetails == null
                            ? ""
                            : profileDetails!.data!.groupType.toString() == "0"
                                ? "Stockvel"
                                : profileDetails!.data!.groupType.toString() ==
                                        "1"
                                    ? "Burial Society"
                                    : "Both",
                        style: TextStyle(
                            fontFamily: 'HelveticaNeueMedium',
                            color: Colors.black38,
                            fontSize: 15),
                      ),
                    ),
                  ],
                )
              ],
            ),

            SizedBox(
              height: 20,
            ),

            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  width: 25,
                  height: 25,
                  child: Image.asset(
                    'assets/images/indivisual.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        Translation.of(context)!.translate('your_role')!,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black38,
                            fontSize: 13),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        profileDetails == null
                            ? ""
                            : profileDetails!.data!.userRole.toString() == "0"
                                ? "Chairman/Secretary"
                                : "Other Member",
                        style: TextStyle(
                            fontFamily: 'HelveticaNeueMedium',
                            color: Colors.black38,
                            fontSize: 15),
                      ),
                    ),
                  ],
                )
              ],
            ),

            SizedBox(
              height: 20,
            ),

            /// paid on and next payment
            /*  Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  width: 25,
                  height: 25,
                  child: Image.asset(
                    'assets/images/wallet.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        Translation.of(context)!.translate('paid_on')!,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black38,
                            fontSize: 13),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        'Pending',
                        style: TextStyle(
                            fontFamily: 'HelveticaNeueMedium',
                            color: Colors.black38,
                            fontSize: 15),
                      ),
                    ),
                  ],
                )
              ],
            ),

            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  width: 25,
                  height: 25,
                  child: Image.asset(
                    'assets/images/calendar.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        Translation.of(context)!.translate('next_payment')!,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black38,
                            fontSize: 13),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        '22.01.2021',
                        style: TextStyle(
                            fontFamily: 'HelveticaNeueMedium',
                            color: Colors.black38,
                            fontSize: 15),
                      ),
                    ),
                  ],
                )
              ],
            ),

            SizedBox(
              height: 20,
            ),*/
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 20),
              alignment: Alignment.topLeft,
              child: Text(
                Translation.of(context)!.translate('selectlanguage')!,
                style: TextStyle(
                  color: const Color(0xff2F2F2F),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: english(),
            ),

            ///send joining req
            /* InkWell(
              child: Container(
                alignment: Alignment.center,


                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/button.png', fit: BoxFit.contain),
                    ),
                    PrefObj.preferences!.get(PrefKeys.LANG).toString() ==
                        'en' ||
                        PrefObj.preferences!
                            .get(PrefKeys.LANG)
                            .toString() ==
                            null ?
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 14,),
                      child:   Text(
                        Translation.of(context)!.translate('send_join_req')!,
                        // textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )
                        :
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 4,),
                      child:   Text(
                        Translation.of(context)!.translate('send_join_req')!,
                        // textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )

                  ],
                ),
              ) ,
              onTap: (){
                */ /* showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      actions: <Widget>[

                        Align(
                          alignment: Alignment.center,
                          child:    Text(
                            Translation.of(context)!.translate('term_to')!
                            ,
                            style: TextStyle(
                              fontSize: 19,
                              fontFamily: 'Comfortaa',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 10,),
                        Align(
                          alignment: Alignment.center,
                          child:    Text(
                            'n publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before final copy is available   n publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before final copy is available'
                            ,
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Comfortaa',
                              fontWeight: FontWeight.normal,
                              color: Colors.black38,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(

                              child: Container(
                                  padding: EdgeInsets.only(left: 10,right: 10,top: 6,bottom: 6),
                                  decoration: BoxDecoration(
                                      color:Colors.red,
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  child:Text(
                                    Translation.of(context)!.translate('cancel')!
                                    ,
                                    style: TextStyle(
                                      fontFamily: 'Comfortaa',
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  )
                              )
                              ,
                              onTap: () {
                                Navigator.pop(context);


                              },
                            ),
                            InkWell(

                              child:  Stack(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: Image.asset('assets/images/button3.png', fit: BoxFit.contain,width: 140,),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 10,left: 18),
                                    child:   Text(
                                      Translation.of(context)!.translate('agree_continue')!,
                                      // textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white, fontSize: 13),
                                    ),
                                  )

                                ],
                              ),
                              onTap: () {
                                Navigator.pop(context);


                              },
                            ),
                          ],
                        )


                      ],
                    );
                  },
                );*/ /*
              },
            ),*/
            SizedBox(
              height: 20,
            ),

            ///chat now
            /*    InkWell(
              child: Container(
                alignment: Alignment.center,


                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/button.png', fit: BoxFit.contain),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 14,),
                      child:   Text(
                        Translation.of(context)!.translate('chat_now')!,
                        // textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )

                  ],
                ),
              ) ,
              onTap: (){
                */ /* showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      actions: <Widget>[

                        Align(
                          alignment: Alignment.center,
                          child:    Text(
                            "Terms to join group"
                            ,
                            style: TextStyle(
                              fontSize: 19,
                              fontFamily: 'Comfortaa',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 10,),
                        Align(
                          alignment: Alignment.center,
                          child:    Text(
                            'n publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before final copy is available   n publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before final copy is available'
                            ,
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Comfortaa',
                              fontWeight: FontWeight.normal,
                              color: Colors.black38,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(

                              child: Container(
                                  padding: EdgeInsets.only(left: 10,right: 10,top: 6,bottom: 6),
                                  decoration: BoxDecoration(
                                      color:Colors.red,
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  child:Text(
                                    "Cancel"
                                    ,
                                    style: TextStyle(
                                      fontFamily: 'Comfortaa',
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  )
                              )
                              ,
                              onTap: () {
                                Navigator.pop(context);


                              },
                            ),
                            InkWell(

                              child:  Stack(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: Image.asset('assets/images/button3.png', fit: BoxFit.contain,width: 140,),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 10,left: 18),
                                    child:   Text(
                                      "Agree & Continue",
                                      // textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white, fontSize: 13),
                                    ),
                                  )

                                ],
                              ),
                              onTap: () {
                                Navigator.pop(context);


                              },
                            ),
                          ],
                        )


                      ],
                    );
                  },
                );*/ /*
              },
            ),*/

            ///remove from group
            /*   Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 20,),
              child:   Text(
                Translation.of(context)!.translate('remove_from')!,
                // textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red, fontSize: 16,decoration: TextDecoration.underline,fontFamily: 'HelveticaNeueMedium'),
              ),
            ),*/

            /*     SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => GenerateScreen()),
                );
              },
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    width: 25,
                    height: 28,
                    child: Image.asset(
                      'assets/images/barcode_scanner.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 19, top: 8, bottom: 8),
                    child: Text(
                      "My QR Code",
                      style: TextStyle(
                          fontFamily: 'HelveticaNeueMedium',
                          color: Colors.black38,
                          fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),*/

            SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => SelectGroupForPaymentScreen(
                          userid: profileDetails == null
                              ? ""
                              : profileDetails!.data!.userId.toString())),
                );
              },
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    width: 30,
                    height: 30,
                    child: Icon(
                      Icons.monetization_on_sharp,
                      color: Colors.grey,
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 15, top: 8, bottom: 8),
                    child: Text(
                      "Payment Status",
                      style: TextStyle(
                          fontFamily: 'HelveticaNeueMedium',
                          color: Colors.black38,
                          fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Divider(
                color: Colors.black,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => AboutUsScreen()),
                );
              },
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    width: 30,
                    height: 30,
                    child: Image.asset(
                      'assets/images/info.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 15, top: 8, bottom: 8),
                    child: Text(
                      Translation.of(context)!.translate('about_us')!,
                      style: TextStyle(
                          fontFamily: 'HelveticaNeueMedium',
                          color: Colors.black38,
                          fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Divider(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            InkWell(
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    width: 30,
                    height: 30,
                    child: Image.asset(
                      'assets/images/customer-support.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 15, top: 8, bottom: 8),
                    child: Text(
                      Translation.of(context)!.translate('support')!,
                      style: TextStyle(
                          fontFamily: 'HelveticaNeueMedium',
                          color: Colors.black38,
                          fontSize: 18),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => SupportScreen()),
                );
              },
            ),

            SizedBox(
              height: 5,
            ),

            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Divider(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () {
                _signOut();
              },
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    width: 30,
                    height: 30,
                    child: Image.asset(
                      'assets/images/switch.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 15, top: 8, bottom: 8),
                    child: Text(
                      Translation.of(context)!.translate('log_out')!,
                      style: TextStyle(
                          fontFamily: 'HelveticaNeueMedium',
                          color: Colors.black38,
                          fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 70,
            ),
            Row(
              children: [
                SizedBox(
                  width: 50,
                ),
                InkWell(
                  onTap: () {
                    PrefObj.preferences!.put(PrefKeys.IS_LOGIN_STATUS, false);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => TermsConditionScreen()),
                    );
                  },
                  child: Text(
                    Translation.of(context)!.translate('terms_condition')!,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black38,
                        fontSize: 14),
                  ),
                ),
                Text(
                  ' | ',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black38,
                      fontSize: 14),
                ),
                InkWell(
                  onTap: () {
                    PrefObj.preferences!.put(PrefKeys.IS_LOGIN_STATUS, false);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => PrivacyPolicyScreen()),
                    );
                  },
                  child: Text(
                    Translation.of(context)!.translate('privacy_policy')!,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black38,
                        fontSize: 14),
                  ),
                ),
                InkWell(
                  onTap: () {
                    PrefObj.preferences!.put(PrefKeys.IS_LOGIN_STATUS, false);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => FaqScreen()),
                    );
                  },
                  child: Text(
                    ' | FAQ',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black38,
                        fontSize: 14),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  dynamic onEditProfile() async {
    global().showLoader(context);
    final http.Response response = await repository.onEditProfileApiApi(
        profileDetails!.data!.userId.toString(),
        name.text,
        email.text,
        address.text,
        birthday.text.toString(),
        selectGenderType == 'Stockvel'
            ? 0
            : selectGenderType == "Burial \nSociety"
                ? 1
                : 2,
        selectGenderType2 == "Chairman/Secretary" ? 0 : 1,
        imageBase64!);
    Map<String, dynamic> map = json.decode(response.body);
    global().hideLoader(context);
    if (response.statusCode == 200) {
      onTap = false;
      setState(() {
        GetProfileDetails();
      });
    } else {}
  }

  _groupSearch() {
    if (prev != groupSearchController.text) {
      prev = groupSearchController.text;
      _socket.emit('get_chat_group_list', {
        json.encode(
            {'user_id': from_user_id, 'keyword': prev.toString().trim()})
      });

      //     GetGroupDataSearch(prev.toString().trim());
    }
  }

  _avlGroupSearch() {
    if (prev != _avlGroupSearchController.text) {
      prev = _avlGroupSearchController.text;
      _socket.emit('get_avl_group_list', {
        json.encode(
            {'user_id': from_user_id, 'keyword': prev.toString().trim()})
      });

      //     GetGroupDataSearch(prev.toString().trim());
    }
  }

  _indiVidualSearch() {
    if (prev != _searchPersonTextController.text) {
      prev = _searchPersonTextController.text;
      _socket.emit('get_chat_user_list', {
        json.encode(
            {'user_id': from_user_id, 'keyword': prev.toString().trim()})
      });

      //     GetGroupDataSearch(prev.toString().trim());
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

  Future<bool> _handleWillPop(BuildContext context) async {
    final _currentTime = DateTime.now().millisecondsSinceEpoch;

    if (_lastTimeBackButtonWasTapped != null &&
        (_currentTime - _lastTimeBackButtonWasTapped!) < exitTimeInMillis) {
      return true;
    } else {
      _lastTimeBackButtonWasTapped = DateTime.now().millisecondsSinceEpoch;
      _getExitSnackBar(context);

      return false;
    }
  }

  SnackBar _getExitSnackBar(BuildContext context) {
    return SnackBar(
      content: Text(
        'Press BACK again to exit!',
        style: TextStyle(
            fontWeight: FontWeight.normal, color: Colors.white, fontSize: 14),
      ),
      backgroundColor: Colors.red,
      duration: const Duration(
        seconds: 2,
      ),
      behavior: SnackBarBehavior.floating,
    );
  }

  _tabSwapUsingBackButton(BuildContext context, int selectIndex) {
    if (selectIndex == 0) {
      _handleWillPop(context);
    } else if (selectIndex == 1) {
      _tabController.index = 0;
    } else if (selectIndex == 2) {
      _tabController.index = 0;
    } else if (selectIndex == 3) {
      _tabController.index = 0;
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    PrefObj.preferences!.put(PrefKeys.AUTH_TOKEN, '');
    PrefObj.preferences!.put(PrefKeys.IS_LOGIN_STATUS, false);
    PrefObj.preferences!.put(PrefKeys.USER_ID, '');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => SignUpScreen()),
    );
  }

  Widget imagePreviewWidget() {
    return Row(
      children: [
        Icon(
          Icons.photo,
          color: Colors.grey,
        ),
        Text(
          ' Photo',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.normal,
          ),
          maxLines: 1,
        ),
      ],
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

class IndividualUser {
  dynamic id;
  dynamic name_en;
  dynamic name_fr;
  dynamic profile_image;
  dynamic image;
  dynamic unseen;
  dynamic last_message;
  dynamic last_message_time;

  IndividualUser(
      {this.id,
      this.name_en,
      this.name_fr,
      this.profile_image,
      this.image,
      this.unseen,
      this.last_message,
      this.last_message_time});

  IndividualUser.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name_en = json['name_en'];
    name_fr = json['name_fr'];
    profile_image = json['profile_image'];
    image = json['image'];
    unseen = json['unseen'];
    last_message = json['last_message'];
    last_message_time = json['last_message_time'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name_en': this.name_en,
      'name_fr': this.name_fr,
      'profile_image': this.profile_image,
      'image': this.image,
      'unseen': this.unseen,
      'last_message': this.last_message,
      'last_message_time': this.last_message_time,
    };
  }

  Map<dynamic, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_en'] = this.name_en;
    data['name_fr'] = this.name_fr;
    data['profile_image'] = this.profile_image;
    data['image'] = this.image;
    data['unseen'] = this.unseen;
    data['last_message'] = this.last_message;
    data['last_message_time'] = this.last_message_time;
    return data;
  }
}
