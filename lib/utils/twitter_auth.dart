import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
// import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:kiatsu/env/production_secrets.dart';
import 'package:provider/provider.dart';

abstract class Secrets {
  String get twitterConsumerKey;
  String get twitterSecretKey;
}

class TwitterAuthUtil {
  static final TwitterLogin _twitter = TwitterLogin(

    consumerKey: ProductionSecrets().twitterConsumerKey,
    consumerSecret: ProductionSecrets().twitterSecretKey,


  );

  /// サインイン中か
  static bool isSignedIn() => FirebaseAuth.instance.currentUser != null;

  /// 現在のユーザー情報
  static User? getCurrentUser() => FirebaseAuth.instance.currentUser;

  /// サインアウト
  static void signOut() => FirebaseAuth.instance.signOut();

  /// サインイン
  static Future<User?> signIn(BuildContext context) async {
    final UserCredential credential = await signInWithTwitter(context);
    return credential.user;
  }

  static Future<UserCredential> signInWithTwitter(BuildContext context) async {
    final _user = FirebaseAuth.instance.currentUser;
    final result = await _twitter.authorize();
    final TwitterSession session = result.session;

    final AuthCredential twitterAuthCredential =
        TwitterAuthProvider.credential(
          accessToken: session.token,
          secret: session.secret,
        );
    return await _user!.linkWithCredential(twitterAuthCredential);
  }
}