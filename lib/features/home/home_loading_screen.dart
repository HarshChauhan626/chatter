import 'package:chat_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/app_colors.dart';

class HomeLoadingScreen extends StatelessWidget {
  const HomeLoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            for (int i = 0; i < 20; i++)
              ListTile(
                leading: const CircleAvatar(
                  radius: 20.0,
                ),
                title: Container(
                  height: 12.0,
                  color: AppColors.textFieldBackgroundColor,
                ),
                subtitle: Container(
                  height: 10.0,
                  color: AppColors.textFieldBackgroundColor,
                ),
              )
          ],
        ),
      ),
      baseColor: AppColors.textFieldBackgroundColor,
      highlightColor: AppColors.textFieldBackgroundColor.darken(5),
    );
  }
}
