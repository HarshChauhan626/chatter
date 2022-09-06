import 'package:chat_app/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../utils/app_colors.dart';

class CustomAlertBody{
  static Widget alertWithOneButtonAlert(BuildContext context,{String? imageLoc,String? title,String? bodyText,String? actionButtonText}){
    return SizedBox(
      height: imageLoc!=null?47.h:30.h,
      width: 80.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(imageLoc!=null)
            Padding(
              padding: EdgeInsets.only(top: 4.h,bottom: 2.h),
              child: SizedBox(
                  height: 15.h,
                  width: 15.h,
                  child: Lottie.asset(imageLoc,repeat: false)
              ),
            ),
          Padding(
            padding: EdgeInsets.only(left:5.w),
            child: Align(
                alignment:Alignment.center,child: Text(title??"Alert",style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.w900),)),
          ),
          SizedBox(
            height: 1.h,
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 5.w),child: Align(
            alignment: Alignment.center,
            child: Text(bodyText??"Body Text",textAlign: TextAlign.center,style: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: AppColors.greyColor
            ),),
          ),),
          SizedBox(
            height: 4.h,
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 5.w,),child: ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text(actionButtonText??"Ok"),
          ),)

        ],
      ),
    );
  }

  static Widget alertWithTwoButtons(BuildContext context,{String? title,String? bodyText,String? actionButtonOneText,String? actionButtonTwoText,Function? onTapActionButtonOneText,Function? onTapActionButtonTwoText}){
    return Container(
      width: 80.w,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Text(title??"Alert",style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.w900)),
          ),
          SizedBox(
            height: 2.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Text(bodyText??"",style: Theme.of(context).textTheme.bodyText1?.copyWith(color: AppColors.greyColor),),
          ),
          SizedBox(
            height:6.h
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: AppColors.textFieldBackgroundColor,
                          elevation: 3.0
                      ),
                      child: Text(actionButtonOneText??"",style: const TextStyle(
                        color: Colors.black
                      ),),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: ElevatedButton(
                      child: Text(actionButtonTwoText??""),
                      onPressed: (){
                        Navigator.pushNamedAndRemoveUntil(context, SignInScreen.routeName, (route) => false);
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}


