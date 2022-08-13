import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/onboarding_screen.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/widgets/custom_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const SplashScreen(),
    );
  }

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void startTimer() {
    Future.delayed(const Duration(seconds: 2), () async {
      await Navigator.pushNamedAndRemoveUntil(context, OnboardingScreen.routeName,(route)=>false);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: 38.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(Icons.messenger_outline_outlined,color: Colors.black,size: 3.h,),
                // SizedBox(
                //   width: 1.h,
                // ),
                Text(
                  "XChat",
                  style: Theme.of(context).textTheme.headline2?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryColor),
                )
              ],
            ),
            SizedBox(
              height: 38.h,
            ),
            SizedBox(
              height: 4.h,
              width: 4.h,
              child: const CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}
