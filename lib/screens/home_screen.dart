import 'dart:ui';

import 'package:chat_app/screens/review_popup.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/widgets/animated_column_widget.dart';
import 'package:chat_app/widgets/custom_bottom_navigation_bar_2.dart';
import 'package:chat_app/widgets/custom_route_builder.dart';
import 'package:chat_app/widgets/custom_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:sizer/sizer.dart';

import '../utils/app_strings.dart';

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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin{



  AnimationController? _controller;
  Animation<Offset>? _animation;

  final ScrollController _scrollController=ScrollController();

  bool isScrollingDownwards=false;

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


    _scrollController.addListener(() {
      if(_scrollController.position.userScrollDirection==ScrollDirection.reverse){
        setState(() {
          isScrollingDownwards=true;
        });
      }
      else{
        setState(() {
          isScrollingDownwards=false;
        });
      }
    });

  }






  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
        child: Scaffold(
            body: getBody()
            // bottomSheet: getBottomNavigation()
        ));
  }


  Widget getBody(){
    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          slivers: [getAppBar(), getChatList()],
        ),
        Positioned(bottom: 4.h,right:4.w,child:
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 8.h,
          width: isScrollingDownwards?8.h:40.w,
          decoration: BoxDecoration(
              color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(15.0)
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Material(
              elevation: 4.0,
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(15.0),
              child: InkWell(
                // highlightColor: AppColors.primaryColor.withOpacity(0.4),
                // splashColor: AppColors.primaryColor.withOpacity(0.5),
                onTap: (){

                },
                child: Container(
                  alignment: Alignment.center,
                  width: isScrollingDownwards?8.h:40.w,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.message_outlined,color: AppColors.whiteColor,),
                      if(!isScrollingDownwards)
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(AppStrings.startChat,style: Theme.of(context).textTheme.headline6?.copyWith(color: AppColors.whiteColor),),
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
      expandedHeight: 200.0,
      // pinned: true,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.whiteColor,
      bottom: PreferredSize(
        preferredSize: const Size(double.infinity, 5),
        child: Divider(color: Colors.grey.shade500),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
            alignment: Alignment.centerLeft,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SlideTransition(
                          position: _animation!,
                          child: Text(
                            "Hello Harsh",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(color: Colors.grey),
                          ),
                        ),
                        SlideTransition(
                          position: _animation!,
                          child: Text(
                            "Xchat message",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showModalBottomSheet(context: context, builder: (context){
                          return ReviewPopup();
                        });
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                SizedBox(
                  height: 60.0,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: 30,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              height: 60.0,
                              width: 60.0,
                              decoration: BoxDecoration(
                                  color: AppColors.lightGreyColor,
                                  borderRadius: BorderRadius.circular(80.0)),
                              child: const Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            height: 80.0,
                            width: 80.0,
                            decoration: BoxDecoration(
                                color: AppColors.lightGreyColor,
                                borderRadius: BorderRadius.circular(80.0)),
                            child: randomAvatar(
                              DateTime.now().toIso8601String(),
                              trBackground: true,
                              height: 50,
                              width: 52,
                            ),
                          ),
                        );
                      }),
                )
              ],
            )),
      ),
    );
  }

  Widget getChatList() {
    return AnimationLimiter(
      child: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return ListTile(
              onTap: () {
                Navigator.pushNamed(context, "/chat");
              },
              tileColor: AppColors.whiteColor,
              leading: randomAvatar(
                DateTime.now().toIso8601String(),
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
            );
          }, childCount: 100)),
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
