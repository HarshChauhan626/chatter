import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Globals{
  static FirebaseAuth? auth;
  static FirebaseFirestore? firestore;
  static GoogleSignIn? googleSign;
}