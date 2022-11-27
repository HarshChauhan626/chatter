import 'package:chat_app/controllers/sign_in_controlller.dart';
import 'package:chat_app/features/home/home_screen.dart';
import 'package:chat_app/features/sign_up/sign_up_screen.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/utils/app_strings.dart';
import 'package:chat_app/utils/enums.dart';
import 'package:chat_app/utils/extensions.dart';
import 'package:chat_app/widgets/animated_column_widget.dart';
import 'package:chat_app/widgets/custom_elevated_button.dart';
import 'package:chat_app/widgets/custom_route_builder.dart';
import 'package:chat_app/widgets/custom_safe_area.dart';
import 'package:chat_app/widgets/input_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../utils/asset_strings.dart';
import '../../widgets/alert_dialog.dart';
import '../../widgets/custom_alert_body.dart';
import '../forgot_password/forgot_password_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  static const String routeName = '/signin';

  static Route route() {
    // return MaterialPageRoute(
    //     settings: const RouteSettings(name: routeName),
    //     builder: (_) => const SignInScreen()
    // );
    return CustomRouteBuilder(page: const SignInScreen(), routeName: routeName);
  }

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isLoading = false;

  SignInController signInController = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
          child: AnimatedColumn(
        children: [
          getHeaderImageWidget(),
          Text(
            AppStrings.welcomeBack,
            style: Theme.of(context).textTheme.headline5?.copyWith(
                fontWeight: FontWeight.w900, color: AppColors.primaryColor),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            AppStrings.pleaseSignIn,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(color: AppColors.greyColor),
          ),
          const SizedBox(
            height: 30.0,
          ),
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: InputTextField(
                onChangedValue: (value) {
                  debugPrint(value);
                  signInController.user.value = value;
                },
                hintText: AppStrings.emailHint,
                inputTextType: InputTextType.email,
              )),
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: InputTextField(
                onChangedValue: (value) {
                  debugPrint(value);
                  signInController.password.value = value;
                },
                hintText: AppStrings.password,
                inputTextType: InputTextType.password,
              )),
          // const SizedBox(
          //   height: 10.0,
          // ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, ForgotPasswordScreen.routeName);
              },
              child: Text(
                AppStrings.forgotPassword,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(color: AppColors.primaryColor),
              ),
            ),
          ),
          const SizedBox(
            height: 50.0,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Obx(
                () => ElevatedButton(
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
                    onPressed: signInController.isLoading.value
                        ? null
                        : () async {
                            signInController.signInUser(context);
                          },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (signInController.isLoading.value)
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
                        if (!(signInController.isLoading.value))
                          const Text(AppStrings.signIn)
                      ],
                    )),
              )),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: AppColors.textFieldBackgroundColor,
                    elevation: 3.0),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 30.0,
                        child: SvgPicture.asset(AssetStrings.icons8Google)),
                    Text(
                      AppStrings.signInWithGoogle,
                      style: Theme.of(context).textTheme.button?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.blackTextColor),
                    )
                  ],
                )),
          ),
          const SizedBox(
            height: 60.0,
          ),
          getNavigateToSignUpWidget()
        ],
      )),
    ));
  }

  Widget getNavigateToSignUpWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.dontHaveAccount,
          style: Theme.of(context)
              .textTheme
              .bodyText2
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, SignUpScreen.routeName);
            },
            child: const Text(AppStrings.register))
      ],
    );
  }

  Widget getHeaderImageWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: SizedBox(
        height: 120.0,
        child: SvgPicture.asset(AssetStrings.personalization),
      ),
    );
  }
}
