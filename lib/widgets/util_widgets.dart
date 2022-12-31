import 'package:flutter/material.dart';

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
}