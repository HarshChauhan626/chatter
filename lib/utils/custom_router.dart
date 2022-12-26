import 'package:chat_app/controllers/search_people_controller.dart';
import 'package:chat_app/controllers/update_profile_controller.dart';
import 'package:chat_app/features/chat/chat_screen.dart';
import 'package:chat_app/features/forgot_password/forgot_password_screen.dart';
import 'package:chat_app/features/home/home_screen.dart';
import 'package:chat_app/features/onboarding/onboarding_screen.dart';
import 'package:chat_app/features/profile/receiver_profile_screen.dart';
import 'package:chat_app/features/reset_password/reset_password.dart';
import 'package:chat_app/features/search_conversations/search_conversation_screen.dart';
import 'package:chat_app/features/search_people/search_people_screen.dart';
import 'package:chat_app/features/sign_in/sign_in_screen.dart';
import 'package:chat_app/features/sign_up/sign_up_screen.dart';
import 'package:chat_app/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/chat_controller.dart';
import '../controllers/home_controller.dart';
import '../features/account/profile_picture_screen.dart';
import '../features/account/profile_screen.dart';
import '../features/account/update_profile_screen.dart';

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
        page: () => const SplashScreen(),
        middlewares: [MyMiddleware()],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: HomeScreen.routeName,
        page: () => const HomeScreen(),
        middlewares: [MyMiddleware()],
        binding: BindingsBuilder(() {
          Get.put<HomeController>(HomeController());
        }),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: OnboardingScreen.routeName,
        page: () => const OnboardingScreen(),
        middlewares: [MyMiddleware()],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: ChatScreen.routeName,
        page: () => ChatScreen(),
        middlewares: [MyMiddleware()],
        binding: BindingsBuilder(() {
          Get.put<ChatController>(ChatController());
        }),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: SignInScreen.routeName,
        page: () => const SignInScreen(),
        middlewares: [MyMiddleware()],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: SignUpScreen.routeName,
        page: () => const SignUpScreen(),
        middlewares: [MyMiddleware()],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: ForgotPasswordScreen.routeName,
        page: () => const ForgotPasswordScreen(),
        middlewares: [MyMiddleware()],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: ResetPasswordScreen.routeName,
        page: () => const ResetPasswordScreen(),
        middlewares: [MyMiddleware()],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: ProfileScreen.routeName,
        page: () => const ProfileScreen(),
        middlewares: [MyMiddleware()],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: SearchConversationScreen.routeName,
        page: () => SearchConversationScreen(),
        middlewares: [MyMiddleware()],
        transition: Transition.fade,
        transitionDuration: const Duration(milliseconds: 200),
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
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: UpdateProfileScreen.routeName,
        page: () => UpdateProfileScreen(),
        middlewares: [MyMiddleware()],
        binding: BindingsBuilder(() {
          Get.put<UpdateProfileController>(UpdateProfileController());
        }),
        transition: Transition.rightToLeft,
        // customTransition: SizeTransition(),
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: ProfilePictureScreen.routeName,
        page: () => const ProfilePictureScreen(),
        middlewares: [MyMiddleware()],
        transition: Transition.native,
        // customTransition: SizeTransition(),
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: ReceiverProfileScreen.routeName,
        page: () => const ReceiverProfileScreen(),
        middlewares: [MyMiddleware()],
        transition: Transition.rightToLeft,
        // customTransition: SizeTransition(),
        transitionDuration: const Duration(milliseconds: 200),
      ),
    ];
  }
}

class MyMiddleware extends GetMiddleware {
  GetPage? getPage;

  @override
  GetPage? onPageCalled(GetPage? page) {
    debugPrint("Navigating to page ${page?.name}");
    getPage = page;
    return super.onPageCalled(page);
  }

  @override
  void onPageDispose() {
    // TODO: implement onPageDispose
    super.onPageDispose();
    debugPrint("Disposing page ${getPage?.name}");
  }
}
