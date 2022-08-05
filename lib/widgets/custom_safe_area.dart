import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomSafeArea extends StatelessWidget {
  final Widget child;
  const CustomSafeArea({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark),
      child: SafeArea(
        child: child,
      ),
    );
  }
}
