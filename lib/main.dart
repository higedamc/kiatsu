import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:kiatsu/auth/apple_signin_available.dart';
import 'package:kiatsu/pages/dialog.dart';
import 'package:kiatsu/pages/home_page.dart';
import 'package:kiatsu/pages/iap_page.dart';
import 'package:kiatsu/pages/setting_page.dart';
import 'package:kiatsu/pages/sign_in_page.dart';
import 'package:kiatsu/pages/splash_login.dart';
import 'package:kiatsu/pages/timeline.dart';
import 'package:kiatsu/utils/wiredash_locale.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:wiredash/wiredash.dart';

/**
 * ! 破壊的変更の追加。
 * 詳細は => https://codeux.design/articles/manage-secrets-flutter-project/
 */
Future<void> startApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  // await initPlatformState();
    final appleSignInAvailable = await AppleSignInAvailable.check();
  
    timeago.setLocaleMessages('ja', timeago.JaMessages());
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Center(child: CircularProgressIndicator(backgroundColor: Colors.white,));
    };
    // 後悔 できない環境変数の読み込み
    await dotenv.load();
    SharedPreferences.getInstance().then((prefs) {
      // runeZonedGuardedに包むことによってFlutter起動中のエラーを非同期的に全部拾ってくれる(らしい)
      runZonedGuarded(() async {
        runApp(
          Provider<AppleSignInAvailable>.value(
            child: MyApp(
              prefs: prefs, key: UniqueKey(),
            ),
            value: appleSignInAvailable,
          ),
        );
      }, (e, s) async => await FirebaseCrashlytics.instance.recordError(e, s));
    });
  }
  
//   Future<void> initPlatformState() async {
//     await Purchases.setDebugLogsEnabled(true);
//     await Purchases.setup("hEGjqaMrDIyByWbYGXSlPRcswbreVkgj");
// }

class MyApp extends StatelessWidget {
  MyApp({required Key key, required this.prefs}) : super(key: key);
  final SharedPreferences prefs;
  final _navigatorKey = GlobalKey<NavigatorState>();
  

  @override
  Widget build(BuildContext context) {
    return Wiredash(
      navigatorKey: _navigatorKey,
      projectId: env['WIREDASH_ID'].toString(),
      secret: env['WIREDASH_SECRET'].toString(),
      options: WiredashOptionsData(
        customTranslations: {
          // plに日本語の翻訳をオーバーライド
          const Locale.fromSubtags(languageCode: 'pl'):
          const CustomTranslations(),
        },
        locale: const Locale('pl'),
      ),
      child: NeumorphicApp(
        navigatorKey: _navigatorKey,
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
          '/iap': (BuildContext context) => IAPPage(key: UniqueKey()),
        },
        debugShowCheckedModeBanner: false,
        home: SplashPage(),
      ),
    );
  }
}
