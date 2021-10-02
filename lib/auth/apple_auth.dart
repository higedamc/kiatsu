import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

String generateNonce([int length = 32]) {
  final charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

/// SHA256のハッシュ値生成
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}


class AppleAuthUtil {
  // static final AppleSignIn _appleSignIn = AppleSignIn(
  //   // clientId: '********',
  //   // clientSecret: '********',
  //   // redirectUrl: 'https://********.firebaseapp.com/__/auth/handler',

  // );

  /// サインインしてるかどうか
  static bool isSignedIn() => FirebaseAuth.instance.currentUser != null;
  /// 現在のユーザー情報
  static User? getCurrentUser() => FirebaseAuth.instance.currentUser;
  // emailが認証済みかどうか
  static bool isEmailVerified() => getCurrentUser()!.emailVerified == true;

  

  /// サインアウト
  static void signOut() => FirebaseAuth.instance.signOut();

  /// サインイン
  static Future<User?> signIn(BuildContext context) async {
    final UserCredential credential = await signInWithApple();
    // final User user = await signInWithApple();
    return credential.user;
    // return user;
  }
  static Future<void> forceLink(BuildContext context) async {
    final _auth = FirebaseAuth.instance;
    final _user = _auth.currentUser;
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);


      
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oAuthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      await _user!.linkWithCredential(oAuthCredential);
  }


  static Future<UserCredential> signInWithApple() async {
    
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    var userCredential;
    // Request credential for the currently signed in Apple account.
    try {
      
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oAuthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
      print(userCredential);

    } catch (e) {
      print(e.toString());
    }
    print('サインインされました');
    return userCredential;
  }

}
