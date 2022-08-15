import 'package:get/get.dart';

import '../helper/firebase_helper.dart';
import '../utils/util_functions.dart';

class ChatController extends GetxController {
  void sendMessage(String message,String senderUid,String receiverUid) async{
    try {
      final chatCollectionRef = FirebaseHelper.fireStoreInstance!.collection("chats");
      final roomId=UtilFunctions().getRoomId(senderUid,receiverUid);
      Map<String,dynamic> messageData={
        "receiverId":receiverUid,
        "senderId":senderUid,
        "timestamp":DateTime.now().millisecondsSinceEpoch.toString(),
        "messageText":message
      };
      await chatCollectionRef.doc(roomId).collection('messages').add(
        messageData
      );
    } catch (e) {

    }
  }
}
