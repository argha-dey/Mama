import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:mama/screens/splash/splash_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';
//import 'package:timezone/timezone.dart' as tz;
//import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'global/PrefKeys.dart';
import 'localizations/app_localizations.dart';
import 'localizations/language_model.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:firebase_core/firebase_core.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp().whenComplete(() =>print("handler_initialized"));
 // await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().whenComplete(()=>print("initialized"));
//  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(fcm_channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  final Directory appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  await Hive.openBox('mama').then(
        (value) => runApp(ScopedModel<LangModel>(
      model: LangModel(),
      child: MyApp(prefs: value),
    )),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key, this.prefs}) : super(key: key);
  Box? prefs;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    var initialzationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
    InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();



    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                fcm_channel.id,
                fcm_channel.name,
                channelDescription: 'famous team channelDescription',
                color: Colors.blue,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: "@mipmap/ic_launcher",
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });


    //getTimeZone();
    getToken();

  }

  getNativeTimeZone() async {
    String _timezone = 'Asia/Kolkata';
    try {
      _timezone = await FlutterNativeTimezone.getLocalTimezone();
    } catch (e) {
      print('Could not get the local timezone');
    }

    print('@localTimeZone : '+_timezone);
    PrefObj.preferences!.put(PrefKeys.MAMA_APP_TIME_ZONE, _timezone);
    // print('@localTimeZone : '+localTimeZone.toString());// => "US/Pacific"
  }

  String? token;
  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    PrefObj.preferences!.put(PrefKeys.MAMA_APP_DEVICE_TOKEN, token);
    print('@token : '+token.toString());
    getNativeTimeZone();
  }

  @override
  Widget build(BuildContext context) {
    PrefObj.preferences = widget.prefs;

    return ScopedModelDescendant<LangModel>(
      builder: (context, child, model) =>
          ScreenUtilInit(builder: (context, child) {
            return MaterialApp(
              title: 'Koleka',
              locale: model.appLocal,
              supportedLocales: model.supportedLocales,
              localizationsDelegates: const [
                Translation.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                FallbackCupertinoLocalisationsDelegate(),
              ],
              builder: (context, child) {
                final mediaQueryData = MediaQuery.of(context);

                return MediaQuery(
                  data: mediaQueryData.copyWith(textScaleFactor: 1.0),
                  child: child!,
                );
              },
              debugShowCheckedModeBanner: false,
              home: SplashScreen(),
            );
          }),
    );
  }
}

const AndroidNotificationChannel fcm_channel = AndroidNotificationChannel(
  'mama_user_channel_id',
  'mama_user_channel_name',
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}