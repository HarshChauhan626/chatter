import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/utils/extensions.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final Color? primaryColor;
  final Function()? onPressed;
  final Widget child;
  final double? elevation;
  const CustomElevatedButton({Key? key,this.primaryColor,this.elevation,required this.onPressed,required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Color primary=primaryColor??AppColors.primaryColor;

    return ElevatedButton(
        style:ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return primary;
              } else if (states.contains(MaterialState.disabled)) {
                return primary.darken(30);
              }
              return primary; // Use the component's default./ Use the component's default.
            },
          ),
          elevation: MaterialStateProperty.resolveWith((states) => elevation??6.0),),
      onPressed: onPressed, child: child,
    );
  }
}
