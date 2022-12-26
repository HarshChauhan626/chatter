import 'package:chat_app/constants.dart';
import 'package:chat_app/controllers/sign_up_controller.dart';
import 'package:chat_app/features/sign_in/sign_in_screen.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/utils/enums.dart';
import 'package:chat_app/utils/extensions.dart';
import 'package:chat_app/utils/input_validators.dart';
import 'package:chat_app/widgets/animated_column_widget.dart';
import 'package:chat_app/widgets/custom_route_builder.dart';
import 'package:chat_app/widgets/custom_safe_area.dart';
import 'package:chat_app/widgets/input_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utils/app_strings.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static const String routeName = '/signup';

  static Route route() {
    // return MaterialPageRoute(
    //     settings: const RouteSettings(name: routeName),
    //     builder: (_) => const SignUpScreen());
    return CustomRouteBuilder(page: const SignUpScreen(), routeName: routeName);
  }

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpController signUpController = Get.put(SignUpController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
        child: Scaffold(
      appBar: AppBar(
          // leading: Padding(
          //   padding: const EdgeInsets.all(6.0),
          //   child: InkWell(
          //     onTap: (){
          //       Navigator.pop(context);
          //     },
          //     child: Container(
          //       decoration: BoxDecoration(
          //           border: Border.all(
          //             color: AppColors.blackTextColor,
          //           ),
          //           borderRadius: BorderRadius.circular(10.0)
          //       ),
          //       child: const Icon(CupertinoIcons.back,color: AppColors.blackTextColor,),
          //     ),
          //   ),
          // )
          ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: AnimatedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40.0,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  AppStrings.createNewAccount,
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w900),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  AppStrings.signUpToGetStarted,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.black38),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              InputTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (String? value) {
                    return InputValidators.usernameValidator(value);
                  },
                  onChangedValue: (value) {
                    signUpController.userName.value = value;
                  },
                  hintText: AppStrings.username,
                  inputTextType: InputTextType.username),
              const SizedBox(
                height: 14.0,
              ),
              InputTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (String? value) {
                    return InputValidators.emailValidator(value);
                  },
                  onChangedValue: (value) {
                    signUpController.email.value = value;
                  },
                  hintText: "Email",
                  inputTextType: InputTextType.email),
              const SizedBox(
                height: 14.0,
              ),
              InputTextField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (String? value) {
                    return InputValidators.passwordValidator(value);
                  },
                  onChangedValue: (value) {
                    signUpController.password.value = value;
                  },
                  hintText: "Password",
                  inputTextType: InputTextType.password),
              const SizedBox(
                height: 40.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  if(isFormValid()){
                    signUpController.registerUser(context);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (signUpController.isLoading.value)
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
                    if (!signUpController.isLoading.value)
                      const Text(AppStrings.submit)
                  ],
                ),
              ),
              const SizedBox(
                height: 14.0,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: AppColors.textFieldBackgroundColor,
                      elevation: 3.0),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 30.0,
                          child: SvgPicture.asset("assets/icons8-google.svg")),
                      Text(
                        "Sign up with Google",
                        style: Theme.of(context).textTheme.button?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackTextColor),
                      )
                    ],
                  )),
              const SizedBox(
                height: 50.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already a member?",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, SignInScreen.routeName);
                      },
                      child: const Text('Sign In'))
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }


  bool isFormValid(){
    final isValidPassword=InputValidators.passwordValidator(signUpController.password.value)==null;
    final isValidUsername=InputValidators.usernameValidator(signUpController.userName.value)==null;
    final isValidEmail=InputValidators.usernameValidator(signUpController.email.value)==null;

    return isValidPassword && isValidUsername && isValidEmail;

  }


}
