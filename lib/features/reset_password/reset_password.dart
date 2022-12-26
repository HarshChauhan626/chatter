import 'package:chat_app/utils/input_validators.dart';
import 'package:chat_app/widgets/custom_route_builder.dart';
import 'package:chat_app/widgets/custom_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/utils/enums.dart';
import 'package:chat_app/widgets/input_text_field.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResetPasswordScreen extends StatefulWidget {
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
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        appBar: AppBar(
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                CupertinoIcons.back,
                color: AppColors.blackTextColor,
              ),
            ),
          title: const Text("Reset password")
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
                child: Container(
                  height: 22.h,
                  child: SvgPicture.asset("assets/reset_password.svg"),
                ),
              ),
              // Text(
              //   "Reset password",
              //   style: Theme.of(context).textTheme.headline5?.copyWith(
              //       color: AppColors.primaryColor, fontWeight: FontWeight.w900),
              // ),
              SizedBox(
                height: 4.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: InputTextField(
                    onChangedValue: (value) {},
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
                    onChangedValue: (value) {},
                    hintText: "Confirm new password",
                    inputTextType: InputTextType.password),
              ),
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: ElevatedButton(
                    onPressed: () {}, child: const Text("Submit")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
