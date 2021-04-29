import 'dart:convert';
import 'dart:math';

import 'package:apple_sign_in/apple_sign_in.dart';
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

/// Returns the sha256 hash of [input] in hex notation.
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

  /// サインイン中か
  static bool isSignedIn() => FirebaseAuth.instance.currentUser != null;

  /// 現在のユーザー情報
  static User getCurrentUser() => FirebaseAuth.instance.currentUser;

  /// サインアウト
  static void signOut() => FirebaseAuth.instance.signOut();

  /// サインイン
  static Future<User> signIn(BuildContext context) async {
    final UserCredential credential = await signInWithApple(context);
    return credential.user;
  }

  static Future<UserCredential> signInWithApple(BuildContext context) async {

    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );
    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );
    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }
}