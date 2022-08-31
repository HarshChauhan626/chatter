import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../helper/firebase_helper.dart';
import '../models/group_model.dart';

class ChatController extends GetxController {
  String? user1Id;
  String? user2Id;
  String? roomId;

  RxList messages=[].obs;
  Rx<GroupModel>? groupModel;

  void sendMessage(String message) async {
    try {
      final chatCollectionRef =
          FirebaseHelper.fireStoreInstance!.collection("chats");


      final dateTimeNow = DateTime.now().millisecondsSinceEpoch.toString();

      final messageData={
        "content": message,
        "sender": user1Id,
        "timestamp": dateTimeNow,
        "contentType": "Text",
        "replyTo": "", // Message Id
        "isLikedBy": []
      };

      if (roomId == null) {
        final uniqueRoomId = const Uuid().v1();
        final groupDocReference = chatCollectionRef.doc(uniqueRoomId);
        await groupDocReference.set({
          "userList": [user1Id, user2Id],
          "isTyping": [],
          "adminList": []
        });
        await groupDocReference.collection(uniqueRoomId).doc(dateTimeNow).set(messageData);
      } else {
        final groupDocReference = chatCollectionRef.doc(roomId);
        groupDocReference.collection(roomId!).doc(dateTimeNow).update(messageData);
      }
    } catch (e) {
      debugPrint(e.toString());
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
