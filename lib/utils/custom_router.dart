import 'package:chat_app/controllers/search_people_controller.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/forgot_password_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/onboarding_screen.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/screens/reset_password.dart';
import 'package:chat_app/screens/search_conversation_screen.dart';
import 'package:chat_app/screens/search_people_screen.dart';
import 'package:chat_app/screens/sign_in_screen.dart';
import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/chat_controller.dart';

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
      case SearchPeopleScreen.routeName:
        return SearchPeopleScreen.route();
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

class GetXRouter {
  static List<GetPage<dynamic>>? getXPages() {
    return [
      GetPage(
        name: SplashScreen.routeName,
        page: () => SplashScreen(),
        middlewares: [MyMiddleware()],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: HomeScreen.routeName,
        page: () => HomeScreen(),
        middlewares: [MyMiddleware()],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: OnboardingScreen.routeName,
        page: () => OnboardingScreen(),
        middlewares: [MyMiddleware()],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: ChatScreen.routeName,
        page: () => ChatScreen(),
        middlewares: [MyMiddleware()],
        binding: BindingsBuilder(() {
          Get.put<ChatController>(ChatController());
        }),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300),
      ),
      GetPage(
        name: SignInScreen.routeName,
        page: () => SignInScreen(),
        middlewares: [MyMiddleware()],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: SignUpScreen.routeName,
        page: () => SignUpScreen(),
        middlewares: [MyMiddleware()],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: ForgotPasswordScreen.routeName,
        page: () => ForgotPasswordScreen(),
        middlewares: [MyMiddleware()],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: ResetPasswordScreen.routeName,
        page: () => ResetPasswordScreen(),
        middlewares: [MyMiddleware()],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: ProfileScreen.routeName,
        page: () => ProfileScreen(),
        middlewares: [MyMiddleware()],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: SearchConversationScreen.routeName,
        page: () => SearchConversationScreen(),
        middlewares: [MyMiddleware()],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      GetPage(
        name: SearchPeopleScreen.routeName,
        page: () => SearchPeopleScreen(),
        middlewares: [MyMiddleware()],
        binding: BindingsBuilder(() {
          Get.put<SearchPeopleController>(SearchPeopleController());
        }),
        transition: Transition.native,
        // customTransition: SizeTransition(),
        transitionDuration: const Duration(milliseconds: 500),
      )
    ];
  }
}

class MyMiddleware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    debugPrint("Navigating to page ${page?.name}");
    return super.onPageCalled(page);
  }

}
