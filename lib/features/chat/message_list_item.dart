import 'package:chat_app/utils/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/chat_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/util_functions.dart';

class MessageListItem extends StatelessWidget {
  int index;
  dynamic autoScrollController;
  MessageListItem(
      {Key? key, required this.index, required this.autoScrollController})
      : super(key: key);

  final controller = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    final userId = Get.find<AuthController>().firebaseUser.value?.uid;

    bool isSender = controller.messageList[index].senderId == userId;

    return Obx(() {
      if (controller.searchResultList.contains(index)) {
        if (kDebugMode) {
          print("Is result item ${controller.messageList[index].content}");
        }
      }

      final messageModel = controller.messageList[index];

      final messageId = messageModel.messageId ?? "";

      bool isSelected = messageId.isEmpty
          ? false
          : controller.selectedMessagesList.contains(messageId);

      Color? containerColor;

      if (isSelected) {
        containerColor = AppColors.primaryColor.darken(50);
      } else {
        containerColor = (isSender
            ? AppColors.primaryColor
            : AppColors.textFieldBackgroundColor);
      }

      final isDeletedMessage=messageModel.deletedBy?.contains(userId)??false;

      if(isDeletedMessage){
        return const SizedBox();
      }
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
            alignment: (isSender ? Alignment.topRight : Alignment.topLeft),
            child: InkWell(
              onLongPress: () {
                final selectedMessagesList = controller.selectedMessagesList;
                if (messageId.isNotEmpty) {
                  if (selectedMessagesList.isEmpty) {
                    selectedMessagesList.add(messageId);
                  } else {
                    selectedMessagesList.remove(messageId);
                  }
                }
              },
              onTap: () {
                final selectedMessagesList = controller.selectedMessagesList;
                if (selectedMessagesList.contains(messageId)) {
                  selectedMessagesList.remove(messageId);
                } else {
                  if(selectedMessagesList.isNotEmpty && messageId.neitherNullNorEmpty()){
                    selectedMessagesList.add(messageId);
                  }
                }
              },
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
                    color: containerColor,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: (controller.searchText.value.isNotEmpty &&
                      controller.searchResultList.isNotEmpty)
                      ? RichText(
                    text: TextSpan(
                        children: UtilFunctions.highlightOccurrences(
                            controller.messageList[index].content ?? "",
                            controller.searchText.value,
                            isSender)),
                  )
                      : Text(
                    controller.messageList[index].content ?? "",
                    style: TextStyle(
                        fontSize: 15,
                        color: isSender
                            ? AppColors.whiteColor
                            : AppColors.blackTextColor),
                  )),
            ),
          ),
        ),
      );
    });
  }
}
