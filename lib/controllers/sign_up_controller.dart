import 'package:chat_app/constants.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

class SignUpController extends GetxController{
  RxString email="".obs;
  RxString password="".obs;
  RxString userName="".obs;
  RxString firstName="".obs;
  RxString lastName="".obs;

  RxBool isLoading=false.obs;


  void registerUser()async{

    AuthController authController=Get.find<AuthController>();

    try{
      isLoading.value=true;
      await authController.register(email.value, password.value);
      isLoading.value=false;
    }
    catch(e){
      isLoading.value=false;
    }
  }


}