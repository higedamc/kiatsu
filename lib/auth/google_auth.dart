


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// 参考: https://qiita.com/smiler5617/items/f94fdc1afe088586715b

// TODO: 本リリースまでに実装する

class GoogleAuthUtil {
  // static final GoogleSignIn _google = GoogleSignIn(

  //   scopes: [
  //   'email',
  //   'https://www.googleapis.com/auth/contacts.readonly',
  // ],


  // );

  /// サインイン中か
  static bool isSignedIn() => FirebaseAuth.instance.currentUser != null;

  /// 現在のユーザー情報
  static User? getCurrentUser() => FirebaseAuth.instance.currentUser;

  /// サインアウト
  static void signOut() => FirebaseAuth.instance.signOut();

  /// サインイン
  static Future<User?> signIn(BuildContext context) async {
    final UserCredential credential = await signInWithGoogle(context);
    return credential.user;
  }

  static Future<UserCredential> signInWithGoogle(BuildContext context) async {
    final _user = FirebaseAuth.instance.currentUser;

    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn() as GoogleSignInAccount;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    
    final AuthCredential googleAuthCredential =
        GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        return await _user!.linkWithCredential(googleAuthCredential);
  }
}