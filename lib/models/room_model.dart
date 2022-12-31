import 'message_model.dart';

class RoomModel {
  String? roomId;
  List<dynamic>? userList;
  List<dynamic>? isTyping;
  List<dynamic>? adminList;
  MessageModel? latestMessage;
  List<dynamic>? userInfoList;
  List<dynamic>? pinnedByList;
  List<dynamic>? deletedByList;

  RoomModel(
      {this.roomId,
      this.userList,
      this.isTyping,
      this.adminList,
      this.latestMessage,
      this.userInfoList,
      this.pinnedByList,this.deletedByList});

  RoomModel.fromJson(Map<String, dynamic> json) {
    roomId = json["roomId"] ?? "";
    userList = json["userList"] ?? [];
    isTyping = json["isTyping"] ?? [];
    adminList = json["adminList"] ?? [];
    latestMessage = json["latestMessage"] != null
        ? MessageModel.fromJson(json["latestMessage"])
        : null;
    userInfoList = json["userInfoList"] ?? [];
    pinnedByList = json["pinnedBy"] ?? [];
    deletedByList=json["deletedBy"]??[];
  }

  Map<String, dynamic> toJson() {
    return {
      "userList": userList,
      "isTyping": isTyping,
      "adminList": adminList,
      "latestMessage": latestMessage,
      "userInfoList": userInfoList,
      "pinnedBy": pinnedByList,
      "deletedBy":deletedByList
    };
  }

  bool isDeleted(String userId){
    if(deletedByList!=null && deletedByList!.contains(userId)){
      return true;
    }
    return false;
  }



}
