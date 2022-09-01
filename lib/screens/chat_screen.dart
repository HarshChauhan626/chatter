import 'package:chat_app/controllers/chat_controller.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/widgets/custom_route_builder.dart';
import 'package:chat_app/widgets/custom_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:sizer/sizer.dart';
import 'package:chat_app/utils/extensions.dart';
import 'package:uuid/uuid.dart';
import '../helper/firebase_helper.dart';
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
    debugPrint('Send message pressed');
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColors.whiteColor,
        appBar: getAppBar(context),
        body: getBody(),
        bottomSheet: getInputField(context),
      ),
    );
  }

  PreferredSizeWidget getAppBar(BuildContext context) {

    final chatController=Get.find<ChatController>();

    print("Username coming is ${chatController.receiverModel}");

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
            Container(
              child: randomAvatar(
                chatController.receiverModel?.userName??"",
                height: 40,
                width: 40,
              ),
            ),
            const SizedBox(
              width: 8.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  chatController.receiverModel?.userName??"",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  AppStrings.activeNow,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.green),
                )
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
    return getMessageList();
  }

  Widget getMessageList() {
    return SizedBox(
      height: 79.h,
      child: StreamBuilder(
        builder: (context,snapshot){
          return  ListView.builder(
              itemCount: messageList.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.only(
                      left: 14, right: 14, top: 10, bottom: 10),
                  child: Align(
                    alignment:
                    (index % 2 == 0 ? Alignment.topLeft : Alignment.topRight),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: const Radius.circular(12.0),
                            topLeft: const Radius.circular(12.0),
                            bottomLeft: (index % 2 == 0)
                                ? const Radius.circular(0.0)
                                : const Radius.circular(12.0),
                            bottomRight: (index % 2 == 0)
                                ? const Radius.circular(12.0)
                                : const Radius.circular(0.0)),
                        color: (index % 2 == 0
                            ? AppColors.textFieldBackgroundColor
                            : AppColors.primaryColor),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        messageList[index],
                        style: TextStyle(
                            fontSize: 15,
                            color: index % 2 == 0
                                ? AppColors.blackTextColor
                                : AppColors.whiteColor),
                      ),
                    ),
                  ),
                );
              });

        },
      ),
    );
  }

  Widget getInputField(BuildContext context) {
    return Container(
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

                            },
                            controller: inputMessageController,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.textFieldBackgroundColor,
                                hintText: AppStrings.message,
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(color: AppColors.greyColor?.darken(30)),
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      getAttachFileButton(),
                      inputMessageController.text.isNotEmpty
                          ? const SizedBox()
                          : getCameraButton(),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  child: inputMessageController.text.isNotEmpty
                      ? getSendMessageButton()
                      : getVoiceRecordingButton())
            ],
          )
        ],
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
    return InkWell(
      child: const Icon(
        Icons.send,
        color: AppColors.whiteColor,
      ),
      onTap: () => callSendMessage(),
    );
  }

}



// https://stackoverflow.com/questions/54702778/how-to-show-typing-indicator-in-android-firebase-chat