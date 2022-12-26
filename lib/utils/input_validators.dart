import 'package:chat_app/utils/extensions.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';

class InputValidators{
  static String? passwordValidator(String? value){
    if(value==null || value.isEmpty){
      return "Please enter password";
    }
    if(GetUtils.isLengthLessThan(value, 8)){
      return "Password too short";
    }
    if(!value.containsUppercase || !value.containsLowercase || !value.containsNumerics){
      return "Password should contain at least one uppercase,lowercase and numeric characters";
    }
    return null;
  }

  static String? usernameValidator(String? value){
    if (GetUtils.isNullOrBlank(value ?? "")??false) {
      return "Please enter username";
    }
    if(GetUtils.isLengthLessThan(value,7)){
      return "Username should be contain at least 7 characters";
    }
    return null;
  }

  static String? emailValidator(String? value){
    if (!GetUtils.isEmail(value ?? "")) {
      return "Email not valid";
    }
    return null;
  }
}