import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:blogin/navigation/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final db = FirebaseFirestore.instance;

  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //initialising local notification plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> requestNotificationPermission() async {
    print('================ requestNotificationPermission ===============');
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Notification Permission Authorized');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('Notification Permission Provisional');
    } else {
      print('Notification Permission Denied');
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
  }

  void firebaseInit(BuildContext context) {
    print('================ firebaseInit ===============');
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      print('Notification title: ${notification!.title}');
      print('Notification body: ${notification.body}');
      print('Count: ${android!.count}');
      print('Data: ${message.data.toString()}');

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        // showNotification(message);
      }
      if (Platform.isIOS) {
        foregroundMessage();
      }
    });
  }

//function to initialise flutter local notification plugin to show notifications for android when app is active
  void initLocalNotifications(
    BuildContext context,
    RemoteMessage message,
  ) async {
    print('================ initLocalNotifications ===============');
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      /*onDidReceiveNotificationResponse: (payload) {
        handleMessage(context, message);
      },*/
      /*onDidReceiveBackgroundNotificationResponse: (payload) {
        handleMessage(context, message);
      },*/
    );
  }

  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message) async {
    print('================ showNotification ===============');
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
      showBadge: true,
      // sound: const RawResourceAndroidNotificationSound('jetsons_doorbell'),
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'Channel Description',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
      // sound: channel.sound,
    );

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    print('================ handleMessage ===============');
    if (message.data['type'] == 'shopping') {
      Navigator.pushNamed(context, Routes.kShopping);
    }
  }

  //handle tap on notification when app is in background or terminated
 /* Future<void> setupInteractMessage(BuildContext context) async {
    print('================ setupInteractMessage ===============');
    // When app is terminated
    // RemoteMessage? initialMessage =
    //     await FirebaseMessaging.instance.getInitialMessage();
    RemoteMessage? initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      // showNotification(initialMessage);
      handleMessage(context, initialMessage);
    }

    // When app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // showNotification(message);
      handleMessage(context, message);
    });
  }*/

  Future<void> foregroundMessage() async {
    print('================ foregroundMessage ===============');
    // await FirebaseMessaging.instance
    await messaging.setForegroundNotificationPresentationOptions(
      sound: true,
      badge: true,
      alert: true,
    );
  }

  //function to get device token on which we will send the notifications
  Future<String> getDeviceToken() async {
    print('================ getDeviceToken ===============');
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefreshed() {
    print('================ isTokenRefreshed ===============');
    messaging.onTokenRefresh.listen((event) {
      print('Refreshed token: $event');
      db
          .collection('device_token')
          .doc('token')
          .set({'key': event.toString()}).onError(
              (error, _) => print(error.toString()));
    });
  }
}
