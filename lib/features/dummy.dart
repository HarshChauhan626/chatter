import 'package:chat_app/features/profile/receiver_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';

import '../controllers/chat_controller.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../widgets/profile_picture_avatar.dart';


class DummyScreen extends StatelessWidget {
  DummyScreen({Key? key}) : super(key: key);

  final controller = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        elevation: 1.0,
        automaticallyImplyLeading: false,
        toolbarHeight: 8.h,
        leading: getBackButton(),
        title:getNormalTitle(),
        actions: [
          getSearchButton(),
          getMoreOptionsButton()
        ],
      ),
    );
  }


  Widget getNormalTitle(){
    final receiverModel = controller.receiverModel;

    debugPrint("Username coming is ${controller.receiverModel}");

    final receiverProfilePicture = receiverModel?.profilePicture ?? "";

    return Builder(builder: (context){
      return Row(
        children: [
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
                controller.receiverModel?.userName ?? "",
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
          )
        ],
      );
    });

  }

  Widget getAppBar() {
    return Container(
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
        children: [
          getAppBarUpperBody(),
          getSearchResultNavigator()
        ],
      ),
    );
  }

  Widget getAppBarUpperBody() {
    return Obx(() {
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

    return Obx((){
      int currentIndex=controller.currentIndex.value;
      final searchList=controller.searchResultList.value;
      final searchText=controller.searchText.value;
      if(searchList.isNotEmpty && searchText.isNotEmpty){
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
                  "${controller.currentIndex}/${controller.searchResultList.length} results found",
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
              controller: controller.searchTextController,
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                  focusedBorder: InputBorder.none,
                  hintText: AppStrings.search,
                  border: InputBorder.none),
              onChanged: (String val){
                controller.searchText.value=val;
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
                // focusNode?.requestFocus();
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              onPressed: () async {
                // assert(autoScrollController != null);
                // await autoScrollController?.scrollToIndex(16,
                //     preferPosition: AutoScrollPosition.end);
                Get.to(DummyScreen());
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
        color: AppColors.blackTextColor,
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

  Widget getMoreOptionsButton(){
    return IconButton(
      icon: const Icon(
        Icons.more_vert,
        color: Colors.black,
      ),
      onPressed: () async {
        // assert(autoScrollController != null);
        // await autoScrollController?.scrollToIndex(16,
        //     preferPosition: AutoScrollPosition.end);
        Get.to(DummyScreen());
      },
    );
  }

  Widget getSearchButton(){
    return IconButton(
      icon: const Icon(
        Icons.search,
        color: Colors.black,
      ),
      onPressed: () {
        controller.searchButtonTapped.value = true;
        // focusNode?.requestFocus();
      },
    );
  }

}




