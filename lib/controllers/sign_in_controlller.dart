import 'package:chat_app/helper/firebase_helper.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_strings.dart';
import '../utils/asset_strings.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/custom_alert_body.dart';
import 'auth_controller.dart';

class SignInController extends GetxController {
  RxString user = "".obs;
  RxString password = "".obs;
  RxBool isLoading = false.obs;

  void signInUser(BuildContext context) async {
    try {
      AuthController authController = Get.find<AuthController>();
      isLoading.value = true;
      bool canLogin = await authController.login(user.value, password.value);
      isLoading.value = false;
      if (canLogin) {
        FirebaseHelper.user = FirebaseHelper.authInstance?.currentUser;
        Get.to(const HomeScreen());
      } else {
        showCustomDialog(
            context,
            CustomAlertBody.alertWithOneButtonAlert(context,
                imageLoc: AssetStrings.errorLottie,
                title: AppStrings.oopsTitle,
                bodyText: AppStrings.somethingWentWrong,
                actionButtonText: AppStrings.gotIt));
      }
    } catch (e) {
      isLoading.value = false;
      showCustomDialog(
          context,
          CustomAlertBody.alertWithOneButtonAlert(context,
              imageLoc: AssetStrings.errorLottie,
              title: AppStrings.oopsTitle,
              bodyText: AppStrings.somethingWentWrong,
              actionButtonText: AppStrings.gotIt));
    }
  }
}
