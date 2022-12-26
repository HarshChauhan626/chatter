import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseHelper {
  static FirebaseAuth? authInstance;
  static FirebaseFirestore? fireStoreInstance;
  static GoogleSignIn? googleSignInstance;
  static FirebaseStorage? firebaseStorage;
  static FirebaseMessaging? firebaseMessaging;

  static User? user;

  static void initInstances() {
    authInstance = FirebaseAuth.instance;
    fireStoreInstance = FirebaseFirestore.instance;
    // fireStoreInstance
    //     ?.enablePersistence(const PersistenceSettings(synchronizeTabs: true));
    fireStoreInstance?.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    googleSignInstance = GoogleSignIn();
    firebaseStorage = FirebaseStorage.instance;
    firebaseMessaging = FirebaseMessaging.instance;
  }
}
