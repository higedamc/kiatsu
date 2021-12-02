import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiatsu/pages/main_view.dart';
import 'package:kiatsu/l18n/wiredash_locale.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:wiredash/wiredash.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'api/purchase_api.dart';

// https://github.com/Meshkat-Shadik/WeatherApp/blob/279c8bc1dd/lib/infrastructure/weather_repository.dart#L11

// final revenuecatProvider = ChangeNotifierProvider.autoDispose<RevenueCatProvider>(
//   (ref) => RevenueCatProvider());



// 参照: https://codeux.design/articles/manage-secrets-flutter-project/



Future<void> startApp() async {
  // final _navigatorKey = GlobalKey<NavigatorState>();

  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  
 
  
  await Firebase.initializeApp();
  
  // final appleSignInAvailable = await AppleSignInAvailable.check();
  await PurchaseApi.init();

  timeago.setLocaleMessages('ja', timeago.JaMessages());
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const Center(
        child: CircularProgressIndicator(
      backgroundColor: Colors.white,
    ));
  };
  // 公開できない環境変数の読み込み
  await dotenv.dotenv.load(fileName: '.env');
  LineSDK.instance.setup(dotenv.dotenv.env['LINE_CHANNEL_ID'].toString()).then((_) {
    print('LINE SDK GOT SET UP');
  });
  SharedPreferences.getInstance().then((prefs) {
    // runeZonedGuardedに包むことによってFlutter起動中のエラーを非同期的に全部拾ってくれる(らしい)
    runZonedGuarded(() async {
      runApp(
        ProviderScope(
          child: ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: () {
              return MyApp(
                prefs: prefs,
                key: UniqueKey(),
              );
            }
          ),
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

      child: MaterialApp(
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        home: const MainView(),
      ),
    );
  }
}
