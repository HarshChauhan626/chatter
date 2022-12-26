import 'package:chat_app/features/splash/splash_screen.dart';
import 'package:chat_app/helper/hive_db_helper.dart';
import 'package:chat_app/helper/notification_helper.dart';
import 'package:chat_app/utils/app_theme.dart';
import 'package:chat_app/utils/custom_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sizer/sizer.dart';

import 'helper/firebase_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseHelper.initInstances();
  // await FirebaseMessaging.instance.subscribeToTopic("all");
  NotificationHelper.loadFCM();
  Get.put(HiveDBHelper());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          // onGenerateRoute: CustomRouter.onGenerateRoute,
          getPages: GetXRouter.getXPages(),
          initialRoute: SplashScreen.routeName,
          // initialBinding: AuthBinding(),
        );
      },
    );
  }
}
