import 'package:chat_app/helper/firebase_helper.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

class SearchController extends GetxController{
  RxString searchText="".obs;

  // Future<List<UserModel>> searchUsers(){
  //   final userCollectionRef=FirebaseHelper.fireStoreInstance!.collection("users");
  //   userCollectionRef
  // }
  //
  //
  // Future<List<UserModel>> getAllUsers(){
  //   final userCollectionRef=FirebaseHelper.fireStoreInstance!.collection("users");
  //
  // }


}