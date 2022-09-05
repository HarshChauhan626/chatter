import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/app_colors.dart';

class LabelTextField extends StatefulWidget {
  String label;
  String? val;
  bool? isReadOnly;
  int? maxLines;
  LabelTextField({Key? key,required this.label,this.val,this.isReadOnly,this.maxLines}) : super(key: key);

  @override
  State<LabelTextField> createState() => _LabelTextFieldState();
}

class _LabelTextFieldState extends State<LabelTextField> {

  TextEditingController textEditingController=TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEditingController.text=widget.val??"";
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: widget.isReadOnly==false?false:true,
      controller: textEditingController,
      // expands: true,
      minLines: 1,
      maxLines: 12,
      style: Theme.of(context)
          .textTheme
          .bodyText1
          ?.copyWith(fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w400
        ),
        floatingLabelBehavior: textEditingController.text.isNotEmpty?FloatingLabelBehavior.always:FloatingLabelBehavior.auto,
        focusedBorder: OutlineInputBorder(
          borderSide:
          const BorderSide(color: AppColors.primaryColor, width: 2.0),
          borderRadius: BorderRadius.circular(15.0),
        ),
        border: OutlineInputBorder(
          borderSide:
          const BorderSide(color: AppColors.primaryColor, width: 2.0),
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}
