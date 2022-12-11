import 'package:chat_app/models/room_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/firebase_helper.dart';
import '../models/user_model.dart';
import 'auth_controller.dart';

class HomeController extends GetxController {
  Stream? chatList;

  String? senderId;

  RxList<String> selectedChatIdList = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  void initData() async {
    await initChatList();
  }

  Future<void> initChatList() async {
    try {
      final chatCollectionRef =
          FirebaseHelper.fireStoreInstance!.collection("chats");

      senderId = Get.find<AuthController>().firebaseUser.value?.uid;

      chatList = chatCollectionRef
          .where("userList", arrayContains: senderId)
          .snapshots()
          .asyncMap<List<RoomModel>>((roomList) async {
        return Future.wait(roomList.docs.map((e) async {
          final roomModel = RoomModel.fromJson(e.data());
          for (String uid in roomModel.userList!) {
            final userModel = await getUserInfo(uid);
            roomModel.userInfoList?.add(userModel);
          }
          return roomModel;
        }).toList());
      });
    } catch (e, s) {
      if (kDebugMode) {
        print(
            "Exception coming in initializing chat list is ${e.toString()} ${s.toString()}");
      }
    }
  }

  Future<UserModel?> getUserInfo(String uid) async {
    final userCollectionRef =
        FirebaseHelper.fireStoreInstance!.collection("user");

    final docReference = await userCollectionRef.doc(uid).get();

    if (docReference.data() != null) {
      return UserModel.fromJson(docReference.data()!);
    }
  }
}
