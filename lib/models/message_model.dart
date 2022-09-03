class MessageModel {
  String? content;
  String? senderId;
  int? timestamp;
  String? contentType;
  String? replyTo;
  List<dynamic>? isLikedBy;

  MessageModel(
      {this.content,
      this.senderId,
      this.timestamp,
      this.contentType,
      this.replyTo,
      this.isLikedBy});

  MessageModel.fromJson(Map<String, dynamic> data) {
    content = data["content"];
    senderId = data["sender"];
    timestamp = int.parse(data["timestamp"]);
    contentType = data["contentType"];
    replyTo = data["replyTo"];
    isLikedBy = data["isLikedBy"];
  }

  Map<String,dynamic> toJson(){
    return {
      "content":content,
      "senderId":senderId,
      "timestamp":timestamp,
      "contentType":contentType,
      "replyTo":replyTo,
      "isLikedBy":isLikedBy
    };
  }



}