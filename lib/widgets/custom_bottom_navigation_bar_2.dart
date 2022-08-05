import 'package:chat_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BottomNavbar extends StatefulWidget {
  final Function callback;
  const BottomNavbar({Key? key, required this.callback}) : super(key: key);
  @override
  BottomNavbarState createState() => BottomNavbarState();
}

class BottomNavbarState extends State<BottomNavbar> {
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: Container(
        // margin: EdgeInsets.all(20),
        // height: screenWidth * .155,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular(10.0),
          //   topRight: Radius.circular(10.0)
          // ),
        ),
        // child: ListView.builder(
        //   itemCount: 4,
        //   scrollDirection: Axis.horizontal,
        //   padding: EdgeInsets.symmetric(horizontal: screenWidth * .024),
        //   itemBuilder: (context, index) => ,
        // ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int index = 0; index < 3; index++)
                InkWell(
                  onTap: () {
                    setState(() {
                      currentIndex = index;
                      widget.callback(index);
                      HapticFeedback.lightImpact();
                    });
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Container(
                    width: screenWidth * .2125,
                    // color: Colors.red,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedPadding(
                            curve: Curves.fastLinearToSlowEaseIn,
                            padding: index == currentIndex
                                ? const EdgeInsets.only(bottom: 4.0)
                                : const EdgeInsets.only(bottom: 0.0),
                            duration: Duration(seconds: 1),
                            child: Icon(
                              index == currentIndex
                                  ? listOfSelectedIcons[index]
                                  : listOfIcons[index],
                              size: 30.0,
                              color: index == currentIndex
                                  ? Colors.black
                                  : Color(0xff91a1af),
                            )),
                        if (index == currentIndex)
                          Container(
                            height: 6.0,
                            width: 6.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                color: AppColors.primaryColor),
                          )
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  List<IconData> listOfIcons = [
    Icons.home_outlined,
    Icons.search_outlined,
    Icons.person_outlined,
  ];

  List<IconData> listOfSelectedIcons = [Icons.home, Icons.search, Icons.person];
}
