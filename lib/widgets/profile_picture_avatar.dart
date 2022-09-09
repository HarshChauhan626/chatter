import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

class ProfilePictureAvatar extends StatelessWidget {

  String profilePictureLink;
  double? height;
  double? width;

  ProfilePictureAvatar({Key? key,required this.profilePictureLink,this.height,this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(profilePictureLink.isNotEmpty){
      return CircleAvatar(
        backgroundImage: NetworkImage(profilePictureLink,
        ),
      );
    }

    return randomAvatar(
      "Harsh",
      height: height??40,
      width: width??40,
    );
  }
}
