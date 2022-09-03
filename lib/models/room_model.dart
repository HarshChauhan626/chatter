class RoomModel{
  List<dynamic>? userList;
  List<dynamic>? isTyping;
  List<dynamic>? adminList;

  RoomModel({this.userList,this.isTyping,this.adminList});

  RoomModel.fromJson(Map<String,dynamic> json){
      userList=json["userList"]??[];
      isTyping= json["isTyping"]??[];
      adminList=json["adminList"]??[];
  }

  Map<String,dynamic> toJson(){
    return {
      "userList":userList,
      "isTyping":isTyping,
      "adminList":adminList
    };
  }


}