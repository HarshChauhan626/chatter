import 'package:chat_app/controllers/auth_controller.dart';
import 'package:chat_app/controllers/chat_controller.dart';
import 'package:chat_app/features/chat/selectable_chat_list_app_bar.dart';
import 'package:chat_app/features/profile/receiver_profile_screen.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/utils/extensions.dart';
import 'package:chat_app/utils/util_functions.dart';
import 'package:chat_app/widgets/attachment_menu_bottom_sheet.dart';
import 'package:chat_app/widgets/custom_route_builder.dart';
import 'package:chat_app/widgets/custom_safe_area.dart';
import 'package:chat_app/widgets/profile_picture_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sizer/sizer.dart';

import '../../models/message_model.dart';
import '../../utils/app_strings.dart';
import 'chat_loading_screen.dart';
import 'message_list_item.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  static const String routeName = '/chat';

  static Route route() {
    return CustomRouteBuilder(page: ChatScreen(), routeName: routeName);
  }

  TextEditingController inputMessageController = TextEditingController();

  ChatController controller = Get.find<ChatController>();

  AutoScrollController? autoScrollController;
  FocusNode? focusNode;

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
    focusNode = FocusNode();
    autoScrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);
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
      preferredSize: Size(double.infinity, 8.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 2),
                blurRadius: 2,
                color: Colors.grey.shade300),
          ],
        ),
        child: getAppBarBody(),
      ),
    );
  }

  Widget getAppBarBody() {
    return Obx(() {
      if(controller.selectedMessagesList.isNotEmpty){
        return SelectableChatListAppBar();
      }
      return AnimatedCrossFade(
          firstChild: getNormalBar(),
          secondChild: getSearchBar(),
          crossFadeState: controller.searchButtonTapped.value
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200));
      // if (controller.searchButtonTapped.value) {
      //   return getSearchBar();
      // }
      // return getNormalBar();
    });
  }

  Widget getSearchResultNavigator() {
    return Obx(() {
      int currentIndex = controller.currentIndex.value;
      final searchList = controller.searchResultList.value;
      final searchText = controller.searchText.value;
      if (searchList.isNotEmpty && searchText.isNotEmpty) {
        // return Builder(builder: (context) {
        //
        // });
        return Container(
          padding: const EdgeInsets.only(left: 17.0),
          alignment: Alignment.center,
          height: 7.h,
          color: AppColors.textFieldBackgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${controller.currentIndex.value + 1}/${controller.searchResultList.length} results found",
                // style: Theme.of(context).textTheme.bodyLarge,
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                    onPressed: () async {
                      if (controller.currentIndex.value >= 1) {
                        controller.currentIndex.value -= 1;
                        assert(autoScrollController != null);
                        final scrollToIndexVal = controller.searchResultList
                            .value[controller.currentIndex.value];
                        print(
                            "Scroll to index val coming is $scrollToIndexVal");
                        await autoScrollController?.scrollToIndex(16,
                            preferPosition: AutoScrollPosition.begin);
                        print(
                            "Scrolling done with ${autoScrollController != null}");
                      }
                    },
                  ),
                  IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      ),
                      onPressed: () async {
                        if (controller.currentIndex.value <
                            controller.searchResultList.length - 1) {
                          controller.currentIndex.value += 1;
                          assert(autoScrollController != null);
                          final scrollToIndexVal = controller.searchResultList
                              .value[controller.currentIndex.value];
                          print(
                              "Scroll to index val coming is $scrollToIndexVal");
                          await autoScrollController?.scrollToIndex(16,
                              preferPosition: AutoScrollPosition.begin);
                          print(
                              "Scrolling done with ${autoScrollController != null}");
                        }
                      })
                ],
              )
            ],
          ),
        );
      }
      return SizedBox(
        height: 0.h,
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
              focusNode: focusNode,
              controller: controller.searchTextController,
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                  focusedBorder: InputBorder.none,
                  hintText: AppStrings.search,
                  border: InputBorder.none),
              onChanged: (String val) {
                controller.searchText.value = val;
                if (controller.searchResultList.isNotEmpty) {
                  controller.searchMessages();
                }
                if (val.isEmpty) {
                  controller.searchResultList.clear();
                }
              },
              onSubmitted: (String val) {
                if (val.length >= 2) {
                  controller.searchMessages();
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              controller.searchTextController.clear();
              controller.searchText.value = "";
              controller.searchResultList.clear();
            },
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
                focusNode?.requestFocus();
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              onPressed: () async {
                assert(autoScrollController != null);
                await autoScrollController?.scrollToIndex(1,
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
        child: Stack(
          children: [getChatStream(), getSearchResultNavigator()],
        ),
      ),
    );
  }

  Widget getChatStream() {
    return StreamBuilder(
      stream: controller.dataList,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.active) {
          final chatList = snapshot.data as QuerySnapshot;

          controller.messageList.value = chatList.docs
              .map((e) {
                // print("Message data coming is ${e.data()}");
                final messageModel =
                    MessageModel.fromJson(e.data() as Map<String, dynamic>);
                messageModel.messageId = e.id;
                return messageModel;
              })
              .toList()
              .reversed
              .toList();
          if (kDebugMode) {
            print(controller.messageList.length);
          }
          return ListView.builder(
              reverse: true,
              itemCount: controller.messageList.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              controller: autoScrollController,
              itemBuilder: (context, index) {
                return MessageListItem(
                  autoScrollController: autoScrollController!,
                  index: index,
                );
              });
        }
        return const ChatLoadingScreen();
      },
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
                      child: Obx(() => AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: chatController.message.value.isNotEmpty
                                ? getSendMessageButton()
                                : getVoiceRecordingButton(),
                          ))),
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
