import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helper/firebase_helper.dart';
import '../models/user_model.dart';
import 'app_colors.dart';

class UtilFunctions {
  static String getRoomId(String senderId, String recieverId) {
    return senderId + '-' + recieverId;
  }

  static String parseTimeStamp(int? value) {
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

  static Future<UserModel?> getUserInfo(String userId) async {
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

  static List<TextSpan> highlightOccurrences(String source, String query,bool isSender) {

    Color textColor=isSender?AppColors.whiteColor:AppColors.blackTextColor;

    if (query.isEmpty || !source.toLowerCase().contains(query.toLowerCase())) {
      return [ TextSpan(text: source,style: TextStyle(color: textColor)) ];
    }
    final matches = query.toLowerCase().allMatches(source.toLowerCase());

    int lastMatchEnd = 0;

    final List<TextSpan> children = [];
    for (var i = 0; i < matches.length; i++) {
      final match = matches.elementAt(i);

      if (match.start != lastMatchEnd) {
        print(
            source.substring(lastMatchEnd, match.start));
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.start),
          style: TextStyle(
            color: textColor,
            fontSize: 15
          )
        ));
      }

      children.add(TextSpan(
        text: source.substring(match.start, match.end),
        style: TextStyle(color: AppColors.blackTextColor,background: Paint()..color=Colors.yellow,fontSize: 15),
      ));

      if (i == matches.length - 1 && match.end != source.length) {
        children.add(TextSpan(
          text: source.substring(match.end, source.length),
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor,fontSize: 15
            )
        ));
      }

      lastMatchEnd = match.end;
    }
    return children;
  }

}