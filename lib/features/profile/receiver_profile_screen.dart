import 'package:chat_app/controllers/chat_controller.dart';
import 'package:chat_app/utils/extensions.dart';
import 'package:chat_app/widgets/animated_column_widget.dart';
import 'package:chat_app/widgets/custom_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_colors.dart';
import '../../widgets/profile_picture_avatar.dart';

class ReceiverProfileScreen extends StatelessWidget {
  const ReceiverProfileScreen({Key? key}) : super(key: key);

  static String routeName = "/receiver_profile_screen";

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatController>();

    final receiverModel = chatController.receiverModel;

    final receiverProfilePicture =
        chatController.receiverModel?.profilePicture ?? "";

    return CustomSafeArea(
      child: Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: Size(double.infinity, 30.h),
        //   child: Container(
        //     decoration: BoxDecoration(
        //       color: AppColors.whiteColor,
        //       // borderRadius: BorderRadius.only(
        //       //     bottomRight: Radius.circular(4.w),
        //       //     bottomLeft: Radius.circular(4.w)
        //       // ),
        //       boxShadow: [
        //         BoxShadow(
        //             offset: const Offset(0, 2),
        //             blurRadius: 3,
        //             color: Colors.grey.shade300),
        //       ],
        //     ),
        //     child: Row(
        //       children: [
        //         IconButton(
        //           icon: const Icon(CupertinoIcons.back),
        //           onPressed: () {
        //             Navigator.pop(context);
        //           },
        //         ),
        //         // const Spacer(),
        //         // IconButton(
        //         //   icon: const Icon(
        //         //     Icons.more_vert,
        //         //     color: Colors.black,
        //         //   ),
        //         //   onPressed: () {},
        //         // ),
        //       ],
        //     ),
        //   ),
        // ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 2.0,
          leading: IconButton(
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.black,
              size: 28.0,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 5.h,
              ),
              Container(
                child: Hero(
                  tag: "ReceiverProfilePicture",
                  child: Container(
                      height: 120,
                      width: 120,
                      child: ProfilePictureAvatar(
                        profilePictureLink: receiverProfilePicture,
                        height: 120.0,
                        width: 120.0,
                      )),
                ),
              ),
              Container(
                child: AnimatedColumn(
                  animationType: AnimationType.vertical,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Harsh Chauhan",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 15.0),
                        padding: const EdgeInsets.only(bottom: 18.0, top: 10.0),
                        decoration: BoxDecoration(
                            color: AppColors.textFieldBackgroundColor,
                            borderRadius: BorderRadius.circular(10.0)
                            // border: Border.symmetric(
                            //     horizontal: BorderSide(
                            //         color: AppColors.appGreyColor.darken(10),
                            //         width: 1.0)
                            // )
                            ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            getRowItem(
                                () {}, Icons.call_outlined, "Call", context),
                            getRowItem(() {}, Icons.video_call_outlined,
                                "Video", context),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.textFieldBackgroundColor,
                          borderRadius: BorderRadius.circular(10.0)),
                      margin: const EdgeInsets.symmetric(horizontal: 15.0),
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              "User info",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.greyColor?.darken(20)),
                            ),
                          ),
                          userInfoItem(context, "Full name",
                              "${receiverModel?.firstName ?? ""} ${receiverModel?.lastName ?? ""}"),
                          userInfoItem(
                              context, "Email", receiverModel?.email ?? ""),
                          userInfoItem(
                              context, "Bio", receiverModel?.bio ?? ""),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.textFieldBackgroundColor,
                          borderRadius: BorderRadius.circular(10.0)),
                      margin: const EdgeInsets.symmetric(horizontal: 15.0),
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              "No groups in common",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.greyColor?.darken(20)),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: AppColors.primaryColor,
                              child: Icon(
                                Icons.group,
                                color: AppColors.whiteColor,
                              ),
                            ),
                            title: Text(
                              "Create group with Harsh Chauhan",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget userInfoItem(
      BuildContext context, String userInfoTitle, String userInfoSubTitle) {
    return ListTile(
      title: Text(userInfoTitle),
      subtitle: Text(userInfoSubTitle),
    );
  }

  Widget getRowItem(Function onPressed, IconData iconData, String subTitleText,
      BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            onPressed();
          },
          icon: Icon(
            iconData,
            color: AppColors.primaryColor,
            size: 30.0,
          ),
        ),
        Text(
          subTitleText,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.primaryColor, fontWeight: FontWeight.w600),
        )
      ],
    );
  }
}
