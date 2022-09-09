class UserModel{
  String? email;
  String? userName;
  String? password;
  String? uid;
  String? lastSeenAt;
  bool? isOnline;
  String? bio;
  String? firstName;
  String? lastName;
  String? profilePicture;
  UserModel({this.email,this.userName,this.password,this.uid,this.lastSeenAt,this.isOnline,this.firstName,this.lastName,this.bio,this.profilePicture});


  UserModel.fromJson(Map<String,dynamic> userModelJson){
    email=userModelJson["email"]??"";
    userName=userModelJson["userName"]??"";
    uid=userModelJson["uid"]??"";
    password=userModelJson["password"]??"";
    lastSeenAt=userModelJson["lastSeenAt"]??"";
    isOnline=userModelJson["isOnline"]??false;
    bio=userModelJson["bio"]??"";
    firstName=userModelJson["firstName"]??"";
    lastName=userModelJson["lastName"]??"";
    profilePicture=userModelJson["profilePicture"];
  }

  Map<String,dynamic> toJson(){
    return {
      "email":email,
      "userName":userName,
      "password":password,
      "uid":uid,
      "bio":bio,
      "firstName":firstName,
      "lastName":lastName,
      "isOnline":isOnline,
      "lastSeenAt":lastSeenAt,
      "profilePicture":profilePicture
    };
  }

}