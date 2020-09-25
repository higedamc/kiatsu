import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kiatsu/pages/home_page.dart';
import 'package:splashscreen/splashscreen.dart';

// 匿名ログイン + スプラッシュスクリーンの実装

bool result;
String commentId;
TextEditingController _text;

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
      .doc(user.user.uid)
      .collection('votes')
      .add({
        'pien_rate': [
          {'cho_pien': null,
          'creaateAt': createdAt},
          {'pien': null,
          'createdAt': createdAt},
          {'not_pien': null,
          'createdAt': createdAt}
        ],
        'createdAt': createdAt
        // 'createdAt': createdAt,
        // 'location': 
      });
      await users
      .doc(user.user.uid)
      .collection('comments')
      .add({
        'comment': _text.toString(),
        'createdAt': createdAt
      });
      // .then((users) => {
      //   users.collection('comments')
      //   .doc(commentId)
      //   .set(
      //     {
      //       'comment': null,
      //       'createdAt': createdAt
      //     }
      //   )
      // }
      // );
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