import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseHelper{
  static FirebaseAuth? authInstance;
  static FirebaseFirestore? fireStoreInstance;
  static GoogleSignIn? googleSignInstance;
  static FirebaseStorage? firebaseStorage;

  static User? user;

  static void initInstances(){
    authInstance=FirebaseAuth.instance;
    fireStoreInstance=FirebaseFirestore.instance;
    googleSignInstance=GoogleSignIn();
    firebaseStorage=FirebaseStorage.instance;
  }


}