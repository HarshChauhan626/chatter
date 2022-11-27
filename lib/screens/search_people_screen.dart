import 'package:animations/animations.dart';
import 'package:chat_app/controllers/search_people_controller.dart';
import 'package:chat_app/widgets/custom_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:sizer/sizer.dart';

import '../models/user_model.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_route_builder.dart';
import 'chat_screen.dart';

class SearchPeopleScreen extends StatelessWidget {
  SearchPeopleScreen({Key? key}) : super(key: key);

  static const String routeName = "/search_people";

  TextEditingController searchEditingController = TextEditingController();

  FocusNode inputNode = FocusNode();

  SearchPeopleController controller =
      Get.find<SearchPeopleController>();

  static Route route() {
    return CustomRouteBuilder(page: SearchPeopleScreen(), routeName: routeName);
  }

  @override
  Widget build(BuildContext context) {
    print("Build called");
    return CustomSafeArea(
        child: Scaffold(
            appBar: getAppBar(context),
            body: Obx((){
              if (controller.searchText.isNotEmpty) {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                    ),
                  );
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.userList.value.length,
                      itemBuilder: (context, index) {
                        return getSearchResultItem(
                            controller.userList.value[index]);
                      });
                }
              } else {
                print("Show empty container");
                return Container();
              }
            })
        )
    );
  }

  Widget getSearchResultItem(UserModel userModel) {

    return ListTile(
      onTap: ()async{
        String? roomId;
        SearchPeopleController searchPeopleController=Get.find<SearchPeopleController>();

        roomId=await searchPeopleController.getRoomId(userModel.uid);

        Map<String,dynamic> arguments={};

        if(roomId!=null){
          arguments["roomId"]=roomId;
        }
        arguments["receiverModel"]=userModel;
        Get.toNamed(ChatScreen.routeName,arguments: arguments);
      },
      title: Text(userModel.userName.toString()),
      leading: CircleAvatar(
        radius: 20.0,
        child:

          userModel.profilePicture!.isNotEmpty
            ?CircleAvatar(
              backgroundImage: NetworkImage(userModel.profilePicture!,
              ),
            )
          :randomAvatar(
            "Harsh",
            height: 30,
            width: 30,
          )
      ),
    );
  }

  PreferredSizeWidget getAppBar(context) {
    // FocusScope.of(context).requestFocus(inputNode);
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
            onChanged: (value) async {
              controller.searchText.value=value;
              await controller.searchPeople();
            },
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
                prefixIcon: IconButton(
                  icon: const Icon(CupertinoIcons.back),
                  onPressed: () {
                    Get.back();
                  },
                ),
                hintText: "Search people",
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.searchText.value="";
                    searchEditingController.text="";
                  },
                )),
          ),
        ));
  }
}


// https://stackoverflow.com/questions/64906620/flutter-passing-multiple-data-with-getx

// https://stackoverflow.com/questions/72433897/flutter-how-to-create-this-kind-of-animated-search-bar

// https://stackoverflow.com/questions/63233521/how-to-populate-list-with-firestore-stream-using-getx