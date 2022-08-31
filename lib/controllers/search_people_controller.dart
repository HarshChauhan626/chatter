import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../helper/firebase_helper.dart';
import '../models/user_model.dart';

class SearchPeopleController extends GetxController{

  RxBool isLoading=false.obs;

  TextEditingController searchTextController=TextEditingController();

  RxString searchText="".obs;

  RxList userList=[].obs;


  Future<void> searchPeople()async{
    try {
      isLoading.value=true;
      final userCollectionRef =
      FirebaseHelper.fireStoreInstance!.collection("user");
      final result=await userCollectionRef.where("userName",isGreaterThanOrEqualTo: searchText.value,isLessThan: searchText.value+"z").get();
      userList.value=result.docs.map((e) => UserModel.fromJson(e.data())).toList();
      isLoading.value=false;
    } catch (e) {
      isLoading.value=false;
      rethrow;
    }
  }


}

// https://stackoverflow.com/questions/67037491/flutter-firebase-search-for-documents-which-contain-a-string-for

// https://stackoverflow.com/questions/50870652/flutter-firebase-basic-query-or-basic-search-code