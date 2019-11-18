import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<FirebaseUser> get getUser => _firebaseAuth.currentUser();
  Stream<FirebaseUser> get user {
    return _firebaseAuth.onAuthStateChanged;
  }

  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final AuthCredential credential =
          EmailAuthProvider.getCredential(email: email, password: password);

      FirebaseUser user =
          (await _firebaseAuth.signInWithCredential(credential)).user;
      updateUserData(user);

      return user;
    } on PlatformException catch (e) {
      print(e);
      return null;
    }
  }

  Future<FirebaseUser> createUserWithEmailAndPassword(
      String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    updateUserData(user);
    return user;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<FirebaseUser> signInWithGoogle() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      FirebaseUser user =
          (await _firebaseAuth.signInWithCredential(credential)).user;
      updateUserData(user);

      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<void> signOut() {
    _googleSignIn.signOut();
    return _firebaseAuth.signOut();
  }

  Future<void> updateUserData(FirebaseUser user) {
    DocumentReference reportRef = _db.collection("reports").document(user.uid);

    return reportRef.setData({
      "uid": user.uid,
      "lastActivity": DateTime.now(),
    }, merge: true);
  }
}
