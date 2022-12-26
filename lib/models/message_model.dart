import 'last_seen_model.dart';

class MessageModel {
  String? content;
  String? senderId;
  int? timestamp;
  String? contentType;
  String? replyTo;
  List<dynamic>? isLikedBy;
  List<LastSeenModel>? isSeenBy;

  MessageModel(
      {this.content,
      this.senderId,
      this.timestamp,
      this.contentType,
      this.replyTo,
      this.isLikedBy,
      this.isSeenBy});

  MessageModel.fromJson(Map<String, dynamic> data) {
    content = data["content"];
    senderId = data["sender"];
    timestamp = data["timestamp"] != null
        ? int.parse(data["timestamp"])
        : data["timestamp"];
    contentType = data["contentType"];
    replyTo = data["replyTo"];
    isLikedBy = data["isLikedBy"];
    if (data['isSeenBy'] != null) {
      isSeenBy = <LastSeenModel>[];
      data['isSeenBy'].forEach((v) {
        isSeenBy!.add(LastSeenModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "content": content,
      "senderId": senderId,
      "timestamp": timestamp,
      "contentType": contentType,
      "replyTo": replyTo,
      "isLikedBy": isLikedBy,
      "isSeenBy": isSeenBy
    };
  }
}
