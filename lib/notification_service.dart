import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  NotificationService._();

  static final instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance;

  Future<void> intialize(BuildContext context) async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      return;
    }

    final token = await _messaging.getToken();
    print('FCM TOKEN: $token');

    //foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('FOREGROUND MESSAGE');
      _showSnackBar(context, message);
    });

    /// background, terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      /// Логика обработки уведомления
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      print('OPENED INITIAL MESSAGE');
    }
  }

  void _showSnackBar(BuildContext context, RemoteMessage message) {
    final notification = message.notification;

    if (notification == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.title ?? ''),
            if (notification.body != null) Text(notification.body!),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 4),
      ),
    );
  }
}
