import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../app_credentials/app_credential.dart';




sendFCMNotification({String? title, String? body, String? token}) async{

  final data = {
    'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    'id': '1',
    'status': 'done',
    'message': title,
    'route': 'home'
  };

  try {
    http.Response response = await http.post(
      Uri.parse(AppCredential.fcmNotificationUrl),
      headers: <String, String>{
        'Content-Type': AppCredential.headerContentType,
        'Authorization': AppCredential.fcmAuthorizationKey,
      },
      body: jsonEncode(<String, dynamic>{
        'notification': <String, dynamic>{
          'title': title,
          'body': body,
        },
        'priority': 'high',
        'data': data,
        'to': token,
      }),
    );

    if (response.statusCode == 200) {
      debugPrint('FCM Notification Send');
    }
  } catch (e) {
    debugPrint('Notification Error: $e');
  }

}