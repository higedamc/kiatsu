import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:twitter_login/twitter_login.dart';

class TwitterAuthUtil {
  static final TwitterLogin _twitter = TwitterLogin(
    apiKey: dotenv.env['TWITTER_CONSUMER_KEY'].toString(),
    apiSecretKey: dotenv.env['TWITTER_SECRET_KEY'].toString(),
    redirectURI: dotenv.env['TWITTER_REDIRECT_URL'].toString(),
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

  // TODO: #113 Firebaseにアカウントが登録されない問題を修正する
  // TODO: 実機での動作確認
  static Future<UserCredential?> signInWithTwitter(BuildContext context) async {
    // final _user = FirebaseAuth.instance.currentUser;
    final createdAt =  DateTime.now();
    final newUser = FirebaseAuth.instance;
    int count = 0;
    
    final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
    final CollectionReference users = firebaseStore.collection('users');
    final authResult = await _twitter.login().then((session) {
      final AuthCredential twitterAuthCredential = TwitterAuthProvider.credential(
      accessToken: session.authToken.toString(),
      secret: session.authTokenSecret.toString(),
    );
    (session.status == TwitterLoginStatus.cancelledByUser)
        ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('ログインがキャンセルされました。'),
          ))
        : newUser
            .signInWithCredential(twitterAuthCredential)
            .then((authResult) async {
            final displayName = authResult.user?.displayName;
            final email = authResult.user?.email;
            final photoUrl = authResult.user?.photoURL;
            final uid = authResult.user?.uid;
            final providerData = authResult.user?.providerData;
            final firebaseUser = authResult.user;
            await firebaseUser?.updatePhotoURL(photoUrl);
            // await firebaseUser?.updateEmail(email!);
            await users.doc(authResult.user!.uid).set({'createdAt': createdAt});
            print(
                'displayName: $displayName, email: $email, photoUrl: $photoUrl, uid: $uid, providerData: $providerData, firebaseUser: $firebaseUser, createdAt: $createdAt');
                // Navigator.pop(context, '/timeline');
                Navigator.popUntil(context, (_) => count++ >= 2);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('ログインされました。')));
          });
      

    });
    return authResult;
  }
}
