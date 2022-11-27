import 'package:chat_app/controllers/home_controller.dart';
import 'package:chat_app/utils/extensions.dart';
import 'package:chat_app/widgets/profile_picture_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';

import '../controllers/auth_controller.dart';
import '../models/room_model.dart';
import '../models/user_model.dart';
import '../screens/chat_screen.dart';
import '../utils/app_colors.dart';
import '../utils/util_functions.dart';

// class ChatListItem extends StatefulWidget {
//   RoomModel roomModel;
//   int index;
//
//   ChatListItem({Key? key, required this.roomModel, required this.index})
//       : super(key: key);
//
//   @override
//   State<ChatListItem> createState() => _ChatListItemState();
// }
//
// class _ChatListItemState extends State<ChatListItem> {
//   String profilePicture = '';
//   bool isSeen = false;
//   String messageContent = "";
//   UserModel? receiverModel;
//   String? userId;
//
//   bool isSelected = false;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     userId = Get.find<AuthController>().firebaseUser.value?.uid;
//     isSelected = Get.find<HomeController>()
//         .selectedChatIdList
//         .contains(widget.roomModel.roomId);
//
//     // final receiverModel=roomModel.userInfoList?.map((e) {
//     //   if(e.uid.toString()!=userId?.toString()){
//     //     return e;
//     //   }
//     // }).toList()[0];
//     messageContent = widget.roomModel.latestMessage?.content ?? "";
//     isSeen = widget.roomModel.latestMessage?.isSeenBy
//             ?.where((element) => element.uid == userId)
//             .isNotEmpty ??
//         true;
//     for (var element in widget.roomModel.userInfoList!) {
//       debugPrint("Element id coming is ${element.uid}");
//       if (element.uid.toString() != userId?.toString()) {
//         receiverModel = element;
//       }
//     }
//     profilePicture = receiverModel?.profilePicture ?? "";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Color tileColor =
//         isSelected ? AppColors.primaryColor.lighten(60) : AppColors.whiteColor;
//
//     return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 5.0),
//         child: ListTile(
//           // shape: RoundedRectangleBorder(
//           //     borderRadius: BorderRadius.circular(20.0)
//           // ),
//           onLongPress: () {
//             final selectedList = Get.find<HomeController>().selectedChatIdList;
//             if (selectedList.isEmpty) {
//               selectedList.add(widget.roomModel.roomId!);
//             } else {
//               selectedList.remove(widget.roomModel.roomId);
//             }
//             setState(() {
//               isSelected = selectedList.contains(widget.roomModel.roomId);
//             });
//           },
//           onTap: () {
//             final selectedList = Get.find<HomeController>().selectedChatIdList;
//             if (selectedList.isEmpty) {
//               Get.toNamed(ChatScreen.routeName, arguments: {
//                 "roomId": widget.roomModel.roomId,
//                 "receiverModel": receiverModel
//               });
//             } else {
//               if (selectedList.contains(widget.roomModel.roomId)) {
//                 selectedList.remove(widget.roomModel.roomId);
//               } else {
//                 if (widget.roomModel.roomId != null &&
//                     widget.roomModel.roomId!.isNotEmpty) {
//                   selectedList.add(widget.roomModel.roomId!);
//                 }
//               }
//             }
//             setState(() {
//               isSelected = selectedList.contains(widget.roomModel.roomId);
//             });
//           },
//           tileColor: tileColor,
//           leading: ProfilePictureAvatar(
//             profilePictureLink: profilePicture,
//             showCheckIcon: isSelected,
//             height: 50.0,
//             width: 52.0,
//           ),
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 receiverModel?.userName ?? "",
//                 style: Theme.of(context).textTheme.bodyText1?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.blackTextColor),
//               ),
//               Text(
//                   UtilFunctions().parseTimeStamp(
//                       widget.roomModel.latestMessage?.timestamp),
//                   style: Theme.of(context)
//                       .textTheme
//                       .subtitle2
//                       ?.copyWith(color: Colors.black54))
//             ],
//           ),
//           subtitle: Row(
//             children: [
//               Container(
//                 width: 65.w,
//                 child: Text(messageContent,
//                     style: Theme.of(context).textTheme.subtitle2?.copyWith(
//                         color:
//                             isSeen ? Colors.black54 : AppColors.blackTextColor,
//                         overflow: TextOverflow.ellipsis)),
//               )
//             ],
//           ),
//         ));
//   }
// }

class ChatListItem extends StatelessWidget {
  RoomModel roomModel;
  int index;

  ChatListItem({Key? key, required this.roomModel, required this.index})
      : super(key: key);

  String profilePicture = '';
  bool isSeen = false;
  String messageContent = "";
  UserModel? receiverModel;
  String? userId;

  bool isSelected = false;

  @override
  Widget build(BuildContext context) {

    setUpData();

    return Obx(() {
      bool isSelected = Get.find<HomeController>()
          .selectedChatIdList
          .contains(roomModel.roomId);

      // final receiverModel=roomModel.userInfoList?.map((e) {
      //   if(e.uid.toString()!=userId?.toString()){
      //     return e;
      //   }
      // }).toList()[0];
      Color tileColor = isSelected
          ? AppColors.primaryColor.lighten(60)
          : AppColors.whiteColor;

      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 5.0),
          child: ListTile(
            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(20.0)
            // ),
            onLongPress: () {
              final selectedList =
                  Get.find<HomeController>().selectedChatIdList;
              if (selectedList.isEmpty) {
                selectedList.add(roomModel.roomId!);
              } else {
                selectedList.remove(roomModel.roomId);
              }
              // setState(() {
              //   isSelected = selectedList.contains(roomModel.roomId);
              // });
            },
            onTap: () {
              final selectedList =
                  Get.find<HomeController>().selectedChatIdList;
              if (selectedList.isEmpty) {
                Get.toNamed(ChatScreen.routeName, arguments: {
                  "roomId": roomModel.roomId,
                  "receiverModel": receiverModel
                });
              } else {
                if (selectedList.contains(roomModel.roomId)) {
                  selectedList.remove(roomModel.roomId);
                } else {
                  if (roomModel.roomId != null &&
                      roomModel.roomId!.isNotEmpty) {
                    selectedList.add(roomModel.roomId!);
                  }
                }
              }
              // setState(() {
              //   isSelected = selectedList.contains(roomModel.roomId);
              // });
            },
            tileColor: tileColor,
            leading: ProfilePictureAvatar(
              profilePictureLink: profilePicture,
              showCheckIcon: isSelected,
              height: 50.0,
              width: 52.0,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  receiverModel?.userName ?? "",
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackTextColor),
                ),
                Text(
                    UtilFunctions
                        .parseTimeStamp(roomModel.latestMessage?.timestamp),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        ?.copyWith(color: Colors.black54))
              ],
            ),
            subtitle: Row(
              children: [
                Container(
                  width: 65.w,
                  child: Text(messageContent,
                      style: Theme.of(context).textTheme.subtitle2?.copyWith(
                          color: isSeen
                              ? Colors.black54
                              : AppColors.blackTextColor,
                          overflow: TextOverflow.ellipsis)),
                )
              ],
            ),
          ));
    });
  }


  void setUpData(){
    userId = Get.find<AuthController>().firebaseUser.value?.uid;

    messageContent = roomModel.latestMessage?.content ?? "";
    isSeen = roomModel.latestMessage?.isSeenBy
        ?.where((element) => element.uid == userId)
        .isNotEmpty ??
        true;
    for (var element in roomModel.userInfoList!) {
      debugPrint("Element id coming is ${element.uid}");
      if (element.uid.toString() != userId?.toString()) {
        receiverModel = element;
      }
    }
    profilePicture = receiverModel?.profilePicture ?? "";
  }

}
