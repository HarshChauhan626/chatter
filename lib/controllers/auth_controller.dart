import 'package:chat_app/screens/sign_in_screen.dart';
import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';

import '../helper/firebase_helper.dart';
import '../screens/home_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> firebaseUser;

  late Rx<GoogleSignInAccount?> googleSignInAccount;

  @override
  void onReady() {
    super.onReady();
    // auth is comning from the constants.dart file but it is basically FirebaseAuth.instance.
    // Since we have to use that many times I just made a constant file and declared there

    firebaseUser = Rx<User?>(FirebaseHelper.authInstance?.currentUser);
    googleSignInAccount = Rx<GoogleSignInAccount?>(
        FirebaseHelper.googleSignInstance?.currentUser);

    firebaseUser.bindStream(FirebaseHelper.authInstance!.userChanges());
    ever(firebaseUser, _setInitialScreen);

    googleSignInAccount
        .bindStream(FirebaseHelper.googleSignInstance!.onCurrentUserChanged);
    ever(googleSignInAccount, _setInitialScreenGoogle);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      // if the user is not found then the user is navigated to the Login Screen
      Get.offAll(() => const SignInScreen());
    } else {
      // if the user exists and logged in the the user is navigated to the Home Screen
      Get.offAll(() => const HomeScreen());
    }
  }

  _setInitialScreenGoogle(GoogleSignInAccount? googleSignInAccount) {
    if (googleSignInAccount == null) {
      // if the user is not found then the user is navigated to the Register Screen
      Get.offAll(() => const SignUpScreen());
    } else {
      // if the user exists and logged in the the user is navigated to the Home Screen
      Get.offAll(() => const SignInScreen());
    }
  }

  void signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleSignInAccount =
          await FirebaseHelper.googleSignInstance!.signIn();

      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        await FirebaseHelper.authInstance!
            .signInWithCredential(credential)
            .catchError((onErr) => debugPrint(onErr));
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      debugPrint(e.toString());
    }
  }

  Future<UserCredential> register(String email, password) async {
    try {
      UserCredential userCredential = await FirebaseHelper.authInstance!
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } catch (firebaseAuthException) {
      debugPrint(firebaseAuthException.toString());
      rethrow;
    }
  }

  Future<bool> login(String email, password) async {
    try {
      UserCredential userCredential = await FirebaseHelper.authInstance!
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user != null ? true : false;
    } catch (firebaseAuthException) {
      return false;
    }
  }

  void signOut() async {
    await FirebaseHelper.authInstance!.signOut();
  }
}
