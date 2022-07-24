import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
  NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {

    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // ios initialization
    const IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);
    // the initialization settings are initialized after they are setted
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(int id, String title, String body) async {

    print(tz.TZDateTime.now(tz.local));
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      // tz.TZDateTime.now(tz.local).add(const Duration(
      //     seconds: 5)), //schedule the notification to show after 2 seconds.
      tz.TZDateTime.local(2022,7,24,14,20,0,0,0), //schedule the notification to show after 2 seconds.
      const NotificationDetails(

        // Android details
        android: AndroidNotificationDetails('main_channel', 'Main Channel',
            channelDescription: "scribbles",
            importance: Importance.max,
            priority: Priority.max),
        // iOS details
        iOS: IOSNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),

      // Type of time interpretation
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle:
      true, // To show notification even when the app is closed
    );
  }
}
