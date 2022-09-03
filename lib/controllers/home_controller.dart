import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/firebase_helper.dart';
import 'auth_controller.dart';

class HomeController extends GetxController {
  // Future<dynamic> getChatList(){
  //
  // }

  Stream? chatList;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initData();
  }

  void initData()async{
    await initChatList();
  }


  Future<void> initChatList() async {
    try {
      final chatCollectionRef =
          FirebaseHelper.fireStoreInstance!.collection("chats");

      final senderId = Get.find<AuthController>().firebaseUser.value?.uid;

      chatList = chatCollectionRef.where("userList",arrayContains: senderId).snapshots();



    } catch (e, s) {
      print(
          "Exception coming in initializing chat list is ${e.toString()} ${s.toString()}");
    }
  }
}
