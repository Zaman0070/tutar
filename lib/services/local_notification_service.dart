// import 'dart:math';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
// import 'package:rxdart/rxdart.dart';
// // ignore: depend_on_referenced_packages
// import 'package:timezone/data/latest.dart' as tz;
// // ignore: depend_on_referenced_packages
// import 'package:timezone/timezone.dart' as tz;
//
// class LocalNotificationService {
//
//   static final FlutterLocalNotificationsPlugin
//   _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   static final onNotifications = BehaviorSubject();
//
//   static void initialize({bool isSchedule = false}) async {
//     const InitializationSettings initializationSettings =
//     InitializationSettings(
//         android: AndroidInitializationSettings('@drawable/ic_notification'),
//         iOS: DarwinInitializationSettings(
//           requestSoundPermission: false,
//           requestBadgePermission: false,
//           requestAlertPermission: false,
//           defaultPresentAlert: true,
//           defaultPresentSound: true,
//
//           notificationCategories: [
//             DarwinNotificationCategory(
//               'category',
//               options: {
//                 DarwinNotificationCategoryOption.allowAnnouncement,
//               },
//             ),
//           ],
//         ),
//
//     );
//
//     await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//
//
//     final details = await _flutterLocalNotificationsPlugin
//         .getNotificationAppLaunchDetails();
//
//     if (details != null && details.didNotificationLaunchApp) {
//       onNotifications.add(details.notificationResponse);
//     }
//
//     await _flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (payload) {
//         onNotifications.add(payload);
//       },
//     );
//
//
//
//
//     if (isSchedule) {
//       tz.initializeTimeZones();
//       final locationName = await FlutterNativeTimezone.getLocalTimezone();
//       tz.setLocalLocation(tz.getLocation(locationName));
//     }
//   }
//
//   static NotificationDetails notificationDetails = const NotificationDetails(
//     android: AndroidNotificationDetails(
//       'FLUTTER_NOTIFICATION_CLICK',
//       'FLUTTER_NOTIFICATION_CLICK_CHANNEL',
//       importance: Importance.max,
//       priority: Priority.high,
//       showProgress: true,
//       playSound: true,
//       enableVibration: true,
//       icon: '@drawable/ic_notification',
//       largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
//     ),
//     iOS: DarwinNotificationDetails(
//      presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     ),
//   );
//
//
//
//
//   static void display(RemoteMessage message) async {
//
//     try {
//       Random random = Random();
//       int id = random.nextInt(1000);
//
//       /*RemoteNotification? remoteNotification = message.notification;
//       AndroidNotification? androidNotification = message.notification?.android;*/
//       //
//       await _flutterLocalNotificationsPlugin.show(
//         id,
//         message.notification!.title,
//         message.notification!.body,
//         notificationDetails,
//         payload: message.data['route'] as String,
//       );
//     } on Exception catch (e) {
//       debugPrint(e.toString());
//     }
//   }
//   Future<NotificationDetails> details()async{
//     const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
//       'channel',
//       'myChannel',
//       importance: Importance.max,
//       priority: Priority.high,
//       showProgress: true,
//       playSound: true,
//       enableVibration: true,
//       icon: '@drawable/ic_notification',
//       largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
//     );
//
//     return const NotificationDetails(android: androidNotificationDetails,iOS:  DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     ),);
//   }
//   Future<void> showNotification({
//   required int id,
//     required String title,
//     required body,
// }) async{
//     final det = await details();
//     await _flutterLocalNotificationsPlugin.show(id, title, body, det);
//   }
//
//
//
//   static void onSelect(NotificationResponse details) {
//   }
// }


