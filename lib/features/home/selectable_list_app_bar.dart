import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../controllers/home_controller.dart';
import '../../utils/app_colors.dart';

class SelectableListAppBar extends StatelessWidget {
  SelectableListAppBar({Key? key}) : super(key: key);

  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isSelectedLengthGT1 = false;

      if (homeController.selectedChatIdList.value.length > 1) {
        isSelectedLengthGT1 = true;
      }

      return SliverAppBar(
        forceElevated: true,
        //* here
        elevation: 1.5,
        //* question having 0 here
        pinned: true,
        floating: false,
        leading: getHeaderIcon(Icons.close, onTap: () {
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
            getHeaderIcon(Icons.push_pin_outlined, onTap: () {
              onTapPin();
            }),
          // getHeaderIcon(Icons.archive_outlined, onTap: () {}),
          getHeaderIcon(Icons.delete_outline, onTap: () {
            onTapDelete();
          }),
          if (!isSelectedLengthGT1)
            getHeaderIcon(Icons.block_flipped, onTap: () {})
        ],
      );
    });
  }

  Widget getHeaderIcon(IconData iconData, {required Function onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: InkWell(
        child: Icon(
          iconData,
          color: AppColors.primaryColor,
          size: 26,
        ),
        onTap: () {
          onTap();
        },
      ),
    );
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

  void onTapDelete() async {
    final selectedChatList = homeController.selectedChatIdList;
    for (int i = 0; i < selectedChatList.length; i++) {
      await homeController.deleteChat(selectedChatList[i]);
    }
    homeController.selectedChatIdList.clear();
  }

  void onTapBlock() {}
}
