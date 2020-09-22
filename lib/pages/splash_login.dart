import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kiatsu/pages/home_page.dart';
import 'package:splashscreen/splashscreen.dart';

// 匿名ログイン + スプラッシュスクリーンの実装

bool result;

class SplashPage extends StatelessWidget {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> signInAnon() async {
    UserCredential user = await firebaseAuth.signInAnonymously();
    return user;
  }


  SplashPage() {
    var currentUser = firebaseAuth.currentUser;
    if (currentUser == null)
    signInAnon().then((UserCredential user) {
      print('User ${user.user.uid}');
    });
    else {
      print('User Already Registered');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: HomePage(),
      image: new Image.asset('assets/images/face.png'),
      photoSize: 100.0,
    );
  }

}