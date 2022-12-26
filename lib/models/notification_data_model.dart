import 'dart:convert';

import 'package:chat_app/models/user_model.dart';

class NotificationDataModel {
  UserModel? receiverModel;
  String? roomId;

  NotificationDataModel(this.receiverModel, this.roomId);

  NotificationDataModel.fromJson(Map<String, dynamic> jsonMap) {
    receiverModel = UserModel.fromJson(jsonDecode(jsonMap["receiverModel"]));
    roomId = jsonMap["roomId"];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "receiverModel": receiverModel?.toJson(),
      "roomId": roomId
    };
  }
}
