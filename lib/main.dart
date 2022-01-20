import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiatsu/gen/assets.gen.dart';
import 'package:kiatsu/l18n/ja_messages.dart';
import 'package:kiatsu/pages/dialog.dart';
import 'package:kiatsu/pages/home_page.dart';
import 'package:kiatsu/l18n/wiredash_locale.dart';
import 'package:kiatsu/pages/setting_page.dart';
import 'package:kiatsu/pages/sign_in_page.dart';
import 'package:kiatsu/pages/subscriptions_page.dart';
import 'package:kiatsu/pages/timeline.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wiredash/wiredash.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Import the generated file
import 'firebase_options.dart';
import 'package:provider/provider.dart' as provider;

//TODO: WIREDASHのエラー直す(エミュレーターだけ説？)

// https://github.com/Meshkat-Shadik/WeatherApp/blob/279c8bc1dd/lib/infrastructure/weather_repository.dart#L11

// final revenuecatProvider = ChangeNotifierProvider.autoDispose<RevenueCatProvider>(
//   (ref) => RevenueCatProvider());

// 参照: https://codeux.design/articles/manage-secrets-flutter-project/

Future<void> startApp() async {
  // final _navigatorKey = GlobalKey<NavigatorState>();

  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  MobileAds.instance.initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await PurchaseApi.init();
  await Purchases.setDebugLogsEnabled(kDebugMode);
  await Purchases.setup(dotenv.env['REVENUECAT_SECRET_KEY'].toString());

  // final appleSignInAvailable = await AppleSignInAvailable.check();

  timeago.setLocaleMessages('ja', const MyCustomMessages());
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const Center(
        child: CircularProgressIndicator(
      backgroundColor: Colors.white,
    ));
  };

  await LineSDK.instance.setup(dotenv.env['LINE_CHANNEL_ID'].toString());
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
              }),
        ),
      );
    }, (e, s) async => await FirebaseCrashlytics.instance.recordError(e, s));
  });
}

class MyApp extends StatelessWidget {
  MyApp({required Key key, required this.prefs}) : super(key: key);
  final SharedPreferences prefs;
  final _navigatorKey = GlobalKey<NavigatorState>();
  // final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Wiredash(
      key: UniqueKey(),
      projectId: dotenv.env['WIREDASH_ID'].toString(),
      secret: dotenv.env['WIREDASH_SECRET'].toString(),
      navigatorKey: _navigatorKey,
      options: WiredashOptionsData(
        customTranslations: {
          // plに日本語の翻訳をオーバーライド
          const Locale.fromSubtags(languageCode: 'pl'):
              const CustomTranslations(),
        },
        locale: const Locale('pl'),
      ),
      child: NeumorphicApp(
        key: UniqueKey(),
        navigatorKey: _navigatorKey,
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
          '/home': (BuildContext context) => HomePage(
                cityName: '',
                key: UniqueKey(),
              ),
          '/sign': (BuildContext context) => const SignInPage(),
          '/dialog': (BuildContext context) => const Dialogs(),
          '/sub': (BuildContext context) => const SubscriptionsPage(),
          '/timeline': (BuildContext context) => Timeline(
                cityName: '',
                key: UniqueKey(),
              ),
          // '/test': (BuildContext context) => const PurchasePage(),
        },
        home: splashScreen,
      ),
    );
  }
}

Widget splashScreen = SplashScreenView(
  navigateRoute: const HomePage(),
  // navigateRoute: const SignInPage(),
  duration: 1500,
  imageSize: 130,
  imageSrc: Assets.images.face.path,
  text: 'Kiatsu',
  textType: TextType.NormalText,
  textStyle: const TextStyle(
    fontSize: 30.0,
  ),
  backgroundColor: Colors.white,
);

// class SplashPage extends MyApp {
  
  // final DateTime createdAt = new DateTime.now();
//   final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//   // final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;

//   // Future<UserCredential> signInAnon() async {
//   //   UserCredential user = await firebaseAuth.signInAnonymously();
//   //   return user;
//   // }

//   SplashPage({Key? key}) : super(key: key) {
//     final User? current = firebaseAuth.currentUser;
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
//     if (current != null) {
//       print(current.uid);
//       print(current.photoURL);
//       print(current.providerData.first.photoURL);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SplashScreenView(
//       navigateRoute: HomePage(),
//       duration: 1500,
//       imageSize: 130,
//       imageSrc: Assets.images.face.path,
//       text: 'Kiatsu',
//       textType: TextType.NormalText,
//       textStyle: const TextStyle(
//         fontSize: 30.0,
//       ),
//       backgroundColor: Colors.white,
//     );
//   }
// }