import 'package:chat_app/features/home/home_screen.dart';
import 'package:chat_app/helper/firebase_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/appe2ee.dart';
import '../helper/hive_db_helper.dart';
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
        if (FirebaseHelper.user != null) {
          await updatePublicAndPrivateKeys(FirebaseHelper.user!);
          Get.toNamed(HomeScreen.routeName);
        }
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

  Future<void> updatePublicAndPrivateKeys(User user) async {
    final keys = await AppE2EE().getKeys();

    final publicKey = keys["publicKey"];
    final privateKey = keys["privateKey"];

    final hiveDBHelper = Get.find<HiveDBHelper>();

    try {
      final userCollectionRef =
          FirebaseHelper.fireStoreInstance!.collection("user");

      await userCollectionRef
          .doc(user.uid)
          .set({"publicKey": publicKey}, SetOptions(merge: true));
      hiveDBHelper.privateKey = privateKey;
      hiveDBHelper.publicKey = publicKey;
    } catch (e) {
      rethrow;
    }
  }

  bool signInFormValidated() =>
      !(user.value.isEmpty || !user.value.isEmail || password.value.isEmpty);
}
