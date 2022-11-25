import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tutor_app/Provider/user_provider.dart';
import 'package:tutor_app/screens/splash_screen/splash_screen.dart';
import 'package:tutor_app/services/local_notification_service.dart';



const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'FLUTTER_NOTIFICATION_CLICK', // id
    'FLUTTER_NOTIFICATION_CLICK_CHANNEL', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);





final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//  RemoteNotification? notification = message.notification;
 // AndroidNotification? android = message.notification?.android;
  await Firebase.initializeApp();
  // var initialzationSettingsAndroid =
  // const AndroidInitializationSettings('@mipmap/ic_launcher');
  // var initializationSettings =
  // InitializationSettings(android: initialzationSettingsAndroid);
  // AndroidNotification? android = message.notification?.android;
  //
  // flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // flutterLocalNotificationsPlugin.show(message.data.hashCode,
  //     message.data['title'],
  //     message.data['body'],
  //     NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         channel.id,
  //         channel.name,
  //         //  channel.description,
  //         icon: android!.smallIcon,
  //       ),
  //     )
  // );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
  ?.createNotificationChannel(channel);

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
                channel.id,
                channel.name,
              //  channel.description,
                icon: android.smallIcon,
              ),
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                //  channel.description,
                icon: android.smallIcon,
              ),
            ));
      }
    });
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message)async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
      await  flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                //  channel.description,
                icon: android.smallIcon,
              ),
            ));
      }
    });
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
                  title: 'Flutter Demo',
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
