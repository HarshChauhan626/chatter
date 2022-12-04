import 'package:chat_app/controllers/auth_controller.dart';
import 'package:chat_app/helper/hive_db_helper.dart';
import 'package:chat_app/features/home/home_screen.dart';
import 'package:chat_app/features/onboarding/onboarding_screen.dart';
import 'package:chat_app/features/sign_in/sign_in_screen.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/widgets/custom_safe_area.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
  AuthController authController = Get.put(AuthController(), permanent: true);

  void startTimer() async {
    await Future.delayed(const Duration(seconds: 6), () async {});
    if(Get.find<HiveDBHelper>().onboardingDone){
      if (authController.firebaseUser.value != null) {
        Get.offAllNamed(HomeScreen.routeName);
      } else {
        Get.offAllNamed(SignInScreen.routeName);
      }
    }
    else{
      Get.offAllNamed(OnboardingScreen.routeName);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
    registerDeviceToken();
  }


  void registerDeviceToken()async{
    await FirebaseMessaging.instance.getToken().then((token) {
      if(token!=null){
        authController.saveUserDeviceToken(token);
      }
    });
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
