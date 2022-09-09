import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/sign_in_screen.dart';
import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';

import '../helper/firebase_helper.dart';
import '../helper/hive_db_helper.dart';
import '../screens/home_screen.dart';

class AuthController extends GetxController {
  // static AuthController instance = Get.find();
  late Rx<User?> firebaseUser;

  final userInfo=Rxn<UserModel>();

  late Rx<GoogleSignInAccount?> googleSignInAccount;

  @override
  void onReady() {
    super.onReady();

    debugPrint("Going to ready auth controller");
    firebaseUser = Rx<User?>(FirebaseHelper.authInstance?.currentUser);
    debugPrint("User initialized");
    googleSignInAccount = Rx<GoogleSignInAccount?>(
        FirebaseHelper.googleSignInstance?.currentUser);

    if (firebaseUser.value != null) {
      updateUserLogin(isDisposing: false);
    }

    setUserInfo();

    firebaseUser.bindStream(FirebaseHelper.authInstance!.userChanges());
    ever(firebaseUser, _setInitialScreen);

    // googleSignInAccount
    //     .bindStream(FirebaseHelper.googleSignInstance!.onCurrentUserChanged);
    // ever(googleSignInAccount, _setInitialScreenGoogle);
  }

  @override
  void onClose() {
    if (firebaseUser.value != null) {
      updateUserLogin(isDisposing: true);
    }
  }

  _setInitialScreen(User? user) {
    if (Get.find<HiveDBHelper>().onboardingDone) {
      // if (user != null) {
      //   Get.offAllNamed(HomeScreen.routeName);
      // } else {
      //   Get.offAllNamed(SignInScreen.routeName);
      // }
      if (user == null) {
        // if the user is not found then the user is navigated to the Login Screen
        Get.offAllNamed(SignInScreen.routeName);
      }
    }

    // if (user == null) {
    //   // if the user is not found then the user is navigated to the Login Screen
    //   Get.offAllNamed(SignInScreen.routeName);
    // }
    // else {
    //   // if the user exists and logged in the the user is navigated to the Home Screen
    //   Get.offAllNamed(HomeScreen.routeName);
    // }
  }

  _setInitialScreenGoogle(GoogleSignInAccount? googleSignInAccount) {
    if (googleSignInAccount == null) {
      // if the user is not found then the user is navigated to the Register Screen
      Get.offAll(() => const SignInScreen());
    } else {
      // if the user exists and logged in the the user is navigated to the Home Screen
      Get.offAll(() => const HomeScreen());
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
      if (userCredential.user != null) {
        await setUserInfo();
        return true;
      } else {
        return false;
      }
    } catch (firebaseAuthException) {
      print(
          "Firebase auth exception coming is ${firebaseAuthException.toString()}");
      return false;
    }
  }

  Future<void> signOut() async {
    // showLoader();
    await FirebaseHelper.authInstance!.signOut();
  }

  Future<void> updateUserLogin({required bool isDisposing}) async {
    final userCollectionRef =
        FirebaseHelper.fireStoreInstance!.collection("user");

    final documentReference = userCollectionRef.doc(firebaseUser.value?.uid);

    final userDocument = await documentReference.get();

    if (userDocument.exists) {
      if (isDisposing) {
        await documentReference.update({
          "isOnline": false,
          "lastOnline": DateTime.now().millisecondsSinceEpoch.toString()
        });
      } else {
        await documentReference.update({"isOnline": true});
      }
    }
  }

  Future<void> setUserInfo() async {
    try {
      final userCollectionRef =
          FirebaseHelper.fireStoreInstance!.collection("user");

      final docReference =
          await userCollectionRef.doc(firebaseUser.value?.uid).get();

      if (docReference.exists) {
        userInfo?.value =
            UserModel.fromJson(docReference.data() as Map<String, dynamic>);
      }
    } catch (e, s) {
      print(
          "Exception coming in set user info ${e.toString()} ${s.toString()}");
    }
  }

}
