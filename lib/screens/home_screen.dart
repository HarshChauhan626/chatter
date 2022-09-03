import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:chat_app/controllers/home_controller.dart';
import 'package:chat_app/screens/review_popup.dart';
import 'package:chat_app/screens/search_conversation_screen.dart';
import 'package:chat_app/screens/search_people_screen.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/widgets/animated_column_widget.dart';
import 'package:chat_app/widgets/custom_bottom_navigation_bar_2.dart';
import 'package:chat_app/widgets/custom_route_builder.dart';
import 'package:chat_app/widgets/custom_safe_area.dart';
import 'package:chat_app/widgets/input_text_field.dart';
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
        StreamBuilder(
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

              final roomModelList = chatList.docs.map((e) {
                debugPrint("Message data coming is ${e.data()}");
                return RoomModel.fromJson(e.data() as Map<String, dynamic>);
              }).toList();

              debugPrint(roomModelList.toString());

              sliverList.add(getChatList(roomModelList));
            }

            return CustomScrollView(
              controller: _scrollController,
              // slivers: [getAppBar(), getChatList()],
              slivers: sliverList,
            );
          },
        ),
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

  Widget getAppBar() {
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
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Chatter",
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: AppColors.blackTextColor,
                            fontWeight: FontWeight.w900),
                      ),
                      InkWell(
                        child: randomAvatar(
                          "Harsh Chauhan",
                          height: 30,
                          width: 30,
                        ),
                        onTap: () {
                          Get.toNamed('/profile');
                        },
                      )
                    ],
                  ),
                ),
                OpenContainer(
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
                )
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         SlideTransition(
                //           position: _animation!,
                //           child: Text(
                //             "Hello Harsh",
                //             style: Theme.of(context)
                //                 .textTheme
                //                 .subtitle1
                //                 ?.copyWith(color: Colors.grey),
                //           ),
                //         ),
                //         SlideTransition(
                //           position: _animation!,
                //           child: Text(
                //             "Xchat message",
                //             style: Theme.of(context)
                //                 .textTheme
                //                 .headline6
                //                 ?.copyWith(fontWeight: FontWeight.w900),
                //           ),
                //         ),
                //       ],
                //     ),
                //     IconButton(
                //       icon: const Icon(Icons.edit),
                //       onPressed: () {
                //         showModalBottomSheet(context: context, builder: (context){
                //           return ReviewPopup();
                //         });
                //       },
                //     )
                //   ],
                // ),
                // const SizedBox(
                //   height: 30.0,
                // ),
                // SizedBox(
                //   height: 60.0,
                //   child: ListView.builder(
                //       scrollDirection: Axis.horizontal,
                //       shrinkWrap: true,
                //       itemCount: 30,
                //       itemBuilder: (context, index) {
                //         if (index == 0) {
                //           return Padding(
                //             padding:
                //                 const EdgeInsets.symmetric(horizontal: 8.0),
                //             child: Container(
                //               height: 60.0,
                //               width: 60.0,
                //               decoration: BoxDecoration(
                //                   color: AppColors.lightGreyColor,
                //                   borderRadius: BorderRadius.circular(80.0)),
                //               child: const Icon(
                //                 Icons.search,
                //                 color: Colors.black,
                //               ),
                //             ),
                //           );
                //         }
                //         return Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //           child: Container(
                //             height: 80.0,
                //             width: 80.0,
                //             decoration: BoxDecoration(
                //                 color: AppColors.lightGreyColor,
                //                 borderRadius: BorderRadius.circular(80.0)),
                //             child: randomAvatar(
                //               DateTime.now().toIso8601String(),
                //               trBackground: true,
                //               height: 50,
                //               width: 52,
                //             ),
                //           ),
                //         );
                //       }),
                // )
              ],
            )),
      ),
    );
  }

  Widget getChatList(List<RoomModel> roomModelList) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      // return AnimationConfiguration.staggeredList(duration: const Duration(milliseconds: 400),position: index, child: getChatListItem(index));
      return getChatListItem(index);
    }, childCount: roomModelList.length));
  }

  Widget getChatListItem(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(context, "/chat");
        },
        tileColor: AppColors.whiteColor,
        leading: randomAvatar(
          index.toString(),
          height: 50,
          width: 52,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Harsh Chauhan",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text("5:46 PM",
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(color: Colors.black54))
          ],
        ),
        subtitle: Row(
          children: [
            Text("Latest message",
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(color: Colors.black54))
          ],
        ),
      ),
    );
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
}
