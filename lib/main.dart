import 'package:chat_app/bindings/auth_binding.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/onboarding_screen.dart';
import 'package:chat_app/screens/reset_password.dart';
import 'package:chat_app/screens/sign_in_screen.dart';
import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:chat_app/utils/app_theme.dart';
import 'package:chat_app/utils/custom_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sizer/sizer.dart';

import 'controllers/auth_controller.dart';
import 'globals.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseAuth auth = FirebaseAuth.instance;
  Globals.auth=FirebaseAuth.instance;
  Globals.firestore=FirebaseFirestore.instance;
  Globals.googleSign=GoogleSignIn();
  // FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  // GoogleSignIn googleSign = GoogleSignIn();
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
          initialRoute: OnboardingScreen.routeName,
          initialBinding: AuthBinding(),
        );
      },
    );
  }
}
