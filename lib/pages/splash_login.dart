import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:kiatsu/pages/home_page.dart';
import 'package:kiatsu/utils/apple_auth.dart';
import 'package:splashscreen/splashscreen.dart';

// 匿名ログイン + スプラッシュスクリーンの実装

class SplashPage extends StatelessWidget {
  final DateTime createdAt = new DateTime.now();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;

  Future<UserCredential> signInAnon() async {
    UserCredential user = await firebaseAuth.signInAnonymously();
    return user;
  }

  SplashPage() {
    final current = firebaseAuth.currentUser;
    // final pData = current!.providerData;
    final CollectionReference users = firebaseStore.collection('users');
    if (!AppleAuthUtil.isSignedIn()) {
      signInAnon().then((UserCredential user) async {
        print('User ${user.user!.uid}');
        await users
            .doc(user.user!.uid)
            .collection('votes')
            .doc()
            .set({
          'pien_rate': [
            {'cho_pien': 0, 'creaateAt': createdAt},
            {'pien': 0, 'createdAt': createdAt},
            {'not_pien': 0, 'createdAt': createdAt}
          ],
          // 'location':
        });
        users.doc(user.user!.uid).set({'createdAt': createdAt});
      });
    } else {
      print('User Already Registered: $current');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      loaderColor: Colors.black,
      seconds: 2,
      navigateAfterSeconds: HomePage(),
      image: new Image.asset('assets/images/face.png'),
      photoSize: 100.0,
    );
  }
}
