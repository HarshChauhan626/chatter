class UserModel{
  String? email;
  String? userName;
  String? password;
  String? uid;
  UserModel({this.email,this.userName,this.password,this.uid});


  UserModel.fromJson(Map<String,dynamic> userModelJson){
    email=userModelJson["email"]??"";
    userName=userModelJson["userName"]??"";
    uid=userModelJson["uid"]??"";
    password=userModelJson["password"]??"";
  }

  Map<String,dynamic> toJson(){
    return {
      "email":email,
      "userName":userName,
      "password":password,
      "uid":uid
    };
  }

}