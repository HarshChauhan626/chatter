import 'package:chat_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/app_colors.dart';

class ChatLoadingScreen extends StatelessWidget {
  const ChatLoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child: ListView.builder(
            itemCount: 30,
            itemBuilder: (context, index) {
              bool isSender = index % 2 == 0 || index % 5 == 0;
              return Container(
                height: 70.0,
                padding: EdgeInsets.only(
                    left: isSender ? 50 : 14,
                    right: isSender ? 14 : 50,
                    top: 10,
                    bottom: 10),
                child: Align(
                  alignment:
                      isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    height: 70.0,
                    color: AppColors.textFieldBackgroundColor,
                  ),
                ),
              );
            }),
        baseColor: AppColors.textFieldBackgroundColor,
        highlightColor: AppColors.textFieldBackgroundColor.darken(5));
  }
}
