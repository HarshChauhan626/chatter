import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/utils/enums.dart';
import 'package:chat_app/widgets/custom_route_builder.dart';
import 'package:chat_app/widgets/custom_safe_area.dart';
import 'package:chat_app/widgets/input_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  static const String routeName = '/forgot_password';

  static Route route() {
    // return MaterialPageRoute(
    //     settings: const RouteSettings(name: routeName),
    //     builder: (_) =>const ForgotPasswordScreen()
    // );
    return CustomRouteBuilder(page: const ForgotPasswordScreen(),routeName: routeName);
  }

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(6.0),
            child: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.blackTextColor,
                    ),
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: const Icon(CupertinoIcons.back,color: AppColors.blackTextColor,),
              ),
            ),
          )
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 5.h,
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 4.h,horizontal: 4.w),child: Container(
                height: 22.h,
                child: SvgPicture.asset("assets/forgot_password.svg"),
              ),),
              Text("Forgot Password?",style: Theme.of(context).textTheme.headline5?.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w900
              ),),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w,vertical: 2.h),
                child: Text("Don't worry it happens. Please enter the address associated with your account",style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: AppColors.greyColor
                ),),
              ),
              SizedBox(
                height: 4.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: InputTextField(onChangedValue: (value){
                }, hintText: "Email", inputTextType: InputTextType.email),
              ),
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: ElevatedButton(onPressed: (){

                }, child: const Text("Submit")),
              )
            ],
          ),
        ),
      ),
    );
  }
}







