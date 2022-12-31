import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../utils/app_colors.dart';
import '../../widgets/alert_dialog.dart';
import '../../widgets/custom_alert_body.dart';
import '../../widgets/util_widgets.dart';

class SelectableListAppBar extends StatelessWidget {
  SelectableListAppBar({Key? key}) : super(key: key);

  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isSelectedLengthGT1 = false;

      if (homeController.selectedChatIdList.length > 1) {
        isSelectedLengthGT1 = true;
      }

      return SliverAppBar(
        forceElevated: true,
        //* here
        elevation: 1.5,
        //* question having 0 here
        pinned: true,
        floating: false,
        leading: UtilWidgets.getHeaderIcon(Icons.close, onTap: () {
          homeController.selectedChatIdList.clear();
        }),
        title: Text(
          '${homeController.selectedChatIdList.length}',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: AppColors.primaryColor, fontSize: 24),
        ),
        actions: [
          if (!isSelectedLengthGT1)
            UtilWidgets.getHeaderIcon(Icons.push_pin_outlined, onTap: () {
              onTapPin();
            }),
          // getHeaderIcon(Icons.archive_outlined, onTap: () {}),
          UtilWidgets.getHeaderIcon(Icons.delete_outline, onTap: () {
            final selectedConversationsList = homeController.selectedChatIdList;
            const deleteFor = "Everyone";
            final subtitleText =
                "Are you sure you want to delete ${selectedConversationsList.length > 1 ? "these" : "this"} ${selectedConversationsList.length > 1 ? "conversation" : "conversation"}?";
            final titleText =
                "Delete ${selectedConversationsList.length > 1 ? "${selectedConversationsList.length} messages" : "message"} ";
            showCustomDialog(
                context,
                CustomAlertBody.deleteMessageAlert(
                    context: context,
                    title: titleText,
                    subtitle: subtitleText,
                    deleteFor: deleteFor,
                    onTapCancel: () {
                      Navigator.pop(context);
                      homeController.selectedChatIdList.clear();
                    },
                    onTapDeleteForAll: () {
                      onTapDelete(isDeleteForAll: true);
                    },
                    onTapDeleteForMe: () {
                      onTapDelete();
                    }));
          }),
          if (!isSelectedLengthGT1)
            UtilWidgets.getHeaderIcon(Icons.block_flipped, onTap: () {})
        ],
      );
    });
  }

  void onTapPin() {
    final roomId = homeController.selectedChatIdList.first;
    // Get.find<HiveDBHelper>().addPinnedRoomId(roomId);
    Get.find<HomeController>().pinChat(roomId);
    homeController.selectedChatIdList.clear();
  }

  // void onTapArchive(){
  //
  // }

  void onTapDelete({bool? isDeleteForAll}) async {
    homeController.deleteConversations(isDeleteForAll: isDeleteForAll);
  }

  void onTapBlock() {}
}
