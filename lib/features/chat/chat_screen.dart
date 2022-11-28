import 'package:chat_app/controllers/auth_controller.dart';
import 'package:chat_app/controllers/chat_controller.dart';
import 'package:chat_app/features/profile/receiver_profile_screen.dart';
import 'package:chat_app/features/search_conversations/search_conversation_screen.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/widgets/attachment_menu_bottom_sheet.dart';
import 'package:chat_app/widgets/custom_route_builder.dart';
import 'package:chat_app/widgets/custom_safe_area.dart';
import 'package:chat_app/widgets/profile_picture_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sizer/sizer.dart';
import 'package:chat_app/utils/extensions.dart';
import 'package:uuid/uuid.dart';
import '../../helper/firebase_helper.dart';
import '../../models/message_model.dart';
import '../../utils/app_strings.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  static const String routeName = '/chat';

  static Route route() {
    return CustomRouteBuilder(page: ChatScreen(), routeName: routeName);
  }

  TextEditingController inputMessageController = TextEditingController();

  ChatController controller = Get.find<ChatController>();

  AutoScrollController? autoScrollController;

  void callEmoji() {
    debugPrint('Emoji Icon Pressed...');
  }

  void callAttachFile(BuildContext context) {
    debugPrint('Attach File Icon Pressed...');
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (context) => const AttachmentMenuBottomSheet(),
    );
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
    autoScrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.horizontal);
    return WillPopScope(
      onWillPop: () async {
        if (controller.searchButtonTapped.value) {
          controller.searchButtonTapped.value = false;
          return false;
        }
        return true;
      },
      child: CustomSafeArea(
        child: Scaffold(
          extendBody: true,
          backgroundColor: AppColors.whiteColor,
          appBar: getAppBar(),
          body: getBody(),
          bottomNavigationBar: getInputField(context),
        ),
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return PreferredSize(
      preferredSize: Size(double.infinity, 14.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 2),
                blurRadius: 3,
                color: Colors.grey.shade300),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [getAppBarUpperBody(), getSearchResultNavigator()],
        ),
      ),
    );
  }

  Widget getAppBarUpperBody() {
    return Obx(() {
      if (controller.searchButtonTapped.value) {
        return getSearchBar();
      }
      return getNormalBar();
    });
  }

  Widget getSearchResultNavigator() {
    return Builder(builder: (context) {
      return Container(
        padding: const EdgeInsets.only(left: 17.0),
        alignment: Alignment.center,
        height: 7.h,
        color: AppColors.textFieldBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "18/18 results found",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                    onPressed: () {})
              ],
            )
          ],
        ),
      );
    });
  }

  Widget getSearchBar() {
    return SizedBox(
      height: 7.h,
      child: Row(
        children: [
          getBackButton(),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  hintText: AppStrings.search,
                  border: InputBorder.none),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget getNormalBar() {
    final chatController = Get.find<ChatController>();

    final receiverModel = chatController.receiverModel;

    debugPrint("Username coming is ${chatController.receiverModel}");

    final receiverProfilePicture = receiverModel?.profilePicture ?? "";

    return Builder(builder: (context) {
      return SizedBox(
        height: 7.h,
        child: Row(
          children: [
            getBackButton(),
            InkWell(
              child: Hero(
                  tag: "ReceiverProfilePicture",
                  child: ProfilePictureAvatar(
                      profilePictureLink: receiverProfilePicture)),
              onTap: () {
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
                Obx(() => controller.isUserOnlineVal.value
                    ? Text(
                        AppStrings.activeNow,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(color: Colors.green),
                      )
                    : const SizedBox())
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {
                chatController.searchButtonTapped.value = true;
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              onPressed: () async {
                assert(autoScrollController != null);
                await autoScrollController?.scrollToIndex(16,
                    preferPosition: AutoScrollPosition.end);
              },
            ),
          ],
        ),
      );
    });
  }

  Widget getBackButton() {
    return IconButton(
      icon: const Icon(
        CupertinoIcons.back,
        size: 28.0,
      ),
      onPressed: () {
        if (controller.searchButtonTapped.value) {
          controller.searchButtonTapped.value = false;
        } else {
          Get.back();
        }
      },
    );
  }

  Widget getBody() {
    return Obx(
        () => controller.showChat.value ? getMessageList() : const SizedBox());
  }

  Widget getMessageList() {
    return SizedBox(
      height: 89.h,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: StreamBuilder(
          stream: controller.dataList,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.active) {
              final chatList = snapshot.data as QuerySnapshot;

              final list = chatList.docs
                  .map((e) {
                    print("Message data coming is ${e.data()}");
                    return MessageModel.fromJson(
                        e.data() as Map<String, dynamic>);
                  })
                  .toList()
                  .reversed
                  .toList();

              return ListView.builder(
                  reverse: true,
                  itemCount: list.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  controller: autoScrollController,
                  itemBuilder: (context, index) {
                    final userId =
                        Get.find<AuthController>().firebaseUser.value?.uid;

                    bool isSender = list[index].senderId == userId;

                    // debugPrint("Is Sender coming is $isSender");

                    return AutoScrollTag(
                      key: ValueKey(index.toString()),
                      controller: autoScrollController!,
                      index: index,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: isSender ? 50 : 14,
                            right: isSender ? 14 : 50,
                            top: 10,
                            bottom: 10),
                        child: Align(
                          alignment: (isSender
                              ? Alignment.topRight
                              : Alignment.topLeft),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: const Radius.circular(12.0),
                                  topLeft: const Radius.circular(12.0),
                                  bottomLeft: isSender
                                      ? const Radius.circular(12.0)
                                      : const Radius.circular(0.0),
                                  bottomRight: isSender
                                      ? const Radius.circular(0.0)
                                      : const Radius.circular(12.0)),
                              color: (isSender
                                  ? AppColors.primaryColor
                                  : AppColors.textFieldBackgroundColor),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              list[index].content ?? "",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: isSender
                                      ? AppColors.whiteColor
                                      : AppColors.blackTextColor),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget getInputField(BuildContext context) {
    final chatController = Get.find<ChatController>();

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                                          color:
                                              AppColors.greyColor?.darken(30)),
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        getAttachFileButton(context),
                        Obx(() => chatController.message.value.isNotEmpty
                            ? const SizedBox()
                            : getCameraButton()),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    if (chatController.message.value.isNotEmpty) {
                      callSendMessage();
                    } else {
                      print("Voice recording tapped");
                    }
                  },
                  child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
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

  Widget getAttachFileButton(BuildContext context) {
    return Builder(
      builder: (context) {
        return IconButton(
          icon: Icon(Icons.attach_file, color: AppColors.greyColor?.darken(30)),
          onPressed: () => callAttachFile(context),
        );
      },
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
// https://stackoverflow.com/questions/55929366/implementing-transitions-in-a-bottomsheet
// https://medium.com/flutter-community/revamped-flutter-bottom-sheet-61662dc2983
