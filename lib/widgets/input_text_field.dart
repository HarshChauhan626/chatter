import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/utils/enums.dart';
import 'package:flutter/material.dart';

class InputTextField extends StatefulWidget {
  final Function onChangedValue;
  final String hintText;
  final InputTextType inputTextType;

  const InputTextField({Key? key,required this.onChangedValue,required this.hintText,required this.inputTextType}) : super(key: key);

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {

  TextEditingController inputController=TextEditingController();

  bool passwordVisible=false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: inputController,
      onChanged: (value){
        widget.onChangedValue(value);
      },
      obscureText: getTextVisibility(),
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.left,
      style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.bold),
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
        hintText: widget.hintText,
        filled: true,
        hintStyle: const TextStyle(
            color: Colors.grey
        ),
        fillColor: AppColors.textFieldBackgroundColor,
        focusedBorder:OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2.0),
          borderRadius: BorderRadius.circular(15.0),
        ),
        border:OutlineInputBorder(
          // borderSide: const BorderSide(color: AppColors.textFieldBackgroundColor, width: 2.0),
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(15.0),
        ),
        suffixIcon: widget.inputTextType==InputTextType.password?InkWell(onTap: (){
          setState(() {
            passwordVisible=!passwordVisible;
          });
        }, child: Icon(passwordVisible?Icons.visibility:Icons.visibility_off,color: AppColors.greyColor,)):null
      ),
    );
  }


  bool getTextVisibility(){
    if(widget.inputTextType==InputTextType.password && !passwordVisible){
      return true;
    }
    return false;
  }


}






