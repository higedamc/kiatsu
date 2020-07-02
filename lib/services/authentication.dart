import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kiatsu/model/users.dart';

// Auth用のViewModelっぽいページ
//https://ayusch.com/flutter-firebase-authentication-tutorial/

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<String> signUpWithMisskey(String customToken);

  // Future<String> signUpWithSpotify(String customToken);

  Future<AuthResult> signWithCredential(AuthCredential credential);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final BaseUsers _users = new Users();

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    await _users.update(user.uid);
    Firestore.instance.collection("users").document(email).snapshots();
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    await _users.create(user.uid);
    Firestore.instance.collection("users").document(email).snapshots();
    return user.uid;
  }

  Future<String> signUpWithMisskey(String customToken) async {
    AuthResult result =
        await _firebaseAuth.signInWithCustomToken(token: customToken);
    FirebaseUser user = result.user;
    await _users.create(user.uid);
    Firestore.instance.collection("users").document(customToken).snapshots();
    return user.uid;
  }

  Future<AuthResult> signWithCredential(AuthCredential credential) async {
    return _firebaseAuth.signInWithCredential(credential);
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}
