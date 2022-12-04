// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationHelper{
//   static void setUpNotifications(){
//     var initializationSettingsAndroid =
//     new AndroidInitializationSettings('ic_launcher');
//     var initialzationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//     var initializationSettings =
//     InitializationSettings(android: initialzationSettingsAndroid);
//     flutterLocalNotificationsPlugin.initialize(initializationSettings);
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("Message coming");
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       if (notification != null && android != null) {
//         flutterLocalNotificationsPlugin.show(
//             notification.hashCode,
//             notification.title,
//             notification.body,
//             NotificationDetails(
//               android: AndroidNotificationDetails(
//                 channel.id,
//                 channel.name,
//                 channelDescription:channel.description,
//                 color: Colors.blue,
//                 // TODO add a proper drawable resource to android, for now using
//                 //      one that already exists in example app.
//                 icon: "@mipmap/ic_launcher",
//               ),
//             ));
//       }
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("Message opened app");
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       if (notification != null && android != null) {
//         showDialog(
//           // context: context,
//             builder: (_) {
//               return AlertDialog(
//                 title: Text(notification.title??""),
//                 content: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [Text(notification.body??"")],
//                   ),
//                 ),
//               );
//             }, context: context);
//       }
//     });
//   }
// }