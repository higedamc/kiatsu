import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kiatsu/api/purchase_api.dart';
import 'package:kiatsu/pages/consumables_page.dart';

import 'package:kiatsu/pages/home_page.dart';
import 'package:kiatsu/pages/iap_page.dart';
import 'package:kiatsu/pages/subscriptions_page.dart';
import 'package:kiatsu/pages/upsell_page.dart';
import 'package:purchases_flutter/offering_wrapper.dart';
import 'package:purchases_flutter/offerings_wrapper.dart';
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

  //参照: https://www.effata.co.jp/blog/5224
  Future<void> showAppTrackingTransparency() async {
    final TrackingStatus status =
      await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  Future<void> showCurrent() async {
    final User? current = firebaseAuth.currentUser;
    print('User Already Registered: $current');
  }

  SplashPage() {
    final User? current = firebaseAuth.currentUser;
    final CollectionReference users = firebaseStore.collection('users');
    
    if (current == null) {
      signInAnon().then((UserCredential user) async {
        print('User ${user.user!.uid}');
        await showAppTrackingTransparency();
        await users.doc(user.user!.uid).collection('votes').doc().set({
          'pien_rate': [
            {'cho_pien': 0, 'creaateAt': createdAt},
            {'pien': 0, 'createdAt': createdAt},
            {'not_pien': 0, 'createdAt': createdAt}
          ],
          // 'location':
        });
        users.doc(user.user!.uid).set({'createdAt': createdAt});
        // await PurchaseApi.init();
      });
    } else {
    //   PurchaseApi.init();
      // print('User Already Registered: $current');
      // Ask App Not To Track表示のために強制的にprint挟んでawait実装笑
      showCurrent().then((_) async => await showAppTrackingTransparency());
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
