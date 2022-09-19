import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// ignore: depend_on_referenced_packages
import 'package:twitter_login/twitter_login.dart';

class TwitterAuthUtil {
  static final _twitter = TwitterLogin(
    apiKey: dotenv.env['TWITTER_CONSUMER_KEY'].toString(),
    apiSecretKey: dotenv.env['TWITTER_SECRET_KEY'].toString(),
    redirectURI: dotenv.env['TWITTER_REDIRECT_URL'].toString(),
  );

  /// サインイン中か
  bool isSignedIn() => FirebaseAuth.instance.currentUser != null;

  /// 現在のユーザー情報
  User? getCurrentUser() => FirebaseAuth.instance.currentUser;

  /// サインアウト
  void signOut() => FirebaseAuth.instance.signOut();

  /// サインイン
  static Future<User?> signIn(BuildContext context) async {
    final credential = await signInWithTwitter(context);
    return credential?.user;
  }

  static Future<AuthCredential?> getTwitterAuthCredential(
    BuildContext context,
  ) async {
    final authResult = await _twitter.login();
    final twitterAuthCrendential = TwitterAuthProvider.credential(
      accessToken: authResult.authToken.toString(),
      secret: authResult.authTokenSecret.toString(),
    );
    return twitterAuthCrendential;
    //  secret: secret)
  }

  // TODO: #113 Firebaseにアカウントが登録されない問題を修正する
  // TODO: 実機での動作確認
  static Future<UserCredential?> signInWithTwitter(BuildContext context) async {
    // final _user = FirebaseAuth.instance.currentUser;
    final createdAt = DateTime.now();
    final newUser = FirebaseAuth.instance;

    final firebaseStore = FirebaseFirestore.instance;
    final users = firebaseStore.collection('users');
    await _twitter.login().then((session) {
      final twitterAuthCredential = TwitterAuthProvider.credential(
          accessToken: session.authToken.toString(),
          secret: session.authTokenSecret.toString());
      session.status == TwitterLoginStatus.cancelledByUser
          ? ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('ログインがキャンセルされました。'),
              ),
            )
          : newUser
              .signInWithCredential(twitterAuthCredential)
              .then((authResult) async {
              final displayName = authResult.user?.displayName;
              final email = authResult.user?.email;
              final photoUrl = authResult.user?.photoURL;
              final uid = authResult.user?.uid;
              final providerData = authResult.user?.providerData;
              final firebaseUser = authResult.user;
              // await firebaseUser?.updatePhotoURL(photoUrl);
              // await firebaseUser?.updateEmail(email!);

              final setData = <String, dynamic>{
                'createdAt': createdAt.toIso8601String(),
                'authProvider': 'twitter.com',
                'isDeletedUser': false,
              };
              await users
                  .doc(authResult.user!.uid)
                  .set(setData, SetOptions(merge: true))
                  .then(
                    (_) => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('ログインされました。'),
                      ),
                    ),
                  );
              // log('displayName: $displayName, email: $email, photoUrl: $photoUrl, uid: $uid, providerData: $providerData, firebaseUser: $firebaseUser, createdAt: $createdAt');
              // Navigator.pop(context, '/timeline');
              // Navigator.popUntil(context, (_) => count++ >= 2);

              // ignore: argument_type_not_assignable_to_error_handler
            }).catchError((Object error) {
              log('error: $error');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('ログインに失敗しました。'),
                ),
              );
            });
    });
    return null;
    // return authResult;
  }
}
