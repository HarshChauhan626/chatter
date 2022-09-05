
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
import '../utils/enums.dart';
import '../widgets/animated_column_widget.dart';
import '../widgets/custom_safe_area.dart';
import '../widgets/input_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UpdateProfileScreen extends StatelessWidget {

  static String routeName="/update_profile";

  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
        child: Scaffold(
          appBar: AppBar(
            // backgroundColor: AppColors.textFieldBackgroundColor,
            title: const Text('Profile'),
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
              child: AnimatedColumn(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 3.h,
                  ),
                  InkWell(
                    child: randomAvatar(
                      "Harsh",
                      height: 120,
                      width: 120,
                    ),
                    onTap: () {
                      Get.toNamed('/edit_profile');
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
                      val: "harsh",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: LabelTextField(
                      label: "Email",
                      val: "harshchauhan5180@gmail.com",
                      isReadOnly: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: LabelTextField(
                      label: "First Name",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: LabelTextField(
                      label: "Last Name",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: LabelTextField(
                      label: "Bio",
                      maxLines: 10,
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
                        onPressed: (){},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (1==0)
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
                            if (1==1)
                              const Text(AppStrings.save)
                          ],
                        )),
                  )

                ],
              ),
            ),
          ),
        ));
  }
}



