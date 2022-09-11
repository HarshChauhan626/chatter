import 'package:chat_app/controllers/auth_controller.dart';
import 'package:chat_app/controllers/chat_controller.dart';
import 'package:chat_app/screens/receiver_profile_screen.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/widgets/custom_route_builder.dart';
import 'package:chat_app/widgets/custom_safe_area.dart';
import 'package:chat_app/widgets/profile_picture_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:sizer/sizer.dart';
import 'package:chat_app/utils/extensions.dart';
import 'package:uuid/uuid.dart';
import '../helper/firebase_helper.dart';
import '../models/message_model.dart';
import '../utils/app_strings.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({Key? key}) : super(key: key);
//
//   static const String routeName = '/chat';
//
//   static Route route() {
//     // return MaterialPageRoute(
//     //     settings: const RouteSettings(name: routeName),
//     //     builder: (_) =>const ChatScreen()
//     // );
//     return CustomRouteBuilder(page: const ChatScreen(), routeName: routeName);
//   }
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  static const String routeName = '/chat';

  static Route route() {
    // return MaterialPageRoute(
    //     settings: const RouteSettings(name: routeName),
    //     builder: (_) =>const ChatScreen()
    // );
    return CustomRouteBuilder(page: ChatScreen(), routeName: routeName);
  }

  TextEditingController inputMessageController = TextEditingController();

  ChatController controller = Get.find<ChatController>();

  List<String> messageList = [
    for (int i = 0; i < 100; i++) "My message $i",
  ];

  void callEmoji() {
    debugPrint('Emoji Icon Pressed...');
  }

  void callAttachFile() {
    debugPrint('Attach File Icon Pressed...');
  }

  void callCamera() {
    debugPrint('Camera Icon Pressed...');
  }

  void callVoice() {
    debugPrint('Voice Icon Pressed...');
  }

  void callSendMessage() {
    controller.sendMessage();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColors.whiteColor,
        appBar: getAppBar(context),
        body: getBody(),
        bottomNavigationBar: getInputField(context),
      ),
    );
  }

  PreferredSizeWidget getAppBar(BuildContext context) {
    final chatController = Get.find<ChatController>();

    final receiverModel=chatController.receiverModel;

    debugPrint("Username coming is ${chatController.receiverModel}");

    final receiverProfilePicture=receiverModel?.profilePicture??"";

    return PreferredSize(
      preferredSize: Size(double.infinity, 8.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          // borderRadius: BorderRadius.only(
          //     bottomRight: Radius.circular(4.w),
          //     bottomLeft: Radius.circular(4.w)
          // ),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 2),
                blurRadius: 3,
                color: Colors.grey.shade300),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(CupertinoIcons.back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            InkWell(
                child: Hero(tag: "ReceiverProfilePicture", child: ProfilePictureAvatar(profilePictureLink: receiverProfilePicture)),
              onTap: (){
                  Get.toNamed(ReceiverProfileScreen.routeName);
              },
            ),
            const SizedBox(
              width: 8.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  chatController.receiverModel?.userName ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Obx(() => controller.isUserOnlineVal.value?Text(
                  AppStrings.activeNow,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.green),
                ):const SizedBox())
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget getBody() {
    return Obx(() => controller.showChat.value?getMessageList():const SizedBox());
  }

  Widget getMessageList() {
    return SizedBox(
      height: 89.h,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: StreamBuilder(
          stream: controller.dataList,
          builder: (context, snapshot) {

            print("Connection state coming is ${snapshot.connectionState}");

            print(snapshot.hasData);

            print(snapshot.hasData);

            if(snapshot.hasData && snapshot.connectionState==ConnectionState.active){

              final chatList=snapshot.data as QuerySnapshot;


              final list=chatList.docs.map((e){
                print("Message data coming is ${e.data()}");
                return MessageModel.fromJson(e.data() as Map<String,dynamic>);
              }).toList().reversed.toList();

              return ListView.builder(
                reverse: true,
                  itemCount: list.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  controller: controller.scrollController,
                  itemBuilder: (context, index) {
                    final userId=Get.find<AuthController>().firebaseUser.value?.uid;

                    bool isSender=list[index].senderId==userId;

                    // debugPrint("Is Sender coming is $isSender");

                    return Container(
                      padding: EdgeInsets.only(
                          left: isSender?50:14, right: isSender?14:50, top: 10, bottom: 10),
                      child: Align(
                        alignment: (isSender
                            ? Alignment.topRight:Alignment.topLeft
                            ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: const Radius.circular(12.0),
                                topLeft: const Radius.circular(12.0),
                                bottomLeft: isSender
                                    ? const Radius.circular(12.0):const Radius.circular(0.0)
                                    ,
                                bottomRight: isSender
                                    ? const Radius.circular(0.0): const Radius.circular(12.0)
                                    ),
                            color: (isSender
                                ? AppColors.primaryColor:AppColors.textFieldBackgroundColor
                                ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            list[index].content??"",
                            style: TextStyle(
                                fontSize: 15,
                                color: isSender
                                    ? AppColors.whiteColor
                                    : AppColors.blackTextColor),
                          ),
                        ),
                      ),
                    );
                  });
            }
            return const Center(child: CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }

  Widget getInputField(BuildContext context) {
    final chatController = Get.find<ChatController>();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.w),
              topRight: Radius.circular(4.w),
            )),
        alignment: Alignment.center,
        height: 10.h,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    height: 7.h,
                    decoration: BoxDecoration(
                      color: AppColors.textFieldBackgroundColor,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 2),
                            blurRadius: 7,
                            color: Colors.grey.shade400)
                      ],
                    ),
                    child: Row(
                      children: [
                        getMoodIconButton(),
                        Expanded(
                          child: SizedBox(
                            // width: 42.w,
                            child: TextField(
                              onChanged: (value) {
                                chatController.message.value = value;
                              },
                              controller: chatController.messageFieldController,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.textFieldBackgroundColor,
                                  hintText: AppStrings.message,
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(
                                          color: AppColors.greyColor?.darken(30)),
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        getAttachFileButton(),
                        Obx(() => chatController.message.value.isNotEmpty
                            ? const SizedBox()
                            : getCameraButton()),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: (){
                    if(chatController.message.value.isNotEmpty){
                      callSendMessage();
                    }
                    else{
                      print("Voice recording tapped");
                    }
                  },
                  child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(12.0))),
                      child: Obx(() => chatController.message.value.isNotEmpty
                          ? getSendMessageButton()
                          : getVoiceRecordingButton())),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget getMoodIconButton() {
    return IconButton(
        icon: Icon(
          Icons.mood,
          // color: AppColors.greyColor,
          color: AppColors.greyColor?.darken(30),
        ),
        onPressed: () => callEmoji());
  }

  Widget getAttachFileButton() {
    return IconButton(
      icon: Icon(Icons.attach_file, color: AppColors.greyColor?.darken(30)),
      onPressed: () => callAttachFile(),
    );
  }

  Widget getCameraButton() {
    return IconButton(
      icon: Icon(Icons.photo_camera, color: AppColors.greyColor?.darken(30)),
      onPressed: () => callCamera(),
    );
  }

  Widget getVoiceIcon() {
    return const Icon(
      Icons.keyboard_voice,
      color: AppColors.whiteColor,
    );
  }

  Widget getVoiceRecordingButton() {
    return InkWell(
      child: getVoiceIcon(),
      onLongPress: () => callVoice(),
    );
  }

  Widget getSendMessageButton() {
    return const Icon(
      Icons.send,
      color: AppColors.whiteColor,
    );
  }
}

// https://stackoverflow.com/questions/54702778/how-to-show-typing-indicator-in-android-firebase-chat
