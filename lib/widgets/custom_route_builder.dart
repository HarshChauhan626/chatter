import 'package:flutter/material.dart';

class CustomRouteBuilder extends PageRouteBuilder {
  final Widget page;
  String routeName;
  Object? arguments;
  CustomRouteBuilder({required this.page,required this.routeName,this.arguments})
      : super(
      settings: RouteSettings(
        arguments: arguments,
        name: routeName,
      ),
            pageBuilder: (context, animation, anotherAnimation) => page,
            transitionDuration: const Duration(seconds: 2),
            reverseTransitionDuration: const Duration(seconds: 2),
            transitionsBuilder: (context, animation, anotherAnimation, child) {
              animation = CurvedAnimation(
                curve: Curves.fastLinearToSlowEaseIn,
                parent: animation,
                reverseCurve: Curves.fastOutSlowIn,
              );
              return FadeTransition(opacity: animation, child: page);
            });
}
