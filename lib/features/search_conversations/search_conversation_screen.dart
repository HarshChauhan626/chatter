import 'package:animations/animations.dart';
import 'package:chat_app/widgets/custom_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_colors.dart';
import '../../widgets/custom_route_builder.dart';

class SearchConversationScreen extends StatelessWidget {
  SearchConversationScreen({Key? key}) : super(key: key);

  static const String routeName = "/search_conversation";

  TextEditingController searchEditingController = TextEditingController();

  FocusNode inputNode = FocusNode();

  static Route route() {
    return CustomRouteBuilder(
        page: SearchConversationScreen(), routeName: routeName);
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
        child: Scaffold(
            appBar: getAppBar(context),
            body: ListView.builder(
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return getSearchResultItem();
                })));
  }

  Widget getSearchResultItem() {
    return Container(
    );
  }

  PreferredSizeWidget getAppBar(context) {
    FocusScope.of(context).requestFocus(inputNode);
    return PreferredSize(
        preferredSize: Size(100.w, 8.h),
        child: Container(
          color: AppColors.textFieldBackgroundColor,
          height: 8.h,
          alignment: Alignment.center,
          child: TextField(
            autofocus: true,
            focusNode: inputNode,
            controller: searchEditingController,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
                prefixIcon: IconButton(
                  icon: const Icon(CupertinoIcons.back),
                  onPressed: () {
                    Get.back();
                  },
                ),
                hintText: "Search conversations",
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {},
                )),
          ),
        ));
  }
}

class OpenContainerWrapper extends StatelessWidget {
  OpenContainerWrapper(
      {required this.id, required this.closedChild, required this.openChild});

  final int id;
  final Widget openChild;
  final Widget closedChild;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OpenContainer(
      openBuilder: (context, closedContainer) {
        return openChild;
      },
      openColor: theme.cardColor,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      closedElevation: 0,
      closedColor: theme.cardColor,
      closedBuilder: (context, openContainer) {
        return InkWell(
          onTap: () {
            openContainer();
          },
          child: closedChild,
        );
      },
    );
  }
}

// https://stackoverflow.com/questions/72433897/flutter-how-to-create-this-kind-of-animated-search-bar
