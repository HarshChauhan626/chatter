import 'package:chat_app/controllers/update_profile_controller.dart';
import 'package:chat_app/screens/profile_picture_screen.dart';
import 'package:chat_app/utils/extensions.dart';
import 'package:chat_app/widgets/label_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:sizer/sizer.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/asset_strings.dart';
import '../utils/enums.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/animated_column_widget.dart';
import '../widgets/custom_alert_body.dart';
import '../widgets/custom_safe_area.dart';
import '../widgets/input_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UpdateProfileScreen extends StatelessWidget {
  static String routeName = "/update_profile";

  UpdateProfileScreen({Key? key}) : super(key: key);

  final updateProfileController=Get.find<UpdateProfileController>();
  @override
  Widget build(BuildContext context) {

    return CustomSafeArea(
        child: Scaffold(
      appBar: AppBar(
        // backgroundColor: AppColors.textFieldBackgroundColor,
        title: const Text('Update Profile'),
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
            color: AppColors.blackTextColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Obx(() => updateProfileController.errorMessage.value.isEmpty?getProfileView(context):getNotAbleToLoadProfileView()),
        ),
      ),
    ));
  }


  Widget getNotAbleToLoadProfileView(){
    return const Center(
      child: Text("Not able to load profile data"),
    );
  }


  Widget getProfileView(BuildContext context){
    return AnimatedColumn(
      animationType: AnimationType.vertical,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          height: 3.h,
        ),
        InkWell(
          child: Hero(
            tag: "ProfilePictureTag",
            child: randomAvatar(
              "Harsh",
              height: 120,
              width: 120,
            ),
          ),
          onTap: () {
            Get.toNamed(ProfilePictureScreen.routeName);
          },
        ),
        SizedBox(
          width: double.infinity,
          height: 4.h,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: LabelTextField(
            label: "Username",
            val: updateProfileController.currentUserInfo.value?.userName,
            onChanged: (value){
              updateProfileController.username.value=value;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: LabelTextField(
            label: "Email",
            val: updateProfileController.currentUserInfo.value!.email,
            isReadOnly: true,
            onChanged: (value){
              updateProfileController.email.value=value;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: LabelTextField(
            label: "First Name",
            val: updateProfileController.currentUserInfo.value!.firstName,
            onChanged: (value){
              updateProfileController.firstName.value=value;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: LabelTextField(
            label: "Last Name",
            val: updateProfileController.currentUserInfo.value!.lastName,
            onChanged: (value){
              updateProfileController.lastName.value=value;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: LabelTextField(
            label: "Bio",
            val: updateProfileController.currentUserInfo.value!.bio,
            maxLines: 10,
            onChanged: (value){
              updateProfileController.bio.value=value;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return AppColors.primaryColor;
                    } else if (states.contains(MaterialState.disabled)) {
                      return AppColors.primaryColor.darken(30);
                    }
                    return AppColors
                        .primaryColor; // Use the component's default./ Use the component's default.
                  },
                ),
              ),
              onPressed: () {
                updateProfileController.updateUserProfile(context);
              },
              child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (updateProfileController.isUpdating.value)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: SizedBox(
                        height: 23.0,
                        width: 23.0,
                        child: CircularProgressIndicator(
                          color: AppColors.whiteColor,
                          strokeWidth: 3.0,
                        ),
                      ),
                    ),
                  if (!updateProfileController.isUpdating.value) const Text(AppStrings.save)
                ],
              ))
          ),
        )
      ],
    );
  }


}
