import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

import '../utils/app_colors.dart';

class UtilWidgets{
  static Widget getHeaderIcon(IconData iconData, {required Function onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: InkWell(
        child: Icon(
          iconData,
          color: AppColors.primaryColor,
          size: 26,
        ),
        onTap: () {
          onTap();
        },
      ),
    );
  }


  static void showSnackBar(String message){
    Get.showSnackbar(
      GetSnackBar(
        message: message,
        duration: const Duration(seconds: 2),
      ),
    );
  }

}