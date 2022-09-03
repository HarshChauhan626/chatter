import 'package:chat_app/controllers/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../helper/firebase_helper.dart';
import '../models/user_model.dart';

class SearchPeopleController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController searchTextController = TextEditingController();

  RxString searchText = "".obs;

  RxList userList = [].obs;

  Future<void> searchPeople() async {
    try {
      isLoading.value = true;
      final userCollectionRef =
          FirebaseHelper.fireStoreInstance!.collection("user");
      final result = await userCollectionRef
          .where("userName",
              isGreaterThanOrEqualTo: searchText.value,
              isLessThan: searchText.value + "z")
          .get();

      userList.value =
          result.docs.map((e) => UserModel.fromJson(e.data())).toList();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<String?> getRoomId(String? receiverId) async {
    try {
      AuthController authController = Get.find<AuthController>();

      String? senderId = authController.firebaseUser.value?.uid;

      // String? receiverId = authController.firebaseUser.value?.uid;

      final chatCollectionRef =
          FirebaseHelper.fireStoreInstance!.collection("chats");

      final chatDocument = await chatCollectionRef.where("userList", whereIn: [
        [senderId, receiverId]
      ]).get();

      return chatDocument.docs.first.reference.id;
    } catch (e,s) {
      debugPrint("Exception coming in getting roomId ${e.toString()}${s.toString()}");
    }

    return null;
  }
}

// https://stackoverflow.com/questions/67037491/flutter-firebase-search-for-documents-which-contain-a-string-for

// https://stackoverflow.com/questions/50870652/flutter-firebase-basic-query-or-basic-search-code

// https://stackoverflow.com/questions/54987399/firestore-search-array-contains-for-multiple-values
