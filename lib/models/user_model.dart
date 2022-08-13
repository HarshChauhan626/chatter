class UserModel{
  String? email;
  String? userName;
  String? password;
  UserModel({this.email,this.userName,this.password});


  UserModel.fromJson(Map<String,dynamic> userModelJson){
    email=userModelJson["email"];
    userName=userModelJson["userName"];
    password=userModelJson["password"];
  }

  Map<String,dynamic> toJson(){
    return {
      "email":email,
      "userName":userName,
      "password":password
    };
  }

}