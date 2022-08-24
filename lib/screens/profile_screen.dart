import 'package:chat_app/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:sizer/sizer.dart';

import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../widgets/custom_route_builder.dart';
import '../widgets/custom_safe_area.dart';



class ListTileItem{
  String title;
  String subtitle;
  String routeName;
  ListTileItem(this.title,this.subtitle,this.routeName);
}


List<ListTileItem> generalList=[
  ListTileItem(AppStrings.profileSettings,AppStrings.updateProfile,'/update_profile'),
  ListTileItem(AppStrings.privacy,AppStrings.changeYourPassword,'/reset_password'),
  ListTileItem(AppStrings.settings,AppStrings.personaliseAndChange,'/settings'),
  ListTileItem(AppStrings.spreadTheWord, AppStrings.inviteYourFriends, '/invite_friends'),
];

List<ListTileItem> supportList=[
  ListTileItem(AppStrings.aboutUs,AppStrings.knowMoreAboutUs,'/about_us'),
  ListTileItem(AppStrings.reportAProblem,AppStrings.reachOutToUs,'/report'),
];



class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const String routeName = '/profile';

  static Route route() {
    return CustomRouteBuilder(
        page: const ProfileScreen(), routeName: routeName);
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        // backgroundColor: AppColors.textFieldBackgroundColor,
        appBar: AppBar(
          // backgroundColor: AppColors.textFieldBackgroundColor,
          title: const Text('Profile'),
          leading: IconButton(
            icon: const Icon(
              CupertinoIcons.back,
              color: AppColors.blackTextColor,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 3.h,
              ),
              InkWell(
                child: randomAvatar(
                  "Harsh Chauhan",
                  height: 120,
                  width: 120,
                ),
                onTap: () {
                  Get.toNamed('/edit_profile');
                },
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
                  child: Text(
                    'Harsh Chauhan',
                    style: Theme.of(context).textTheme.headline6,
                  )),
              Text(
                "harshchauhan5180@gmail.com",
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    fontWeight: FontWeight.bold, color: AppColors.greyColor),
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 3.h),
              //   child: ElevatedButton(
              //     child: const Text(AppStrings.editProfile),
              //     onPressed: () {},
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 40.0,bottom: 10.0),
                child: getGeneralList(context,generalList,"General"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 10.0,bottom: 40.0),
                child: getGeneralList(context,supportList,"Support"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 1.3.h),
                child: ElevatedButton(
                  child: const Text(AppStrings.logout),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget getGeneralList(BuildContext context,List<ListTileItem> tileItemList,String category){
    return Column(
      children: [
        Align(alignment: Alignment.centerLeft,child: Text(category,style: Theme.of(context).textTheme.bodyText1?.copyWith(color: AppColors.greyColor),)),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Card(
            color: AppColors.textFieldBackgroundColor,
            elevation: 2.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: tileItemList.length,
                  itemBuilder: (context,index){
                return ListTile(
                  title: Text(tileItemList[index].title,style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900
                  ),),
                  subtitle: Text(tileItemList[index].subtitle,style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: AppColors.greyColor
                  ),),
                  trailing: Icon(CupertinoIcons.forward,color: AppColors.greyColor,),
                );
              },
                separatorBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.only(left:17.0),
                    child: Divider(
                      color: AppColors.greyColor?.darken(10),
                    ),
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
