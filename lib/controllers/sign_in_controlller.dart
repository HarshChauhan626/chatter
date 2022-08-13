import 'package:chat_app/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

class SignInController extends GetxController {
  RxString user = "".obs;
  RxString password = "".obs;
  RxBool isLoading = false.obs;

  void signInUser() async {
    try {
      AuthController authController = Get.find<AuthController>();
      isLoading.value = true;
      bool canLogin=await authController.login(user.value, password.value);
      isLoading.value = false;
      if(canLogin){
        Get.to(const HomeScreen());
      }
      else{
        Get.snackbar(
          "",
          "Wrong email or password",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2)
        );
      }
    } catch (e) {
      isLoading.value = false;
    }
  }
}
