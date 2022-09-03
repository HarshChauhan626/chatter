import 'package:chat_app/utils/util_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
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

  RxBool showChat=false.obs;

  TextEditingController messageFieldController = TextEditingController();

  RxString message = "".obs;

  UserModel? receiverModel;

  RxBool isTyping = false.obs;

  Rx<RoomModel>? roomModel;

  Stream? dataList;

  @override
  void onInit() {
    super.onInit();
    debugPrint("debugPrinting userModel");
    debugPrint(Get.arguments['receiverModel'].toString());
    debugPrint(Get.arguments['receiverModel'].runtimeType.toString());
    final userModel = Get.arguments['receiverModel'] as UserModel;
    receiverModel = userModel;
    roomId.value = Get.arguments['roomId'] ?? "";

    debugPrint("Room id coming is ${roomId.value}");
    user1Id = Get.find<AuthController>().firebaseUser.value?.uid;
    debugPrint("Sender id coming is $user1Id");
    if(roomId.value.isNotEmpty){
      getChatStream();
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

      final userCollectionReference=FirebaseHelper.fireStoreInstance!.collection("users");


      final dateTimeNow = DateTime.now().millisecondsSinceEpoch.toString();

      final messageData = {
        "content": message.value,
        "sender": user1Id,
        "timestamp": dateTimeNow,
        "contentType": "Text",
        "replyTo": "", // Message Id
        "isLikedBy": []
      };

      if (roomId.value.isEmpty) {
        final uniqueRoomId = const Uuid().v1();
        roomId.value = uniqueRoomId;
        final groupDocReference = chatCollectionRef.doc(uniqueRoomId);

        UserModel? senderUserInfo;

        if(user1Id!=null){
          senderUserInfo=await UtilFunctions().getUserInfo(user1Id!);
        }


        await groupDocReference.set({
          "roomId":roomId.value,
          "userList": [user1Id, receiverModel?.uid],
          "isTyping": [],
          "adminList": [],
          "latestMessage":messageData,
          "userInfoList":[
            // senderUserInfo?.toJson(),
            receiverModel?.toJson()
          ]
        });
        await groupDocReference
            .collection(uniqueRoomId)
            .doc(dateTimeNow)
            .set(messageData);
        getChatStream();
      } else {
        final groupDocReference = chatCollectionRef.doc(roomId.value);
        await groupDocReference.update({"latestMessage":messageData});
        groupDocReference
            .collection(roomId.value)
            .doc(dateTimeNow)
            .set(messageData);
      }
    } catch (e,s) {
      debugPrint("Exception coming in sending message is ${e.toString()} ${s.toString()}");
    }

    messageFieldController.clear();
    message.value = "";
  }

  Future<void> getChatStream() async {
    try {
      final chatCollectionRef =
          FirebaseHelper.fireStoreInstance!.collection("chats");

      final groupDocReference = chatCollectionRef.doc(roomId.value);

      dataList = groupDocReference
          .collection(roomId.value)
          .orderBy("timestamp")
          .snapshots();

      showChat.value=true;
    } catch (e, s) {
      showChat.value=false;
      debugPrint(
          "Exception coming in getting chat list is ${e.toString()} ${s.toString()}");
    }
  }
}

/*     users:[
user1:dsfad,
user2:sdfa,
],
          'isGroup':false,
          'admin':[
          dsfad,
          sdfa
          ],
          messages:[
          {
          content:"",
          sender:"",
          timestamp:"",
          contentType:"",
          replyTo:"messageId",
          isLikedBy:[

          ],
          }
          ],
          'isTyping':[
          "user1":true,
          "user2":false
          ]
                              */
