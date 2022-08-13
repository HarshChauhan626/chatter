import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/sign_in_screen.dart';
import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../globals.dart';
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

    firebaseUser = Rx<User?>(Globals.auth?.currentUser);
    googleSignInAccount = Rx<GoogleSignInAccount?>(Globals.googleSign?.currentUser);


    firebaseUser.bindStream(Globals.auth!.userChanges());
    ever(firebaseUser, _setInitialScreen);


    googleSignInAccount.bindStream(Globals.googleSign!.onCurrentUserChanged);
    ever(googleSignInAccount, _setInitialScreenGoogle);
  }

  _setInitialScreen(User? user) {
    if (user == null) {

      // if the user is not found then the user is navigated to the Login Screen
      Get.offAll(() => const SignInScreen());

    } else {

      // if the user exists and logged in the the user is navigated to the Home Screen
      Get.offAll(()=>const HomeScreen());

    }
  }

  _setInitialScreenGoogle(GoogleSignInAccount? googleSignInAccount) {
    if (googleSignInAccount == null) {

      // if the user is not found then the user is navigated to the Register Screen
      Get.offAll(() => const SignUpScreen());

    } else {

      // if the user exists and logged in the the user is navigated to the Home Screen
      Get.offAll(()=>const SignInScreen());

    }
  }

  void signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await Globals.googleSign!.signIn();

      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        await Globals.auth!
            .signInWithCredential(credential)
            .catchError((onErr) => print(onErr));
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      print(e.toString());
    }
  }

  Future<void> register(String email, password) async {
    try {
      await Globals.auth!.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (firebaseAuthException) {
      debugPrint(firebaseAuthException.toString());
    }
  }

  Future<bool> login(String email, password) async {
    try {
      UserCredential userCredential=await Globals.auth!.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user!=null?true:false;
    } catch (firebaseAuthException) {
      return false;
    }
  }

  void signOut() async {
    await Globals.auth!.signOut();
  }
}