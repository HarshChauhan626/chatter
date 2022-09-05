class LastSeenModel{
  String? uid;
  int? messageSeenAt;

  LastSeenModel({this.uid,this.messageSeenAt});

  LastSeenModel.fromJson(Map<String,dynamic> json){
    uid=json['uid'];
    messageSeenAt=int.parse(json["messageSeenAt"]);
  }

  Map<String,dynamic> toJson(){
    return {
      "uid":uid,
      "messageSeenAt":messageSeenAt
    };
  }

}