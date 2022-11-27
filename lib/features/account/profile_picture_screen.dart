import 'package:chat_app/controllers/update_profile_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:sizer/sizer.dart';

import '../../controllers/auth_controller.dart';
import '../../utils/app_strings.dart';
import '../../utils/asset_strings.dart';
import '../../widgets/alert_dialog.dart';
import '../../widgets/custom_alert_body.dart';
import '../../widgets/custom_safe_area.dart';

class ProfilePictureScreen extends StatelessWidget {
  static String routeName = "/profile_picture_screen";

  const ProfilePictureScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final updateProfileController = Get.find<UpdateProfileController>();

    print("Update profile controller $updateProfileController");
    print(
        "Update profile controller ${updateProfileController.currentUserInfo.toJson()}");

    return CustomSafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          centerTitle: false,
          title: const Text("Profile photo"),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.black,
              ),
              onPressed: () {
                showCustomDialog(
                    context,
                    CustomAlertBody.photoSelectionAlert(context,
                        onTapSelectNew: () {
                      updateProfileController.uploadImage();
                    }, onTapTakeNew: () {}, onTapRemove: () {}));
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.share,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: double.infinity,
            ),
            Container(
              height: 70.h,
              child: Hero(
                tag: "ProfilePictureTag",
                child: Obx(() {
                  final authController = Get.find<AuthController>();
                  return Image.network(
                    authController.userInfo.value?.profilePicture ?? "",
                    errorBuilder: (context, error, stacktrace) {
                      debugPrint(error.toString());
                      return Center(
                        // child: CircularProgressIndicator(
                        //   value: loadingProgress.expectedTotalBytes != null
                        //       ? loadingProgress.cumulativeBytesLoaded /
                        //       loadingProgress.expectedTotalBytes!
                        //       : null,
                        // ),
                        child: Lottie.asset("assets/image_loading.json",
                            repeat: false),
                      );
                    },
                    fit: BoxFit.fill,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        // child: CircularProgressIndicator(
                        //   value: loadingProgress.expectedTotalBytes != null
                        //       ? loadingProgress.cumulativeBytesLoaded /
                        //       loadingProgress.expectedTotalBytes!
                        //       : null,
                        // ),
                        child: Lottie.asset("assets/image_loading.json",
                            repeat: true),
                      );
                    },
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
