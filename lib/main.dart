import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:kiatsu/auth/apple_signin_available.dart';
import 'package:kiatsu/pages/dialog.dart';
import 'package:kiatsu/pages/home_page.dart';
import 'package:kiatsu/pages/setting_page.dart';
import 'package:kiatsu/pages/sign_in_page.dart';
import 'package:kiatsu/pages/splash_login.dart';
import 'package:kiatsu/pages/timeline.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

abstract class Secrets {
  String get firebaseApiKey;
  String get firebaseSecret;
  String get firebaseProjectId;
  String get twitterConsumerKey;
  String get twitterSecretKey;
  String get wiredashProjectId;
  String get wiredashSecret;
}

/**
 * ! 破壊的変更の追加。
 * 詳細は => https://codeux.design/articles/manage-secrets-flutter-project/
 */
Future<void> startApp(Secrets secrets) async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  final appleSignInAvailable = await AppleSignInAvailable.check();

  timeago.setLocaleMessages('ja', timeago.JaMessages());
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  ErrorWidget.builder = (FlutterErrorDetails details) {
    // return SplashScreen(
    //   loaderColor: Colors.black,
    //   // seconds: 2,
    //   // navigateAfterSeconds: HomePage(),
    //   image: new Image.asset('assets/images/face.png'),
    //   photoSize: 100.0,
    // );
    // return Center(child: CircularProgressIndicator(backgroundColor: Colors.white,));
    return Center(child: CircularProgressIndicator(backgroundColor: Colors.white,));
  };
  SharedPreferences.getInstance().then((prefs) {
    // runeZonedGuardedに包むことによってFlutter起動中のエラーを非同期的に全部拾ってくれる(らしい)
    runZonedGuarded(() async {
      runApp(
        Provider<AppleSignInAvailable>.value(
          child: MyApp(
            prefs: prefs,
            secrets: secrets, key: UniqueKey(),
          ),
          value: appleSignInAvailable,
        ),
      );
    }, (e, s) async => await FirebaseCrashlytics.instance.recordError(e, s));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({required Key key, required this.secrets, required this.prefs}) : super(key: key);

  final Secrets secrets;
  final SharedPreferences prefs;
  // final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Provider<Secrets>.value(
      value: secrets,
      child: NeumorphicApp(
        // navigatorKey: _navigatorKey,
        themeMode: ThemeMode.light,
        theme: NeumorphicThemeData(
          baseColor: Color(0xFFFFFFFF),
          lightSource: LightSource.topLeft,
          depth: 20,
          intensity: 1,
        ),
        routes: {
          '/a': (BuildContext context) => SettingPage(),
          '/timeline': (BuildContext context) => Timeline(key: UniqueKey(),),
          '/home': (BuildContext context) => HomePage(),
          '/signpage': (BuildContext context) => SignInPage(),
          '/dialog': (BuildContext context) => Dialogs(),
        },
        debugShowCheckedModeBanner: false,
        home: SplashPage(),
      ),
    );
  }
}
