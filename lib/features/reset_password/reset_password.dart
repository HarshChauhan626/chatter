import 'package:chat_app/controllers/reset_password_controller.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/utils/enums.dart';
import 'package:chat_app/utils/input_validators.dart';
import 'package:chat_app/widgets/custom_route_builder.dart';
import 'package:chat_app/widgets/custom_safe_area.dart';
import 'package:chat_app/widgets/input_text_field.dart';
import 'package:chat_app/widgets/util_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  static const String routeName = '/reset_password';

  static Route route() {
    // return MaterialPageRoute(
    //     settings: const RouteSettings(name: routeName),
    //     builder: (_) =>const ResetPasswordScreen()
    // );
    return CustomRouteBuilder(
        page: const ResetPasswordScreen(), routeName: routeName);
  }

  @override
  Widget build(BuildContext context) {
    ResetPasswordController resetPasswordController =
        Get.find<ResetPasswordController>();

    return CustomSafeArea(
      child: Scaffold(
        appBar: AppBar(
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                CupertinoIcons.back,
                color: AppColors.blackTextColor,
              ),
            ),
            title: const Text("Reset password")),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
                child: SizedBox(
                  height: 22.h,
                  child: SvgPicture.asset("assets/reset_password.svg"),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: InputTextField(
                    onChangedValue: (value) {
                      resetPasswordController.oldPassword.value = value;
                    },
                    hintText: "Old password",
                    inputTextType: InputTextType.password),
              ),
              SizedBox(
                height: 4.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: InputTextField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      return InputValidators.passwordValidator(value);
                    },
                    onChangedValue: (value) {
                      resetPasswordController.newPassword.value = value;
                    },
                    hintText: "New password",
                    inputTextType: InputTextType.password),
              ),
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: InputTextField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      return InputValidators.passwordValidator(value);
                    },
                    onChangedValue: (value) {
                      resetPasswordController.newConfirmPassword.value = value;
                    },
                    hintText: "Confirm new password",
                    inputTextType: InputTextType.password),
              ),
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: ElevatedButton(
                    onPressed: ()async {
                      await onTapResetPassword(context);
                    }, child: const Text("Submit")),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onTapResetPassword(BuildContext context) async{
    final resetPasswordController = Get.find<ResetPasswordController>();
    final oldPassword=resetPasswordController.oldPassword.value;
    final newPassword=resetPasswordController.newPassword.value;
    final newConfirmPassword=resetPasswordController.newConfirmPassword.value;

    if(oldPassword.isEmpty || newPassword.isEmpty || newConfirmPassword.isEmpty){
      return;
    }
    if(newPassword==oldPassword){
      UtilWidgets.showSnackBar(
        "New password cannot be same to old password."
      );
      return;
    }
    if(newPassword!=newConfirmPassword){
      UtilWidgets.showSnackBar(
        "Passwords do not match"
      );
      return;
    }
    if(InputValidators.passwordValidator(newPassword)==null && InputValidators.passwordValidator(newConfirmPassword)==null)
     {
       return;
     }
    await resetPasswordController.updatePassword(oldPassword, newPassword, context);
  }
}
