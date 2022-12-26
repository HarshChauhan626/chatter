import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

import '../utils/app_colors.dart';

class ProfilePictureAvatar extends StatelessWidget {
  String? profilePictureLink;
  bool? showCheckIcon;
  double? height;
  double? width;

  ProfilePictureAvatar(
      {Key? key,
      this.profilePictureLink,
      this.height,
      this.width,
      this.showCheckIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (showCheckIcon != null && showCheckIcon!) {
      return const CircleAvatar(
        backgroundColor: AppColors.primaryColor,
        child: Icon(
          Icons.check,
          color: AppColors.whiteColor,
        ),
      );
    }
    if (profilePictureLink != null && profilePictureLink!.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: NetworkImage(
          profilePictureLink!,
        ),
      );
    }
    return randomAvatar(
      "Harsh",
      height: height ?? 40,
      width: width ?? 40,
    );
  }
}
