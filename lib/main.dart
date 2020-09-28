import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:kiatsu/locator.dart';
import 'package:kiatsu/pages/setting_page.dart';
import 'package:kiatsu/pages/splash_login.dart';
import 'package:kiatsu/pages/timeline.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  // デバッグ中もクラッシュ情報収集できる
  WidgetsFlutterBinding.ensureInitialized();
  // Admob.initialize();
  await Firebase.initializeApp();
  await setupLocator();
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  // 以下 6 行 Firebase Crashlytics用のおまじない
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  SharedPreferences.getInstance().then((prefs) {
    // runeZonedGuardedに包むことによってFlutter起動中のエラーを非同期的に全部拾ってくれる(らしい)
    runZonedGuarded(() async {
      runApp(MyApp(prefs: prefs));
    }, (e, s) async => await FirebaseCrashlytics.instance.recordError(e, s));
  });
}

class MyApp extends StatelessWidget {
  // API Key呼び出し
  final SharedPreferences prefs;
  MyApp({this.prefs});

  final String headerTitle = 'ホーム';

  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      navigatorKey: _navigatorKey,
      themeMode: ThemeMode.light,
      theme: NeumorphicThemeData(
        baseColor: Color(0xFFFFFFFF),
        lightSource: LightSource.topLeft,
        depth: 20,
        intensity: 1,
      ),
      // initialRoute: '/a',
      routes: {
        '/a': (BuildContext context) => SettingPage(),
        '/timeline': (BuildContext context) => Timeline(),
      },
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}
