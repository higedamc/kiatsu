import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


class GoogleAuthUtil {
  /// サインイン中か
  bool? isSignedIn() => FirebaseAuth.instance.currentUser != null;

  /// 現在のユーザー情報
  User? getCurrentUser() => FirebaseAuth.instance.currentUser;

  // emailが認証済みかどうか
  bool? isEmailVerified() => getCurrentUser()!.emailVerified == true;

  /// サインアウト
  void signOut() => FirebaseAuth.instance.signOut();

  // Firerbaseアカウント削除
  void deleteAccount() => FirebaseAuth.instance.currentUser!.delete();

  /// サインイン
  Future<User?> signIn(BuildContext context) async {
    final credential = await signInWithGoogle(context);
    return credential!.user;
  }

  // TODO: サインインがうまくいくか (Firebaseに反映されるか) 実機で検証する
  static Future<UserCredential?> signInWithGoogle(
    BuildContext context,
  ) async {
    try {
      final createdAt = DateTime.now();
      final firebaseStore = FirebaseFirestore.instance;
      final users = firebaseStore.collection('users');
      // var count = 0;

      final auth = FirebaseAuth.instance;
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth!.accessToken,
        idToken: googleAuth.idToken,
      );

      return auth.signInWithCredential(credential).then(
        (authResult) async {
          final displayName = authResult.user?.displayName;
          final email = authResult.user?.email;
          final photoUrl = authResult.user?.photoURL;
          final uid = authResult.user?.uid;
          final providerData = authResult.user?.providerData;
          final firebaseUser = authResult.user;
          final setData = <String, dynamic>{
            'createdAt': createdAt.toIso8601String(),
            'authProvider': 'google.com',
          };
          await users
              .doc(authResult.user!.uid)
              .set(setData, SetOptions(merge: true));
          if (kDebugMode) {
            print(
              'サインインされました: uid: $uid displayName: $displayName, email: $email, photoUrl: $photoUrl, uid: $uid, providerData: $providerData, firebaseUser: $firebaseUser',
            );
          }
          return authResult;
          // Navigator.popUntil(context, (_) => count++ >= 1);
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text('ログインされました。'),
          //   ),
          // );
        },
      );
    } on PlatformException catch (e) {
      var message = 'キャンセルしました';
      if (e.code == '3063') {
        message = 'エラーが発生しました';
      }
      throw FirebaseAuthException(code: e.code, message: message);
    }
  }
}
