import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification.dart';

class LocalNotificationUtils {
  static final LocalNotificationUtils _instance =
      LocalNotificationUtils._internal();
  factory LocalNotificationUtils() => _instance;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool _isInitialized = false;

  LocalNotificationUtils._internal();

  Future<void> init() async {
    if (_isInitialized) return;

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        debugPrint("🔥 Local Notification Click");
        dev.log('Notification tapped', name: 'LocalNotificationUtils');
        final payload = details.payload;
        if (payload != null) {
          try {
            final data = jsonDecode(payload);
            dev.log('Decoded payload: $data', name: 'LocalNotificationUtils');
            await NotificationUtils.notificationHandler(data: data);
          } catch (e) {
            dev.log('Error handling local notification payload: $e',
                name: 'LocalNotificationUtils');
          }
        }
      },
    );

    // Handle initial local notification if app was launched from it
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      final payload =
          notificationAppLaunchDetails?.notificationResponse?.payload;
      if (payload != null) {
        try {
          final data = jsonDecode(payload);
          dev.log('App launched from local notification: $data',
              name: 'LocalNotificationUtils');
          NotificationUtils.setPendingNotificationData(data);
        } catch (e) {
          dev.log('Error decoding initial local notification: $e',
              name: 'LocalNotificationUtils');
        }
      }
    }

    _isInitialized = true;
  }

  Future<void> showNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    await init();
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    try {
      await flutterLocalNotificationsPlugin.show(
        id: Random.secure().nextInt(999),
        title: title,
        body: body,
        notificationDetails: platformChannelSpecifics,
        payload: payload,
      );
    } catch (e) {
      dev.log('Error showing local notification: $e',
          name: 'LocalNotificationUtils');
    }
  }
}
