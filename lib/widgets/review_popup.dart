import 'package:chat_app/controllers/review_controller.dart';
import 'package:chat_app/utils/asset_strings.dart';
import 'package:chat_app/utils/enums.dart';
import 'package:chat_app/utils/extensions.dart';
import 'package:chat_app/widgets/input_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../utils/app_colors.dart';
import '../utils/app_strings.dart';

class ReviewPopup extends StatelessWidget {
  ReviewPopup({Key? key}) : super(key: key);

  ReviewController reviewController = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0))),
      child: Column(
        children: [
          InkWell(
            child: Container(
              width: 60.0,
              height: 5.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: AppColors.textFieldBackgroundColor.darken(),
              ),
              margin: const EdgeInsets.symmetric(vertical: 5.0),
            ),
          ),
          Obx(() => getBody(context))
        ],
      ),
    );
  }

  Widget getBody(BuildContext context) {
    if (reviewController.isLoading.value) {
      return getBodyWhileLoading();
    }
    if (reviewController.isRequestComplete.value) {
      return getBodyAfterLoading(context);
    }
    return getBodyBeforeLoading(context);
  }

  Widget getBodyAfterLoading(BuildContext context) {
    String imageLoc = reviewController.isSuccessful.value
        ? AssetStrings.success
        : AssetStrings.errorLottie;
    String message = reviewController.isSuccessful.value
        ? AppStrings.reviewSaved
        : AppStrings.somethingWentWrong;
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 4.h, bottom: 2.h),
            child: SizedBox(
                height: 15.h,
                width: 15.h,
                child: Lottie.asset(imageLoc, repeat: false)),
          ),
          Text(
            message,
            style: Theme.of(context).textTheme.headline6,
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
              child: const Text(AppStrings.gotIt),
            ),
          )
        ],
      ),
    );
  }

  Widget getBodyBeforeLoading(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              AppStrings.giveFeedback,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: RatingBar.builder(
              initialRating: 5,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                debugPrint(rating.toString());
              },
            ),
          ),
          Container(
            height: 25.h,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: InputTextField(
                onChangedValue: (value) {
                  reviewController.comments.value = value;
                },
                hintText: AppStrings.comments,
                inputTextType: InputTextType.normal),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: ElevatedButton(
                onPressed: () async {
                  await reviewController.submitReview();
                },
                child: const Text(AppStrings.submit)),
          )
        ],
      ),
    );
  }

  Widget getBodyWhileLoading() {
    return const Expanded(
      child: Center(
        child: SizedBox(
          height: 40.0,
          width: 40.0,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
