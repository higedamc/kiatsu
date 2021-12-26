import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:cloud_functions/cloud_functions.dart';

// TODO: 今週中に実装する
//参照すべきURL: https://zenn.dev/yskuue/articles/410e5b787b354a
//参照すべきURL2: https://www.youtube.com/watch?v=TT_RoA4ygEU&list=PLmg-gZJdxKEUbB8c-OPgCcpibP2L1tm-w&index=1&t=1328s

class LineAuthUtil {
  /// サインイン中か
  static bool isSignedIn() => FirebaseAuth.instance.currentUser != null;

  /// 現在のユーザー情報
  static User? getCurrentUser() => FirebaseAuth.instance.currentUser;

  /// サインアウト
  static void signOut() => FirebaseAuth.instance.signOut();

  /// サインイン
  static Future<User?> signIn(BuildContext context) async {
    final UserCredential? credential = await signInWithLine(context);
    return credential?.user;
  }

  static Future<UserCredential?> signInWithLine(BuildContext context) async {
    try {
      final result = await LineSDK.instance.login(
          // option: LoginOption(false, 'aggressive'),
          );
      // final lineUserProfile = result.userProfile;
      // final lineUserId = lineUserProfile?.userId;
      final lineUserId = result.userProfile?.userId;

      print(lineUserId.toString());

      final callable = FirebaseFunctions.instanceFor(region: 'asia-east2')
          .httpsCallable('fetchCustomToken',
          options: HttpsCallableOptions(timeout: const Duration(seconds: 5)));
      final response = await callable.call({
        'userId': lineUserId,
      });
      return await FirebaseAuth.instance
          .signInWithCustomToken(response.data['customToken'])
          .then((authResult) async {
        final firebaseUser = authResult.user;
        print(firebaseUser);
        print(firebaseUser?.uid);
      });
    } on FirebaseAuthException catch (e) {
      var message = 'エラーが発生しました';
      if (e.code == '3063') {
        message = 'キャンセルしました';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.code),
      ));
      throw FirebaseAuthException(code: e.code, message: message);
    }
  }
}
