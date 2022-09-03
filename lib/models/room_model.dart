import 'message_model.dart';

class RoomModel{
  List<dynamic>? userList;
  List<dynamic>? isTyping;
  List<dynamic>? adminList;
  MessageModel? latestMessage;

  RoomModel({this.userList,this.isTyping,this.adminList,this.latestMessage});

  RoomModel.fromJson(Map<String,dynamic> json){
      userList=json["userList"]??[];
      isTyping= json["isTyping"]??[];
      adminList=json["adminList"]??[];
      latestMessage=json["latestMessage"]!=null?MessageModel.fromJson(json["latestMessage"]):null;
  }

  Map<String,dynamic> toJson(){
    return {
      "userList":userList,
      "isTyping":isTyping,
      "adminList":adminList,
      "latestMessage":latestMessage
    };
  }


}