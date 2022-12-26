import 'package:chat_app/helper/firebase_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../utils/app_strings.dart';
import '../utils/asset_strings.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/custom_alert_body.dart';
import 'auth_controller.dart';

class SignUpController extends GetxController {
  RxString email = "".obs;
  RxString password = "".obs;
  RxString userName = "".obs;
  RxString firstName = "".obs;
  RxString lastName = "".obs;

  RxBool isLoading = false.obs;
  RxBool isSuccessful = false.obs;

  void registerUser(BuildContext context) async {
    AuthController authController = Get.find<AuthController>();

    try {
      isLoading.value = true;
      final userCredential =
          await authController.register(email.value, password.value);
      if (userCredential.user != null) {
        await saveToUserCollection(userCredential);
        showCustomDialog(
            context,
            CustomAlertBody.alertWithOneButtonAlert(context,
                imageLoc: AssetStrings.success,
                title: AppStrings.success,
                bodyText: AppStrings.passwordSuccessfullyChanged,
                actionButtonText: AppStrings.gotIt));
        isLoading.value = false;
      } else {
        isLoading.value = false;
        showCustomDialog(
            context,
            CustomAlertBody.alertWithOneButtonAlert(context,
                imageLoc: AssetStrings.errorLottie,
                title: AppStrings.oopsTitle,
                bodyText: AppStrings.somethingWentWrong,
                actionButtonText: AppStrings.gotIt));
      }
    } catch (e) {
      showCustomDialog(
          context,
          CustomAlertBody.alertWithOneButtonAlert(context,
              imageLoc: AssetStrings.errorLottie,
              title: AppStrings.oopsTitle,
              bodyText: AppStrings.somethingWentWrong,
              actionButtonText: AppStrings.gotIt));
      isLoading.value = false;
    }
  }

  Future<void> saveToUserCollection(UserCredential userCredential) async {
    try {
      final userCollectionRef =
          FirebaseHelper.fireStoreInstance!.collection("user");
      Map<String, dynamic> userDocInfo = {
        "uid": userCredential.user!.uid,
        "email": email.value,
        "userName": userName.value,
      };
      await userCollectionRef.doc(userCredential.user!.uid).set(userDocInfo);
    } catch (e) {
      rethrow;
    }
  }
}
