import 'dart:io';

import 'package:chat_app/controllers/auth_controller.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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
  RxString imageUrl = "".obs;

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
    super.onReady();
    initData();
  }

  // @override
  // void onInit() {
  //   // TODO: implement onInit
  //   super.onInit();
  //
  // }


  void initData() async {
    try {
      currentUserInfo.value = Get.find<AuthController>().userInfo?.value;
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

  void uploadImage() async {
    final _firebaseStorage = FirebaseHelper.firebaseStorage;
    final _imagePicker = ImagePicker();
    XFile? image;
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      final storageRef = FirebaseHelper.firebaseStorage?.ref();

// Create a reference to "mountains.jpg"

      final imageName = "profile_pic_${currentUserInfo.value?.uid}.jpg";

      final profileRef = storageRef?.child(imageName);

      final profileImageRef = storageRef?.child(imageName);

      image = await _imagePicker.pickImage(source: ImageSource.gallery);
      File? imageFile;

      if (image != null && profileRef != null) {
        imageFile = File(image.path);
        profileRef.putFile(imageFile).snapshotEvents.listen((taskSnapshot) async {
          switch (taskSnapshot.state) {
            case TaskState.running:
              final progress = 100.0 *
                  (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
              print("Upload is $progress% complete.");
              break;
            case TaskState.paused:
              print("Upload is paused.");
              break;
            case TaskState.canceled:
              print("Upload was canceled");
              break;
            case TaskState.error:
              // Handle unsuccessful uploads
              break;
            case TaskState.success:
              // Handle successful uploads on complete
              // ...
              imageUrl.value=await profileRef.getDownloadURL();
              await updateProfilePicture();
              break;
          }
        });
      }
    } else {
      debugPrint('Permission not granted. Try Again with permission access');
    }
  }


  Future<void> updateProfilePicture() async {
    try {

      Map<String,dynamic> updatedInfo={
        "profilePicture":imageUrl.value.toString()
      };

      final userCollectionRef =
      FirebaseHelper.fireStoreInstance!.collection("user");

      final documentReference = userCollectionRef.doc(currentUserInfo.value?.uid);

      final userDocument = await documentReference.get();

      if (userDocument.exists) {
        await documentReference.update(updatedInfo);
      }

      final currentUserModel=Get.find<AuthController>().userInfo.value;

      Get.find<AuthController>().userInfo.value=currentUserModel?.copyWith(profilePicture: imageUrl.value.toString());


    } catch (e) {
      rethrow;
    }
  }
}
