import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:kiatsu/pages/consumables_page.dart';
import 'package:kiatsu/pages/dialog.dart';
import 'package:kiatsu/pages/home_page.dart';
import 'package:kiatsu/pages/iap_page.dart';
import 'package:kiatsu/pages/purchase_page.dart';
import 'package:kiatsu/pages/setting_page.dart';
import 'package:kiatsu/pages/sign_in_page.dart';
import 'package:kiatsu/pages/subscriptions_page.dart';
import 'package:kiatsu/pages/timeline.dart';
import 'package:splashscreen/splashscreen.dart';



class MainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      themeMode: ThemeMode.light,
      theme: NeumorphicThemeData(
        baseColor: Color(0xFFFFFFFF),
        lightSource: LightSource.topLeft,
        depth: 20,
        intensity: 1,
      ),
      routes: {
        '/a': (BuildContext context) => SettingPage(),
        '/timeline': (BuildContext context) => Timeline(
              key: UniqueKey(),
            ),
        '/home': (BuildContext context) => HomePage(),
        '/signpage': (BuildContext context) => SignInPage(),
        '/dialog': (BuildContext context) => Dialogs(),
        '/iap': (BuildContext context) => IAPScreen(key: UniqueKey()),
        '/sub': (BuildContext context) => SubscriptionsPage(),
        '/con': (BuildContext context) => ConsumablesPage(),
        '/subsc': (BuildContext context) => SubscriptionsPage(),
        '/buy': (BuildContext context) => DevPurchasePage(),
      },
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}

class SplashPage extends MainView {
  final DateTime createdAt = new DateTime.now();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;

  Future<UserCredential> signInAnon() async {
    UserCredential user = await firebaseAuth.signInAnonymously();
    return user;
  }

  SplashPage() {
    final User? current = firebaseAuth.currentUser;
    final CollectionReference users = firebaseStore.collection('users');
    if (current == null) {
      signInAnon().then((UserCredential user) async {
        print('User ${user.user!.uid}');
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
