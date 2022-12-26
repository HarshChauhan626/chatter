import 'package:chat_app/helper/hive_db_helper.dart';
import 'package:chat_app/helper/notification_helper.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/utils/util_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../helper/firebase_helper.dart';
import '../models/room_model.dart';
import '../models/user_model.dart';
import 'auth_controller.dart';

class ChatController extends GetxController {
  String? user1Id;
  String? user2Id;

  // final roomId=Rxn<String>();

  RxString roomId = "".obs;

  RxList messages = [].obs;

  RxBool showChat = false.obs;

  TextEditingController messageFieldController = TextEditingController();

  ScrollController scrollController = ScrollController();

  RxString message = "".obs;

  UserModel? receiverModel;

  RxBool isTyping = false.obs;

  RxBool isUserOnlineVal = false.obs;

  Rx<RoomModel>? roomModel;

  Stream? dataList;

  RxBool searchButtonTapped = false.obs;

  RxString searchText = "".obs;

  RxList<int> searchResultList = <int>[].obs;

  TextEditingController searchTextController = TextEditingController();

  RxList<MessageModel> messageList = <MessageModel>[].obs;

  RxInt currentIndex = 0.obs;
  RxInt scrollPosition = 0.obs;

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    Get.find<HiveDBHelper>().currentChatId = null;
    super.onClose();
  }

  void toggleUserActiveStatus() async {
    try {
      final chatCollectionRef =
          FirebaseHelper.fireStoreInstance!.collection("chats");

      final groupDocReference = chatCollectionRef.doc(roomId.value);

      final groupData = await groupDocReference.get();

      groupData.data()?.update(
          "activeUsers",
          (value) => [
                {user1Id: true},
                {user2Id: true}
              ]);
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }

  void initData() async {
    debugPrint("debugPrinting userModel");
    debugPrint(Get.arguments['receiverModel'].toString());
    debugPrint(Get.arguments['receiverModel'].runtimeType.toString());
    final userModel = Get.arguments['receiverModel'] as UserModel;
    receiverModel = userModel;
    roomId.value = Get.arguments['roomId'] ?? "";

    debugPrint("Room id coming is ${roomId.value}");
    user1Id = Get.find<AuthController>().firebaseUser.value?.uid;
    debugPrint("Sender id coming is $user1Id");
    if (roomId.value.isNotEmpty) {
      getChatStream();
    }

    if (receiverModel != null) {
      isUserOnline();
    }

    Get.find<HiveDBHelper>().currentChatId = roomId.value;
  }

  Future<void> isUserOnline() async {
    try {
      final userCollectionRef =
          FirebaseHelper.fireStoreInstance!.collection("user");

      final userDocStream =
          userCollectionRef.doc(receiverModel?.uid).snapshots();

      userDocStream.listen((event) {
        debugPrint(event.toString());
      });
    } catch (e, s) {
      debugPrint(
          "Exception coming in getting user active status ${e.toString()} ${s.toString()}");
    }
  }

  void getIsTypingStream() async {
    try {
      final chatCollectionRef =
          FirebaseHelper.fireStoreInstance!.collection("chats");

      chatCollectionRef.snapshots().listen((QuerySnapshot querySnapshot) {
        for (var element in querySnapshot.docs) {
          final roomData = element.data();
          debugPrint("Room data coming is${roomData.toString()}");
        }
      });
    } catch (e) {
      isTyping.value = false;
    }
  }

  void sendMessage() async {
    try {
      final chatCollectionRef =
          FirebaseHelper.fireStoreInstance!.collection("chats");

      final userCollectionReference =
          FirebaseHelper.fireStoreInstance!.collection("users");

      final dateTimeNow = DateTime.now().millisecondsSinceEpoch.toString();

      UserModel? senderUserInfo;

      if (user1Id != null) {
        senderUserInfo = await UtilFunctions.getUserInfo(user1Id!);
      }

      final messageData = {
        "content": message.value,
        "sender": user1Id,
        "timestamp": dateTimeNow,
        "contentType": "Text",
        "replyTo": "", // Message Id
        "isLikedBy": [],
        "isSeenBy": [
          {"uid": "$user1Id", "messageSeenAt": dateTimeNow}
        ],
      };

      if (roomId.value.isEmpty) {
        final uniqueRoomId = const Uuid().v1();
        roomId.value = uniqueRoomId;
        final groupDocReference = chatCollectionRef.doc(uniqueRoomId);
        await groupDocReference.set({
          "roomId": roomId.value,
          "userList": [user1Id, receiverModel?.uid],
          "pinnedByList": [],
          "isTyping": [],
          "latestMessage": messageData,
        });
        await groupDocReference
            .collection(uniqueRoomId)
            .doc(dateTimeNow)
            .set(messageData);
        getChatStream();
      } else {
        final groupDocReference = chatCollectionRef.doc(roomId.value);
        await groupDocReference.update({"latestMessage": messageData});
        groupDocReference
            .collection(roomId.value)
            .doc(dateTimeNow)
            .set(messageData);
      }
      if (receiverModel != null &&
          roomId.value.isNotEmpty &&
          receiverModel?.deviceToken != null &&
          (receiverModel?.deviceToken!.isNotEmpty ?? false) &&
          senderUserInfo != null) {
        await NotificationHelper.sendNotification(
            receiverModel!, roomId.value, message.value, senderUserInfo);
      }
    } catch (e, s) {
      debugPrint(
          "Exception coming in sending message is ${e.toString()} ${s.toString()}");
    }

    messageFieldController.clear();
    message.value = "";
  }

  Future<void> getChatStream() async {
    try {
      final chatCollectionRef =
          FirebaseHelper.fireStoreInstance!.collection("chats");

      final groupDocReference = chatCollectionRef.doc(roomId.value);

      final groupData = await groupDocReference.get();

      if (groupData.exists) {
        bool isAlreadySeen = false;
        final groupDataMap = groupData.data();
        final isSeenByList = groupDataMap!["latestMessage"]["isSeenBy"];
        for (int i = 0; i < isSeenByList.length; i++) {
          if (isSeenByList[i]["uid"] == user1Id) {
            isAlreadySeen = true;
            break;
          }
        }
        if (!isAlreadySeen) {
          groupDataMap["latestMessage"]["isSeenBy"].add({
            "uid": user1Id,
            "messageSeenAt": DateTime.now().millisecondsSinceEpoch.toString()
          });
        }
        groupDocReference
            .update({"latestMessage": groupDataMap["latestMessage"]});
      }

      dataList = groupDocReference
          .collection(roomId.value)
          .orderBy("timestamp")
          .snapshots();

      showChat.value = true;
    } catch (e, s) {
      showChat.value = false;
      debugPrint(
          "Exception coming in getting chat list is ${e.toString()} ${s.toString()}");
    }
  }

  Future<void> searchMessages() async {
    final set = <int>{};
    for (int index = 0; index < messageList.value.length; index++) {
      final message = messageList[index];
      if (message.content
              ?.toLowerCase()
              .contains(searchText.value.toLowerCase()) ??
          false) {
        set.add(index);
      }
    }

    searchResultList.value = set.toList();

    if (searchResultList.isNotEmpty) {
      currentIndex.value = 0;
    }
  }
}
