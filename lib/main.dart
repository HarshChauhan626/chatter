import 'package:chat_app/bindings/auth_binding.dart';
import 'package:chat_app/helper/hive_db_helper.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:chat_app/utils/app_theme.dart';
import 'package:chat_app/utils/custom_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sizer/sizer.dart';
import 'helper/firebase_helper.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseHelper.initInstances();
  HiveDBHelper().initData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          onGenerateRoute: CustomRouter.onGenerateRoute,
          initialRoute: SplashScreen.routeName,
          // initialBinding: AuthBinding(),
        );
      },
    );
  }
}
