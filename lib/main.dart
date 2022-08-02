import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/onboarding_screen.dart';
import 'package:chat_app/screens/reset_password.dart';
import 'package:chat_app/screens/sign_in_screen.dart';
import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:chat_app/utils/app_theme.dart';
import 'package:chat_app/utils/custom_router.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation, DeviceType deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme:AppTheme.light,
          onGenerateRoute: CustomRouter.onGenerateRoute,
          initialRoute: OnboardingScreen.routeName,
        );
      },
    );
  }
}

