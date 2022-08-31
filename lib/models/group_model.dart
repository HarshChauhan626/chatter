class GroupModel{
  List<String>? userList;
  List<String>? isTyping;
  List<String>? adminList;

  GroupModel({this.userList,this.isTyping,this.adminList});

  GroupModel.fromJson(Map<String,dynamic> json){
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