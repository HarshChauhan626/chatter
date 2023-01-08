class UserModel {
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
  String? deviceToken;
  Map<String, dynamic>? publicKey;

  UserModel(
      {this.email,
      this.userName,
      this.password,
      this.uid,
      this.lastSeenAt,
      this.isOnline,
      this.firstName,
      this.lastName,
      this.bio,
      this.profilePicture,
      this.deviceToken,
      this.publicKey});

  UserModel.fromJson(Map<String, dynamic> userModelJson) {
    email = userModelJson["email"] ?? "";
    userName = userModelJson["userName"] ?? "";
    uid = userModelJson["uid"] ?? "";
    password = userModelJson["password"] ?? "";
    lastSeenAt = userModelJson["lastSeenAt"] ?? "";
    isOnline = userModelJson["isOnline"] ?? false;
    bio = userModelJson["bio"] ?? "";
    firstName = userModelJson["firstName"] ?? "";
    lastName = userModelJson["lastName"] ?? "";
    profilePicture = userModelJson["profilePicture"] ?? "";
    deviceToken = userModelJson["deviceToken"];
    publicKey = userModelJson["publicKey"];
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "userName": userName,
      "password": password,
      "uid": uid,
      "bio": bio,
      "firstName": firstName,
      "lastName": lastName,
      "isOnline": isOnline,
      "lastSeenAt": lastSeenAt,
      "profilePicture": profilePicture,
      "deviceToken": deviceToken,
      "publicKey": publicKey
    };
  }

  UserModel copyWith(
      {String? email,
      String? userName,
      String? password,
      String? uid,
      String? lastSeenAt,
      bool? isOnline,
      String? bio,
      String? firstName,
      String? lastName,
      String? profilePicture,
      Map<String, dynamic>? publicKey}) {
    return UserModel(
        email: email ?? this.email,
        userName: userName ?? this.userName,
        password: password ?? this.password,
        uid: uid ?? this.uid,
        lastSeenAt: lastSeenAt ?? this.lastSeenAt,
        isOnline: isOnline ?? this.isOnline,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        bio: bio ?? this.bio,
        profilePicture: profilePicture ?? this.profilePicture,
        publicKey: publicKey ?? this.publicKey);
  }
}
