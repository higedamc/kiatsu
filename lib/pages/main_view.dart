import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:kiatsu/pages/dialog.dart';
import 'package:kiatsu/pages/home_page.dart';
import 'package:kiatsu/pages/purchase_page.dart';
import 'package:kiatsu/pages/setting_page.dart';
import 'package:kiatsu/pages/sign_in_page.dart';
import 'package:kiatsu/pages/subscriptions_page.dart';
import 'package:kiatsu/pages/timeline.dart';
import 'package:kiatsu/providers/revenuecat.dart';
import 'package:provider/provider.dart' as provider;
import 'package:splashscreen/splashscreen.dart';

import 'consumables_page.dart';

// final pageIdProvider = StateProvider((ref) => 0);

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return provider.ChangeNotifierProvider(
        create: (BuildContext context) => RevenueCat(),
        child: NeumorphicApp(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          theme: const NeumorphicThemeData(
            baseColor: Color(0xFFFFFFFF),
            lightSource: LightSource.topLeft,
            depth: 20,
            intensity: 1,
          ),
          routes: {
            '/a': (BuildContext context) => const SettingPage(),
            '/timeline': (BuildContext context) => Timeline(
                  key: UniqueKey(), cityName: '',
                ),
            '/home': (BuildContext context) => HomePage(cityName: '', key: UniqueKey(),),
            '/sign': (BuildContext context) => const SignInPage(),
            '/dialog': (BuildContext context) => const Dialogs(),
            '/sub': (BuildContext context) => const SubscriptionsPage(),
            '/con': (BuildContext context) => const ConsumablesPage(),
            '/dev': (BuildContext context) => const DevPurchasePage(),
          },

          home: SplashPage(),
        ));
  }
}

//TODO: #119 Splashscreenをnullableなものに変える
class SplashPage extends MainView {
  // final DateTime createdAt = new DateTime.now();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;

  // Future<UserCredential> signInAnon() async {
  //   UserCredential user = await firebaseAuth.signInAnonymously();
  //   return user;
  // }

  SplashPage({Key? key}) : super(key: key) {
    final User? current = firebaseAuth.currentUser;
    // final CollectionReference users = firebaseStore.collection('users');
    // if (current == null) {
    //   signInAnon().then((UserCredential user) async {
    //     print('New User Registered: ${user.user!.uid}');
    //     await users.doc(user.user!.uid).collection('votes').doc().set({
    //       'pien_rate': [
    //         {'cho_pien': 0, 'creaateAt': createdAt},
    //         {'pien': 0, 'createdAt': createdAt},
    //         {'not_pien': 0, 'createdAt': createdAt}
    //       ],
    //       // 'location':
    //     });
    //     users.doc(user.user!.uid).set({'createdAt': createdAt});
    //     // await PurchaseApi.init();
    //   });
    // } else {
    //   //   PurchaseApi.init();
    //   print('User Already Registered: $current');
    // }
    if (current != null) {
      print(current.uid);
      print(current.photoURL);
      print(current.providerData.first.photoURL);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      loaderColor: Colors.black,
      seconds: 2,
      navigateAfterSeconds: HomePage(cityName: '', key: UniqueKey(),),
      image: Image.asset('assets/images/face.png'),
      photoSize: 100.0,
    );
  }
}
