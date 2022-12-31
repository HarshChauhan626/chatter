import 'package:chat_app/models/room_model.dart';
import 'package:chat_app/utils/util_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

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

      final chatListStream = chatCollectionRef
          .where("userList", arrayContains: senderId)
          .snapshots();

      chatListStream.listen((event) {
        print("Event ${event.docs.toList().map((e) => e.data()).toList()}");
      });

      chatList = chatListStream.asyncMap<List<RoomModel>>((roomList) async {
        return Future.wait(roomList.docs.map((e) async {
          RoomModel? roomModel;
          try {
            final roomModel = RoomModel.fromJson(e.data());
            for (String uid in roomModel.userList!) {
              final userModel = await getUserInfo(uid);
              roomModel.userInfoList?.add(userModel);
            }
            return roomModel;
          } catch (e, s) {
            print("Exception $e");
            print("Stacktrace $s");
          }
          return RoomModel();
        }).toList());
      });
    } catch (e, s) {
      if (kDebugMode) {
        print(
            "Exception coming in initializing chat list is ${e.toString()} ${s.toString()}");
      }
    }
  }

  Future<void> pinChat(String roomId) async {
    try {
      final chatCollectionRef =
          FirebaseHelper.fireStoreInstance!.collection("chats");

      senderId = Get.find<AuthController>().firebaseUser.value?.uid;

      final roomRef = await chatCollectionRef.doc(roomId).get();

      final pinnedByList = roomRef.get("pinnedByList");

      if (pinnedByList != null && senderId != null) {
        // pinnedByList as List<String>;
        if (pinnedByList.contains(senderId)) {
          pinnedByList.remove(senderId);
        } else {
          pinnedByList.add(senderId!);
        }
        chatCollectionRef.doc(roomId).update({"pinnedByList": pinnedByList});
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }

  Future<void> deleteConversations({bool? isDeleteForAll}) async {
    for (int i = 0; i < selectedChatIdList.length; i++) {
      await deleteConversation(selectedChatIdList[i],
          isDeleteForAll: isDeleteForAll);
    }
    selectedChatIdList.clear();
  }

  Future<void> deleteConversation(String roomId, {bool? isDeleteForAll}) async {
    try {
      final chatCollectionRef =
          FirebaseHelper.fireStoreInstance!.collection("chats");

      final roomRef = chatCollectionRef.doc(roomId);

      final roomRefData = await roomRef.get();

      final deletedByList = await roomRefData.get("deletedBy");

      final userIdList = await roomRefData.get("userList");

      if (isDeleteForAll != null) {
        roomRef.delete();
        return;
      }

      if (deletedByList != null &&
          deletedByList != null &&
          userIdList != null) {
        // pinnedByList as List<String>;
        if (UtilFunctions.listsContainSameElements(userIdList, deletedByList)) {
          roomRef.delete();
          return;
        }

        if (deletedByList.contains(senderId ?? "")) {
          deletedByList.remove(senderId ?? "");
        } else {
          deletedByList.add(senderId ?? "");
        }
        roomRef.update({"deletedBy": deletedByList});
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
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
