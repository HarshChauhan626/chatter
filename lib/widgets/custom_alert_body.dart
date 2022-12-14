import 'package:chat_app/features/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../utils/app_colors.dart';
import '../utils/app_strings.dart';

class CustomAlertBody {
  static Widget alertWithOneButtonAlert(BuildContext context,
      {String? imageLoc,
      String? title,
      String? bodyText,
      String? actionButtonText}) {
    return SizedBox(
      height: imageLoc != null ? 47.h : 30.h,
      width: 80.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (imageLoc != null)
            Padding(
              padding: EdgeInsets.only(top: 4.h, bottom: 2.h),
              child: SizedBox(
                  height: 15.h,
                  width: 15.h,
                  child: Lottie.asset(imageLoc, repeat: false)),
            ),
          Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: Align(
                alignment: Alignment.center,
                child: Text(
                  title ?? "Alert",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(fontWeight: FontWeight.w900),
                )),
          ),
          SizedBox(
            height: 1.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                bodyText ?? "Body Text",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: AppColors.greyColor),
              ),
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5.w,
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(actionButtonText ?? "Ok"),
            ),
          )
        ],
      ),
    );
  }

  static Widget alertWithTwoButtons(BuildContext context,
      {String? title,
      String? bodyText,
      String? actionButtonOneText,
      String? actionButtonTwoText,
      Function? onTapActionButtonOneText,
      Function? onTapActionButtonTwoText}) {
    return Container(
      width: 80.w,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Text(title ?? "Alert",
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(fontWeight: FontWeight.w900)),
          ),
          SizedBox(
            height: 2.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Text(
              bodyText ?? "",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: AppColors.greyColor),
            ),
          ),
          SizedBox(height: 6.h),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 5.w),
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       Expanded(
          //         child: Padding(
          //           padding: const EdgeInsets.only(right: 10.0),
          //           child: ElevatedButton(
          //             style: ElevatedButton.styleFrom(
          //                 primary: AppColors.textFieldBackgroundColor,
          //                 elevation: 3.0),
          //             child: Text(
          //               actionButtonOneText ?? "",
          //               style: const TextStyle(color: Colors.black),
          //             ),
          //             onPressed: () {
          //               Navigator.pop(context);
          //             },
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         child: Padding(
          //           padding: const EdgeInsets.only(left: 10.0),
          //           child: ElevatedButton(
          //             child: Text(actionButtonTwoText ?? ""),
          //             onPressed: () {
          //               Navigator.pushNamedAndRemoveUntil(
          //                   context, SignInScreen.routeName, (route) => false);
          //             },
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // )
          getButtonRow(
              context: context,
              actionButtonOneText: actionButtonOneText,
              actionButtonTwoText: actionButtonTwoText,
              onTapActionButtonOne: onTapActionButtonOneText,
              onTapActionButtonTwo: onTapActionButtonTwoText),
        ],
      ),
    );
  }

  static Widget photoSelectionAlert(BuildContext context,
      {required Function onTapSelectNew,
      Function? onTapRemove,
      required Function onTapTakeNew}) {
    return SizedBox(
      height: 30.h,
      width: 80.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5.w, bottom: 2.h, top: 2.h),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Change photo" ?? "Alert",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(fontWeight: FontWeight.w900),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, top: 1.h),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Remove photo" ?? "Alert",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w400),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, top: 2.h),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Take new photo" ?? "Alert",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w400),
                )),
          ),
          InkWell(
            onTap: () {
              onTapSelectNew();
            },
            child: Padding(
              padding: EdgeInsets.only(left: 5.w, top: 2.h, bottom: 2.h),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Select new photo" ?? "Alert",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w400),
                  )),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 4.w, bottom: 2.h),
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 30.w,
                height: 5.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  static Widget deleteMessageAlert(
      {required BuildContext context,
      String? title,
      String? subtitle,
      String? deleteFor,
      required Function onTapDeleteForAll,
      required Function onTapDeleteForMe,
      required Function onTapCancel}) {
    bool isSelected = false;
    bool isLoading = false;

    return StatefulBuilder(builder: (context, setState) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80.w,
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Text(isLoading?"Deleting":title?? "Alert",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(fontWeight: FontWeight.w900)),
            ),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Text(
                isLoading?"":subtitle ?? "",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: AppColors.greyColor),
              ),
            ),
            isLoading
                ? const SizedBox()
                : InkWell(
                    onTap: () {
                      setState(() {
                        isSelected = !isSelected;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.9.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: isSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                isSelected = value ?? false;
                              });
                            },
                          ),
                          Text(
                            "Also delete for ${deleteFor ?? "Everyone"}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(),
                          ),
                        ],
                      ),
                    ),
                  ),
            SizedBox(
              height: 2.h,
            ),
            isLoading
                ? getLinearProgressLoader()
                : getButtonRow(
                    context: context,
                    actionButtonOneText: AppStrings.cancel,
                    actionButtonTwoText: AppStrings.delete,
                    onTapActionButtonTwo: () async {
                      setState(() {
                        isLoading = true;
                      });
                      if(isSelected){
                        await onTapDeleteForAll();
                      }
                      else{
                        await onTapDeleteForMe();
                      }
                      // await Future.delayed(const Duration(seconds: 10));
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.pop(context);
                    },
                    onTapActionButtonOne: () {
                      onTapCancel();
                    })
          ],
        ),
      );
    });
  }

  static Widget getLinearProgressLoader() {
    return Padding(
      padding: EdgeInsets.all(5.w),
      child: const LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
        minHeight: 3,
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

  static Widget getButtonRow(
      {required BuildContext context,
      String? actionButtonOneText,
      String? actionButtonTwoText,
      Function? onTapActionButtonOne,
      Function? onTapActionButtonTwo}) {
    return Padding(
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
                    elevation: 3.0),
                child: Text(
                  actionButtonOneText ?? "",
                  style: const TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  if (onTapActionButtonOne != null) {
                    onTapActionButtonOne();
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: ElevatedButton(
                child: Text(actionButtonTwoText ?? ""),
                onPressed: () {
                  if (onTapActionButtonTwo != null) {
                    onTapActionButtonTwo();
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
