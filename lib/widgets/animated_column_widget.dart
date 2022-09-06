import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';


enum AnimationType{horizontal,vertical}

class AnimatedColumn extends StatelessWidget {
  List<Widget> children;
  CrossAxisAlignment? crossAxisAlignment;
  MainAxisAlignment? mainAxisAlignment;
  AnimationType? animationType;
  AnimatedColumn(
      {Key? key,
      required this.children,
      this.crossAxisAlignment,
      this.mainAxisAlignment,this.animationType})
      : super(key: key);


  AnimationType? _animationType;

  @override
  Widget build(BuildContext context) {
    _animationType=animationType??AnimationType.horizontal;
    return AnimationLimiter(
        child: Column(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 600),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: _animationType==AnimationType.horizontal?0.0:50.0,
            horizontalOffset: _animationType==AnimationType.horizontal?50.0:0.0,
                  child: FadeInAnimation(
                child: widget,
              )),
          children: children
      ),
    ));
  }
}
