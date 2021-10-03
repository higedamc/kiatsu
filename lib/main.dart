import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kiatsu/Provider/revenuecat.dart';
import 'package:kiatsu/pages/main_view.dart';
import 'package:kiatsu/utils/wiredash_locale.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:wiredash/wiredash.dart';

import 'api/purchase_api.dart';

final revenuecatProvider = ChangeNotifierProvider.autoDispose<RevenueCatProvider>(
  (ref) => RevenueCatProvider());



/**
 * ! 破壊的変更の追加。
 * 詳細は => https://codeux.design/articles/manage-secrets-flutter-project/
 */
Future<void> startApp() async {
  WidgetsFlutterBinding.ensureInitialized();
 

  await Firebase.initializeApp();
  await PurchaseApi.init();
  // final appleSignInAvailable = await AppleSignInAvailable.check();

  timeago.setLocaleMessages('ja', timeago.JaMessages());
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Center(
        child: CircularProgressIndicator(
      backgroundColor: Colors.white,
    ));
  };
  // 公開できない環境変数の読み込み
  await dotenv.dotenv.load(fileName: ".env");
  SharedPreferences.getInstance().then((prefs) {
    // runeZonedGuardedに包むことによってFlutter起動中のエラーを非同期的に全部拾ってくれる(らしい)
    runZonedGuarded(() async {
      runApp(
        ProviderScope(
          child: MyApp(
            prefs: prefs,
            key: UniqueKey(),
          ),
          // value: appleSignInAvailable,
        ),
      );
    }, (e, s) async => await FirebaseCrashlytics.instance.recordError(e, s));
  });
}

class MyApp extends StatelessWidget {
  MyApp({required Key key, required this.prefs}) : super(key: key);
  final SharedPreferences prefs;
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Wiredash(
      navigatorKey: _navigatorKey,
      projectId: dotenv.dotenv.env['WIREDASH_ID'].toString(),
      secret: dotenv.dotenv.env['WIREDASH_SECRET'].toString(),
      options: WiredashOptionsData(
        customTranslations: {
          // plに日本語の翻訳をオーバーライド
          const Locale.fromSubtags(languageCode: 'pl'):
              const CustomTranslations(),
        },
        locale: const Locale('pl'),
      ),

      child: MainView(),
    );
  }
}
