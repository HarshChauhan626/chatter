import 'package:chat_app/models/user_model.dart';

import 'message_model.dart';

class RoomModel {
  List<dynamic>? userList;
  List<dynamic>? isTyping;
  List<dynamic>? adminList;
  MessageModel? latestMessage;
  List<UserModel>? userInfoList;

  RoomModel(
      {this.userList,
      this.isTyping,
      this.adminList,
      this.latestMessage,
      this.userInfoList});

  RoomModel.fromJson(Map<String, dynamic> json) {
    userList = json["userList"] ?? [];
    isTyping = json["isTyping"] ?? [];
    adminList = json["adminList"] ?? [];
    latestMessage = json["latestMessage"] != null
        ? MessageModel.fromJson(json["latestMessage"])
        : null;
    userInfoList = json["userInfoList"] != null
        ? json["userInfoList"].map((e) => UserModel.fromJson(e)).toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      "userList": userList,
      "isTyping": isTyping,
      "adminList": adminList,
      "latestMessage": latestMessage,
      "userInfoList":userInfoList?.map((e) => e.toJson()).toList()
    };
  }
}
