import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tutor_app/Provider/user_provider.dart';
import 'package:tutor_app/screens/splash_screen/splash_screen.dart';



final GlobalKey<NavigatorState> navigatorKey = GlobalKey(
    debugLabel: "Main Navigator");

Future<void> selectNotification(String? payload) async {
  if (payload != null) {
    debugPrint('notification payload: $payload');
    navigatorKey.currentState?.pushNamed('/second');
  }
}


const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'FLUTTER_NOTIFICATION_CLICK', // id
    'FLUTTER_NOTIFICATION_CLICK_CHANNEL', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);




FirebaseMessaging messaging = FirebaseMessaging.instance;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  await Firebase.initializeApp();
  if (notification != null && android != null) {
    // print('Message also contained a notification: ${message.notification}');
    flutterLocalNotificationsPlugin.show(
        message.data.hashCode,
        message.data['title'],
        message.data['body'],
         NotificationDetails(
          android: AndroidNotificationDetails(
            'FLUTTER_NOTIFICATION_CLICK', //channel.id,
            'FLUTTER_NOTIFICATION_CLICK_CHANNEL', //channel.name,
            icon: android.smallIcon,
           showProgress: true,
           visibility: NotificationVisibility.public,
           importance: Importance.max,
           // color: primaryColor,
            // other properties...
          ),
           iOS: const DarwinNotificationDetails(
             presentBadge: true,
             presentAlert: true,
             presentSound: true,
           )
        ),
        payload: json.encode(message.data)

    );
 }
}
String? payload;



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
  ?.createNotificationChannel(channel);
  SystemChrome.setSystemUIOverlayStyle( const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent
  ));
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // initialize notification for android
  var initialzationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings =
  InitializationSettings(android: initialzationSettingsAndroid);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print(message.notification!.body != null);
    if (message.notification!.body != null) {
      navigatorKey.currentState?.pushNamed('/second');
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {




  String? token;
  List subscribed = [];
  List topics = [
    'Samsung',
    'Apple',
    'Huawei',
    'Nokia',
    'Sony',
    'HTC',
    'Lenovo'
  ];
  @override
  void initState() {
    super.initState();
    var initialzationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
    InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //         NotificationDetails(
    //           android: AndroidNotificationDetails(
    //             channel.id,
    //             channel.name,
    //           //  channel.description,
    //             icon: android.smallIcon,
    //           ),
    //             iOS: const DarwinNotificationDetails(
    //               presentSound: true,
    //               presentAlert: true,
    //               presentBadge: true,
    //
    //             )
    //         ));
    //   }
    // });

    getToken();
    getTopics();
  }
  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    setState(() {
      token = token;
    });
    print(token);
  }

  getTopics() async {
    await FirebaseFirestore.instance
        .collection('topics')
        .get()
        .then((value) => value.docs.forEach((element) {
      if (token == element.id) {
        subscribed = element.data().keys.toList();
      }
    }));

    setState(() {
      subscribed = subscribed;
    });
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
      ],
      child: ConnectivityAppWrapper(
        app: Sizer(
            builder: (BuildContext context, Orientation orientation,
                    DeviceType deviceType) =>
                MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Talking2Allah LMS',
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                  ),
                  home: const ConnectivityWidgetWrapper(child: SplashScreen()),
                  builder: InAppNotifications.init(),
                )),
      ),
    );
  }
}
