import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:chat_app/controllers/home_controller.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/review_popup.dart';
import 'package:chat_app/screens/search_conversation_screen.dart';
import 'package:chat_app/screens/search_people_screen.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/utils/util_functions.dart';
import 'package:chat_app/widgets/animated_column_widget.dart';
import 'package:chat_app/widgets/chat_list_item.dart';
import 'package:chat_app/widgets/custom_bottom_navigation_bar_2.dart';
import 'package:chat_app/widgets/custom_route_builder.dart';
import 'package:chat_app/widgets/custom_safe_area.dart';
import 'package:chat_app/widgets/input_text_field.dart';
import 'package:chat_app/widgets/profile_picture_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:sizer/sizer.dart';

import '../controllers/auth_controller.dart';
import '../helper/firebase_helper.dart';
import '../models/room_model.dart';
import '../utils/app_strings.dart';
import '../utils/enums.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = '/home';

  static Route route() {
    // return MaterialPageRoute(
    //     settings: const RouteSettings(name: routeName),
    //     builder: (_) =>const HomeScreen()
    // );
    return CustomRouteBuilder(page: const HomeScreen(), routeName: routeName);
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<Offset>? _animation;

  final ScrollController _scrollController = ScrollController();

  bool isScrollingDownwards = false;

  HomeController? homeController;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..forward();
    _animation = Tween<Offset>(
      begin: const Offset(-0.3, 0.0),
      end: const Offset(0.01, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeInCubic,
    ));

    homeController = Get.find<HomeController>();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          isScrollingDownwards = true;
        });
      } else {
        setState(() {
          isScrollingDownwards = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
        child: Scaffold(body: getBody()
            // bottomSheet: getBottomNavigation()
            ));
  }

  Widget getBody() {
    return Stack(
      children: [
        getChatBuilder(),
        Positioned(
            bottom: 4.h,
            right: 4.w,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 8.h,
              width: isScrollingDownwards ? 8.h : 40.w,
              decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(20.0)),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Material(
                  elevation: 4.0,
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(15.0),
                  child: InkWell(
                    // highlightColor: AppColors.primaryColor.withOpacity(0.4),
                    // splashColor: AppColors.primaryColor.withOpacity(0.5),
                    onTap: () {
                      Get.toNamed(SearchPeopleScreen.routeName);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: isScrollingDownwards ? 8.h : 40.w,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.message_outlined,
                            color: AppColors.whiteColor,
                          ),
                          if (!isScrollingDownwards)
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                AppStrings.startChat,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                        color: AppColors.whiteColor,
                                        fontSize: 17.0),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ))
      ],
    );
  }

  Widget getChatBuilder() {
    return StreamBuilder(
      stream: homeController?.chatList,
      builder: (context, snapshot) {
        List<Widget> sliverList = [getAppBar()];

        if (snapshot.connectionState == ConnectionState.none) {
          sliverList.add(const SliverToBoxAdapter(
            child: SizedBox(),
          ));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          sliverList.add(const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ));
        }
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData) {
          final chatList = snapshot.data as QuerySnapshot;

          // final roomModelList = chatList.docs.map((e) async{
          //   debugPrint("Message data coming is ${e.data()}");
          //   final roomData = e.data() as Map<String, dynamic>;
          //   final userInfoList = [];
          //   if (roomData["userList"] != null &&
          //       roomData["userList"].length != 0) {
          //     for (int i = 0; i < roomData["userList"].length; i++) {
          //       if(roomData["userList"][i]!=homeController?.senderId){
          //         final userInfo = await homeController?.getUserInfo(roomData["userList"][i]);
          //         if (userInfo != null) {
          //           userInfoList.add(userInfo);
          //         }
          //       }
          //     }
          //     }
          //     roomData["userInfoList"] = userInfoList;
          //   return RoomModel.fromJson(roomData);
          //   }
          //   // return RoomModel.fromJson(e.data() as Map<String, dynamic>);
          // ).toList();

          final roomModelList = chatList.docs.map((e) {
            debugPrint("Message data coming is ${e.data()}");
            return RoomModel.fromJson(e.data() as Map<String, dynamic>);
          }).toList();

          roomModelList.sort((a,b){
            int firstTimeStamp=a.latestMessage!.timestamp!;
            int secondTimeStamp=b.latestMessage!.timestamp!;
            print("First ${firstTimeStamp.toString()} Second ${secondTimeStamp.toString()}");
            print("Compare to $firstTimeStamp $secondTimeStamp ${firstTimeStamp-secondTimeStamp}");
            return secondTimeStamp.compareTo(firstTimeStamp);
          });

          debugPrint(roomModelList.toString());

          sliverList.add(getChatList(roomModelList));
        }

        return CustomScrollView(
          controller: _scrollController,
          // slivers: [getAppBar(), getChatList()],
          slivers: sliverList,
        );
      },
    );

    // return Obx((){
    //   if(homeController.isLoading){
    //
    //   }
    //   if(homeController.errorComing){
    //
    //   }
    //   if(homeController.roomList){
    //
    //   }
    // });
    //
  }

  Widget getAppBar() {
    return Obx(() {
      final selectedList = homeController?.selectedChatIdList;
      if (selectedList!.isEmpty) {
        return getNormalAppBar();
      }
      return getSelectableListAppBar();
    });
  }

  Widget getNormalAppBar() {
    final currentUserInfo = Get.find<AuthController>().userInfo.value;
    final currentUserProfilePicture = currentUserInfo?.profilePicture ?? "";

    return SliverAppBar(
      floating: true,
      expandedHeight: 140.0,
      // pinned: true,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.whiteColor,
      // bottom: PreferredSize(
      //   preferredSize: const Size(double.infinity, 5),
      //   child: Divider(color: Colors.grey.shade500),
      // ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
            alignment: Alignment.centerLeft,
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                getHeader(currentUserProfilePicture),
                getSearchContainer()
              ],
            )),
      ),
    );
  }

  Widget getSelectableListAppBar() {
    return SliverAppBar(
      forceElevated: true, //* here
      elevation: 1.5, //* question having 0 here
      pinned: true,
      floating: false,
      leading: IconButton(
        icon: getHeaderIcon(Icons.close),
        onPressed: () {
          homeController?.selectedChatIdList.clear();
        },
      ),
      title: Text(
        '${homeController?.selectedChatIdList.length}',
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: AppColors.primaryColor, fontSize: 24),
      ),
      actions: [
        getHeaderIcon(Icons.push_pin_outlined),
        getHeaderIcon(Icons.archive_outlined),
        getHeaderIcon(Icons.delete_outline),
        getHeaderIcon(Icons.block_flipped)
      ],
    );
  }

  Widget getHeader(String currentUserProfilePicture) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Chatter",
            style: Theme.of(context).textTheme.headline5?.copyWith(
                color: AppColors.blackTextColor, fontWeight: FontWeight.w900),
          ),
          InkWell(
            child: currentUserProfilePicture.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: NetworkImage(
                      currentUserProfilePicture,
                    ),
                  )
                : randomAvatar(
                    "Harsh",
                    height: 30,
                    width: 30,
                  ),
            onTap: () {
              Get.toNamed('/profile');
            },
          )
        ],
      ),
    );
  }

  Widget getSearchContainer() {
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 600),
      transitionType: ContainerTransitionType.fade,
      openBuilder: (context, closedContainer) {
        return SearchConversationScreen();
      },
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      closedElevation: 0,
      closedColor: AppColors.textFieldBackgroundColor,
      closedBuilder: (context, openContainer) {
        return InputTextField(
          inputTextType: InputTextType.search,
          onChangedValue: () {},
          hintText: AppStrings.searchConversation,
          onTap: () {
            // Get.toNamed(SearchConversationScreen.routeName);
            openContainer();
          },
        );
      },
    );
  }

  Widget getChatList(List<RoomModel> roomModelList) {
    final selectedList = Get.find<HomeController>().selectedChatIdList;

    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      // return AnimationConfiguration.staggeredList(duration: const Duration(milliseconds: 400),position: index, child: getChatListItem(index));
      return Dismissible(
        key: ObjectKey(index),
        child: ChatListItem(
          roomModel: roomModelList[index],
          index: index,
        ),
        direction: selectedList.isEmpty
            ? DismissDirection.horizontal
            : DismissDirection.none,
        onDismissed: (DismissDirection direction) {
          setState(() {
            // this._theList.removeAt(index);
            print("List item dismissed");
            //this.reIndex();
          });
          direction == DismissDirection.endToStart
              ? print("favourite")
              : print("remove");
        },
        background: Container(
            alignment: Alignment.center,
            color: const Color.fromRGBO(0, 96, 100, 0.8),
            child: const ListTile(
                leading: Icon(Icons.push_pin_outlined,
                    color: Colors.white, size: 36.0))),
        secondaryBackground: Container(
            color: const Color.fromRGBO(183, 28, 28, 0.8),
            alignment: Alignment.center,
            child: const ListTile(
                trailing: Icon(Icons.delete, color: Colors.white, size: 36.0))),
      );
    }, childCount: roomModelList.length));
  }

  Widget getBottomNavigation() {
    return Container(
      height: 70.0,
      decoration: const BoxDecoration(color: AppColors.whiteColor, boxShadow: [
        BoxShadow(color: Colors.black, offset: Offset(10.0, 0.0)),
        BoxShadow(color: Colors.white12, offset: Offset(10.0, 10.0)),
      ]),
      alignment: Alignment.center,
      child: Center(child: BottomNavbar(
        callback: (int index) {
          debugPrint(index.toString());
        },
      )),
    );
  }

  Widget getHeaderIcon(IconData iconData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Icon(
        iconData,
        color: AppColors.primaryColor,
        size: 26,
      ),
    );
  }
}
