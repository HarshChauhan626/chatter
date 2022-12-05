import 'dart:convert';

import 'package:chat_app/features/chat/chat_screen.dart';
import 'package:chat_app/models/notification_data_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';

class NotificationHelper {
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static NotificationDataModel? notificationDataModel;

  static void setUpNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message coming");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                icon: "@mipmap/ic_launcher",
              ),
            ));
        notificationDataModel=NotificationDataModel.fromJson(message.data);
        Get.toNamed(ChatScreen.routeName, arguments: {
          "roomId": notificationDataModel?.roomId,
          "receiverModel": notificationDataModel?.receiverModel
        });
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Message opened app");
      RemoteNotification? notification = message.notification;
      // AndroidNotification? android = message.notification?.android;
      if (notification != null) {
        // showDialog(
        //     // context: context,
        //     builder: (_) {
        //       return AlertDialog(
        //         title: Text(notification.title ?? ""),
        //         content: SingleChildScrollView(
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [Text(notification.body ?? "")],
        //           ),
        //         ),
        //       );
        //     },
        //     context: context);
        notificationDataModel=NotificationDataModel.fromJson(message.data);
      }
    });
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
    print('Handling a background message ${message.messageId}');
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
      "default_notification_channel_id",
      "channel",
      enableLights: true,
      enableVibration: true,
      priority: Priority.high,
      importance: Importance.max,
      largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
      styleInformation: MediaStyleInformation(
        htmlFormatContent: true,
        htmlFormatTitle: true,
      ),
      playSound: true,
    );

    await flutterLocalNotificationsPlugin.show(
        message.data.hashCode,
        message.data['title'],
        message.data['body'],
        NotificationDetails(
          android: androidDetails,
        ));


  }

  static void setUpNotificationInMain() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    var initializationSettingsAndroid =
    new AndroidInitializationSettings('ic_launcher');
    var initialzationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
    InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,onDidReceiveNotificationResponse:(NotificationResponse notificationResponse){
      Get.toNamed(ChatScreen.routeName, arguments: {
        "roomId": notificationDataModel?.roomId,
        "receiverModel": notificationDataModel?.receiverModel
      });
    } );

  }

  static Future<void> sendNotification(
      UserModel receiverModel, String roomId, String message) async {
    try {
      final response =
          await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
              headers: <String, String>{
                "Authorization": "Key=${Constants.firebaseMessagingServerKey}",
                "Content-Type": "application/json",
              },
              body: getRequestBody(receiverModel, roomId, message)
          );
      print(getRequestBody(receiverModel, roomId, message));
      print(response.body.toString());
    } catch (e) {
      print(e);
    }
  }
  
  static String getRequestBody(UserModel receiverModel, String roomId, String message ){
    return jsonEncode({
      "registration_ids": [receiverModel.deviceToken],
      "notification": {
        "body": message,
        "title": receiverModel.userName ?? "",
        "sound": "ggnotisound.mp3"
      },
      "data": {
        "roomId": roomId,
        "receiverModel": receiverModel.toJson()
      }
    });
  }
  
  
}
