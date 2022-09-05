import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../helper/firebase_helper.dart';
import '../models/user_model.dart';

class UtilFunctions {
  String getRoomId(String senderId, String recieverId) {
    return senderId + '-' + recieverId;
  }

  String parseTimeStamp(int? value) {
    try {
      if (value != null) {
        var date = DateTime.fromMillisecondsSinceEpoch(value);
        var d12 = DateFormat('hh:mm a').format(date);
        return d12;
      }
      return "";
    } catch (e, s) {
      debugPrint(
          "Exception coming in parseTimeStamp is ${e.toString()} ${s.toString()}");
      return "";
    }
  }

  Future<UserModel?> getUserInfo(String userId) async {
    try {
      final userCollectionRef =
          FirebaseHelper.fireStoreInstance!.collection("user");

      final result = await userCollectionRef.doc(userId).get();

      if (!result.exists && result.data() == null) {
        null;
      }
      return UserModel.fromJson(result.data()!);
    } catch (e, s) {
      debugPrint(
          "Exception coming in fetching userModel is ${e.toString()}\n${s.toString()}");
    }
  }
}
