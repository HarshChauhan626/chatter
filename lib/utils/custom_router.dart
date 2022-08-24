import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/forgot_password_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/onboarding_screen.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/screens/reset_password.dart';
import 'package:chat_app/screens/search_conversation_screen.dart';
import 'package:chat_app/screens/sign_in_screen.dart';
import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    debugPrint('Route: ${settings.name}');
    switch (settings.name) {
      case SplashScreen.routeName:
        return SplashScreen.route();
      case OnboardingScreen.routeName:
        return OnboardingScreen.route();
      case HomeScreen.routeName:
        return HomeScreen.route();
      case ChatScreen.routeName:
        return ChatScreen.route();
      case SignInScreen.routeName:
        return SignInScreen.route();
      case SignUpScreen.routeName:
        return SignUpScreen.route();
      case ForgotPasswordScreen.routeName:
        return ForgotPasswordScreen.route();
      case ResetPasswordScreen.routeName:
        return ResetPasswordScreen.route();
      case ProfileScreen.routeName:
        return ProfileScreen.route();
      case SearchConversationScreen.routeName:
        return SearchConversationScreen.route();
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong!'),
        ),
      ),
    );
  }
}
