import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessagingConfig {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  configFirebaseMessaging() async {
    final notificationSettings = await FirebaseMessaging.instance
        .requestPermission(provisional: true);
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      log('User granted permission');

      /********/
      // Initialize the plugin
      /********/

      // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      final DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings();
      final WindowsInitializationSettings initializationSettingsWindows =
          WindowsInitializationSettings(
            appName: 'Flutter Local Notifications Example',
            appUserModelId: 'Com.Dexterous.FlutterLocalNotificationsExample',
            // Search online for GUID generators to make your own
            guid: 'd49b0314-ee7a-4626-bf79-97cdb8a991bb',
          );
      final InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            macOS: initializationSettingsDarwin,
            windows: initializationSettingsWindows,
          );
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (onSelectionNotifications) {
          final String? payload = onSelectionNotifications.payload;
          if (onSelectionNotifications.payload != null) {
            log('notification payload: $payload');
          }
        },
      );

      /*****
      get FCM Token
      ******/
      FirebaseMessaging.instance.getToken().then((token) {
        log('Token: $token');
      });

      FirebaseMessaging.onMessage.listen((message) {
        final notification = message.notification;
        log('Message: $message');
        log(notification?.body ?? "no body");
        log(notification?.title ?? "no title");
        showNotification(
          notification!.title,
          notification.body,
        );
      });
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        log('Message opened app: $message');
        log(message.notification?.body ?? "no body");
        log(message.notification?.title ?? "no title");
      });
    } else {
      log('User declined or has not accepted permission');
    }
  }

  /********/
  // show notifications
  /********/

  showNotification(title, body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: 'Here is a payload',
    );
  }
}
