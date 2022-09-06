import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:random_avatar/random_avatar.dart';

import '../utils/app_strings.dart';
import '../utils/asset_strings.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/custom_alert_body.dart';
import '../widgets/custom_safe_area.dart';


class ProfilePictureScreen extends StatelessWidget {

  static String routeName="/profile_picture_screen";


  const ProfilePictureScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back,color: Colors.black,),
            onPressed: (){
              Get.back();
            },
          ),
          centerTitle: false,
          title: const Text("Profile photo"),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit,color: Colors.black,),
              onPressed: (){

              },
            ),
            IconButton(
              icon: const Icon(Icons.share,color: Colors.black,),
              onPressed: (){

              },
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: double.infinity,
            ),
            Container(
              child: Hero(
                tag: "ProfilePictureTag",
                child: randomAvatar(
                  "Harsh",
                  height: 300,
                  width: double.infinity,
                  trBackground: true
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}








