import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/utils/app_strings.dart';
import 'package:chat_app/utils/enums.dart';
import 'package:chat_app/widgets/input_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'forgot_password_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  static const String routeName = '/signin';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const SignInScreen());
  }

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: SizedBox(
                  height: 120.0,
                  child: SvgPicture.asset("assets/personalization.svg"),
                ),
              ),
              Text(
                "Welcome Back!",
                style: Theme.of(context).textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.w900, color: AppColors.primaryColor),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "Please sign in to your account",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: AppColors.greyColor),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: InputTextField(
                    onChangedValue: (value) {
                      debugPrint(value);
                    },
                    hintText: "Email",
                    inputTextType: InputTextType.email,
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: InputTextField(
                    onChangedValue: (value) {
                      debugPrint(value);
                    },
                    hintText: "Password",
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
                    Navigator.pushNamed(
                        context, ForgotPasswordScreen.routeName);
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
                child: ElevatedButton(
                    onPressed: () {}, child: const Text("Sign In")),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
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
                            child:
                                SvgPicture.asset("assets/icons8-google.svg")),
                        Text(
                          "Sign in with Google",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, SignUpScreen.routeName);
                      },
                      child: const Text('Sign Up'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
