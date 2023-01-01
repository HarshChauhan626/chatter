import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/chat_controller.dart';
import '../../utils/app_colors.dart';
import '../../widgets/alert_dialog.dart';
import '../../widgets/custom_alert_body.dart';
import '../../widgets/util_widgets.dart';
import 'package:sizer/sizer.dart';

class SelectableChatListAppBar extends StatelessWidget {
  SelectableChatListAppBar({Key? key}) : super(key: key);

  final chatController = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isSelectedLengthGT1 = false;

      if (chatController.selectedMessagesList.length > 1) {
        isSelectedLengthGT1 = true;
      }

      return SizedBox(
        height: 7.h,
        child: Row(
          children: [
            UtilWidgets.getHeaderIcon(Icons.close, onTap: () {
              chatController.selectedMessagesList.clear();
            }),
            SizedBox(
              width: 5.w,
            ),
            Text(
              '${chatController.selectedMessagesList.length}',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: AppColors.primaryColor, fontSize: 24),
            ),
            const Spacer(),
            UtilWidgets.getHeaderIcon(Icons.copy, onTap: (){
              onTapCopyToClipboard();
            }),
            Builder(builder: (context) {
              final selectedMessagesList = chatController.selectedMessagesList;
              final deleteFor = chatController.receiverModel?.userName;
              final subtitleText =
                  "Are you sure you want to delete ${selectedMessagesList.length > 1 ? "these" : "this"} ${selectedMessagesList.length > 1 ? "messages" : "message"}?";
              final titleText =
                  "Delete ${selectedMessagesList.length > 1 ? "${selectedMessagesList.length} messages" : "message"} ";
              return UtilWidgets.getHeaderIcon(Icons.delete_outline, onTap: () {
                // onTapDelete();
                showCustomDialog(
                    context,
                    CustomAlertBody.deleteMessageAlert(
                        context: context,
                        title: titleText,
                        subtitle: subtitleText,
                        deleteFor: deleteFor,
                        onTapCancel: () {
                          Navigator.pop(context);
                          chatController.selectedMessagesList.clear();
                        },
                        onTapDeleteForAll: () {
                          onTapDelete(isDeleteForAll: true);
                        },
                        onTapDeleteForMe: () {
                          onTapDelete();
                        }));
              });
            }),
          ],
        ),
      );

      // return AppBar(
      //   elevation: 1.5,
      //   leading: UtilWidgets.getHeaderIcon(Icons.close, onTap: () {
      //     chatController.selectedMessagesList.clear();
      //   }),
      //   title: Text(
      //     '${chatController.selectedMessagesList.length}',
      //     style: Theme.of(context)
      //         .textTheme
      //         .titleLarge
      //         ?.copyWith(color: AppColors.primaryColor, fontSize: 24),
      //   ),
      //   actions: [
      //     // getHeaderIcon(Icons.archive_outlined, onTap: () {}),
      //     UtilWidgets.getHeaderIcon(Icons.delete_outline, onTap: () {
      //       onTapDelete();
      //     }),
      //   ],
      // );
    });
  }

  void onTapCopyToClipboard()async{
    chatController.onCopyMessages();
  }

  void onTapDelete({bool? isDeleteForAll}) async {
    chatController.deleteMessages(isDeleteForAll: isDeleteForAll);
  }
}
