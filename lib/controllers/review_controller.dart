import 'package:get/get.dart';

class ReviewController extends GetxController{
  RxBool isLoading=false.obs;
  RxDouble rating=0.0.obs;
  RxString comments="".obs;
  RxBool isSuccessful=false.obs;
  RxBool isRequestComplete=false.obs;


  Future<void> submitReview()async{
    try{
      isLoading.value=true;
      await Future.delayed(const Duration(seconds: 4));
      isLoading.value=false;
      isRequestComplete.value=true;
      isSuccessful.value=true;
    }
    catch(e){
      isLoading.value=false;
      // TODO:- Show snackbar here
    }
  }



}