import 'package:chat_app/helper/firebase_helper.dart';
import 'package:chat_app/widgets/alert_dialog.dart';
import 'package:chat_app/widgets/custom_alert_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  RxString oldPassword = "".obs;
  RxString newPassword = "".obs;
  RxString newConfirmPassword="".obs;

  Future<void> updatePassword(
      String oldPassword, String newPassword, BuildContext context) async {
    try {
      final authCredential = EmailAuthProvider.credential(
          email: FirebaseHelper.user!.email!, password: oldPassword);
      final result = await FirebaseHelper.user!
          .reauthenticateWithCredential(authCredential);
      if (result.user == null) {
        showCustomDialog(
            context,
            CustomAlertBody.alertWithOneButtonAlert(context,
                imageLoc: "assets/error_lottie.json",
                title: "Wrong password",
                bodyText: "You have entered an incorrect old password.",
                actionButtonText: "Try again"));
      } else {
        await result.user!.updatePassword(newPassword);
        showCustomDialog(
            context,
            CustomAlertBody.alertWithOneButtonAlert(context,
                imageLoc: "assets/success.json",
                title: "Success",
                bodyText: "Your password has been successfully changed.",
                actionButtonText: "Got it"));
      }
    } catch (e) {
      showCustomDialog(
          context,
          CustomAlertBody.alertWithOneButtonAlert(context,
              imageLoc: "assets/error_lottie.json",
              title: "OOPS!",
              bodyText: "Something went wrong. Please try again later.",
              actionButtonText: "Try again"));
    }
  }
}
