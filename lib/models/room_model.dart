import 'package:chat_app/models/user_model.dart';

import 'message_model.dart';

class RoomModel {
  String? roomId;
  List<dynamic>? userList;
  List<dynamic>? isTyping;
  List<dynamic>? adminList;
  MessageModel? latestMessage;
  List<dynamic>? userInfoList;

  RoomModel(
      {this.roomId,
      this.userList,
      this.isTyping,
      this.adminList,
      this.latestMessage,
      this.userInfoList
      });

  RoomModel.fromJson(Map<String, dynamic> json) {
    roomId = json["roomId"] ?? "";
    userList = json["userList"] ?? [];
    isTyping = json["isTyping"] ?? [];
    adminList = json["adminList"] ?? [];
    latestMessage = json["latestMessage"] != null
        ? MessageModel.fromJson(json["latestMessage"])
        : null;
    userInfoList = json["userInfoList"] ?? [];
  }

  Map<String, dynamic> toJson() {
    return {
      "userList": userList,
      "isTyping": isTyping,
      "adminList": adminList,
      "latestMessage": latestMessage,
      "userInfoList": userInfoList
    };
  }
}

class RoomEntity {
  String? roomId;
  List<dynamic>? userList;
  List<dynamic>? isTyping;
  List<dynamic>? adminList;
  MessageModel? latestMessage;
  List<UserModel>? userInfoList;
}
