import 'package:chat_app/controllers/auth_controller.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../helper/firebase_helper.dart';
import '../utils/app_strings.dart';
import '../utils/asset_strings.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/custom_alert_body.dart';

class UpdateProfileController extends GetxController {
  final currentUserInfo = Rxn<UserModel>();
  RxString errorMessage = "".obs;
  RxBool isLoading = false.obs;
  RxBool isUpdating = false.obs;

  // TextEditingController? userNameController=TextEditingController();
  // TextEditingController? emailController=TextEditingController();
  // TextEditingController? firstNameController=TextEditingController();
  // TextEditingController? lastNameController=TextEditingController();
  // TextEditingController? bioController=TextEditingController();

  final firstName = Rxn<String>();
  final lastName = Rxn<String>();
  final username = Rxn<String>();
  final email = Rxn<String>();
  final bio = Rxn<String>();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    initData();
  }

  // @override
  // void onInit() {
  //   // TODO: implement onInit
  //   super.onInit();
  //
  // }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void initData() async {
    try {
      currentUserInfo.value = Get.find<AuthController>().userInfo;
      if (currentUserInfo.value != null) {
        username.value = currentUserInfo.value!.userName ?? "";
        firstName.value = currentUserInfo.value!.firstName ?? "";
        email.value = currentUserInfo.value!.email ?? "";
        lastName.value = currentUserInfo.value!.lastName ?? "";
        bio.value = currentUserInfo.value!.bio ?? "";
      }
    } catch (e) {
      errorMessage.value = "Unable to load profile";
    }
  }

  void updateUserProfile(BuildContext context) async {
    try {
      isUpdating.value = true;

      final userCollectionRef =
          FirebaseHelper.fireStoreInstance!.collection("user");

      final authController = Get.find<AuthController>();

      final docReference = await userCollectionRef
          .doc(authController.firebaseUser.value?.uid)
          .get();

      if (docReference.exists) {
        Map<String, dynamic> userData = {
          "email": email.value,
          "userName": username.value,
          "bio": bio.value,
          "firstName": firstName.value,
          "lastName": lastName.value,
        };
        await userCollectionRef
            .doc(authController.firebaseUser.value?.uid)
            .update(userData);
      }
      isUpdating.value = false;
      showCustomDialog(
          context,
          CustomAlertBody.alertWithOneButtonAlert(context,
              title: AppStrings.success,
              bodyText: AppStrings.profileUpdatedSuccessfully,
              actionButtonText: AppStrings.gotIt));
    } catch (e) {
      isUpdating.value = false;
      showCustomDialog(
          context,
          CustomAlertBody.alertWithOneButtonAlert(context,
              imageLoc: AssetStrings.errorLottie,
              title: AppStrings.oopsTitle,
              bodyText: AppStrings.somethingWentWrong,
              actionButtonText: AppStrings.gotIt));
      print("Exception coming in updating user profile ${e.toString()}");
    }
  }
}
