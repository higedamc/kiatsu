import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart' show TwitterLogin, TwitterSession;


class TwitterAuthUtil {
  static final TwitterLogin _twitter = TwitterLogin(

    consumerKey: env['TWITTER_CONSUMER_KEY'],
    consumerSecret: env['TWITTER_SECRET_KEY'],


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