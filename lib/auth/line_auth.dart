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
    UserCredential? result2;

    try {
      final LoginResult result = await LineSDK.instance.login(
        option: LoginOption(false, 'aggressive'),
      );
      final lineUserId = result.userProfile?.userId;
      // final lineUserProfile = result.userProfile;

      final calls =
          FirebaseFunctions.instanceFor().httpsCallable('fetchCustomToken');
      final response = await calls.call({
        'userId': lineUserId,
      });
      final result2 = await FirebaseAuth.instance
          .signInWithCustomToken(response.data['customToken']);

      return result2;
    } on PlatformException catch (e) {
      var message = 'エラーが発生しました';
      if (e.code == '3063') {
        message = 'キャンセルしました';
      }
      throw PlatformException(code: e.code, message: message);
    }
  }
}
