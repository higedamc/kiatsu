import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:twitter_login/twitter_login.dart';

class TwitterAuthUtil {
  static final TwitterLogin _twitter = TwitterLogin(
    apiKey: dotenv.env['TWITTER_CONSUMER_KEY'].toString(),
    apiSecretKey: dotenv.env['TWITTER_SECRET_KEY'].toString(),
    redirectURI: 'twitterkit-qIQKdcDM2rworcBDbaHbYb7PO://',
  );

  /// サインイン中か
  static bool isSignedIn() => FirebaseAuth.instance.currentUser != null;

  /// 現在のユーザー情報
  static User? getCurrentUser() => FirebaseAuth.instance.currentUser;

  /// サインアウト
  static void signOut() => FirebaseAuth.instance.signOut();

  /// サインイン
  static Future<User?> signIn(BuildContext context) async {
    final UserCredential? credential = await signInWithTwitter(context);
    return credential?.user;
  }

  static Future<UserCredential?> signInWithTwitter(BuildContext context) async {
    // final _user = FirebaseAuth.instance.currentUser;
    final newUser = FirebaseAuth.instance;
    final session = await _twitter.login();
    final AuthCredential twitterAuthCredential = TwitterAuthProvider.credential(
      accessToken: session.authToken.toString(),
      secret: session.authTokenSecret.toString(),
    );
    (session.status == TwitterLoginStatus.cancelledByUser)
        ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('ログインがキャンセルされました。アプリを終了してください'),
      ))
        : await newUser.signInWithCredential(twitterAuthCredential);
  }
}
