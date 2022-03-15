import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:cloud_functions/cloud_functions.dart';

// TODO: #152 createdAtの実装 =>
final DateTime createdAt = DateTime.now();
// users.doc(user?.uid).set({'createdAt': createdAt});
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
    int count = 0;
    try {
      final result = await LineSDK.instance.login(
        option: LoginOption(false, 'aggressive'),
      );
      //final lineUserProfile = result.userProfile;
      final lineUserId = result.userProfile?.userId;
      final displayName = result.userProfile?.displayName;
      // print(lineUserProfile.toString());

      final callable = FirebaseFunctions.instanceFor(region: 'asia-northeast1')
          .httpsCallable('customTokenGetter',
              options:
                  HttpsCallableOptions(timeout: const Duration(seconds: 5)));
      final response = await callable.call({
        'userId': lineUserId,
        //'profile': lineUserProfile,
        // 'displayName': displayName,
      });
      return await FirebaseAuth.instance
          .signInWithCustomToken(response.data['customToken'])
          .then((authResult) async {
        final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
        final CollectionReference collections =
            firebaseStore.collection('users');
        final firebaseUser = authResult.user;
        await collections.doc(firebaseUser?.uid).set({'createdAt': createdAt});
        await authResult.user?.updateDisplayName(displayName);
        print(lineUserId);
        print(firebaseUser);
        print(firebaseUser?.uid);
        Navigator.popUntil(context, (_) => count++ >= 1);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('ログインされました。')));
        // Navigator.pushReplacementNamed(context,'/home');
      });
    } on PlatformException catch (e) {
      var message = 'エラーが発生しました';
      if (e.code == '3063') {
        message = 'キャンセルしました';
        print(message);
      }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.code),
        ));


      // throw FirebaseAuthException(code: e.code, message: message);
    }
  }
}
