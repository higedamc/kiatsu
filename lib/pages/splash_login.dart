import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kiatsu/pages/home_page.dart';
import 'package:splashscreen/splashscreen.dart';

// 匿名ログイン + スプラッシュスクリーンの実装

bool result;

class SplashPage extends StatelessWidget {

  DateTime createdAt = new DateTime.now();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;

  Future<UserCredential> signInAnon() async {
    UserCredential user = await firebaseAuth.signInAnonymously();
    return user;
  }


  SplashPage() {
    var currentUser = firebaseAuth.currentUser;
    CollectionReference users = firebaseStore.collection('users');
    if (currentUser == null)
    signInAnon().then((UserCredential user) async {
      print('User ${user.user.uid}');
      await users
      .add({
        'name': user.user.uid,
        'createdAt': createdAt,
        // 'location': 
      });
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