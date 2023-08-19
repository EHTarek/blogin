import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:blogin/bloc/notification/notification_bloc.dart';
import 'package:blogin/navigation/routes.dart';
import 'package:blogin/services/db/notification_db_helper.dart';
import 'package:blogin/services/logs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final db = FirebaseFirestore.instance;
  late final BuildContext context;

  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //initialising local notification plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> requestNotificationPermission() async {
    Log('================ requestNotificationPermission ===============');
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
      Log('Notification Permission Authorized');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      Log('Notification Permission Provisional');
    } else {
      Log('Notification Permission Denied');
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
  }

  void firebaseInit(BuildContext context) {
    this.context = context;
    Log('================ firebaseInit ===============');
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      Log('Notification title: ${notification!.title}');
      Log('Notification body: ${notification.body}');
      Log('Count: ${android!.count}');
      Log('Data: ${message.data.toString()}');

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
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
    Log('================ initLocalNotifications ===============');
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        handleMessage(context, message);
      },
      /*onDidReceiveBackgroundNotificationResponse: (payload) {
        handleMessage(context, message);
      },*/
    );
  }

  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message) async {
    NotificationDbHelper().dbInsert(message: message);
    BlocProvider.of<NotificationBloc>(context).add(NotificationUpdateEvent());
    Log('================ showNotification ===============');
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
    Log('================ handleMessage ===============');
    if (message.data['type'] == 'shopping') {
      Navigator.pushNamed(context, Routes.kShopping);
    }
  }

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage(BuildContext context) async {
    Log('================ setupInteractMessage ===============');
    // When app is terminated
    // RemoteMessage? initialMessage =
    // await FirebaseMessaging.instance.getInitialMessage();
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
  }

  Future<void> foregroundMessage() async {
    Log('================ foregroundMessage ===============');
    // await FirebaseMessaging.instance
    await messaging.setForegroundNotificationPresentationOptions(
      sound: true,
      badge: true,
      alert: true,
    );
  }

  //function to get device token on which we will send the notifications
  Future<String> getDeviceToken() async {
    Log('================ getDeviceToken ===============');
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefreshed() {
    Log('================ isTokenRefreshed ===============');
    messaging.onTokenRefresh.listen((event) {
      Log('Refreshed token: $event');
/*      db
          .collection('device_token')
          .doc('token')
          .set({'key': event.toString()}).onError(
              (error, _) => Log(error.toString()));*/
    });
  }
}
