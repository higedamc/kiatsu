import 'dart:async';
import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiatsu/gen/assets.gen.dart';
import 'package:kiatsu/l18n/ja_messages.dart';
import 'package:kiatsu/pages/check_env_page.dart';
import 'package:kiatsu/pages/dialog.dart';
import 'package:kiatsu/pages/home_page.dart';
import 'package:kiatsu/l18n/wiredash_locale.dart';
import 'package:kiatsu/pages/notification_page.dart';
import 'package:kiatsu/pages/onboarding_page.dart';
import 'package:kiatsu/pages/setting_page.dart';
import 'package:kiatsu/pages/sign_in_page.dart';
import 'package:kiatsu/pages/subscriptions_page.dart';
import 'package:kiatsu/pages/test_widget.dart';
import 'package:kiatsu/pages/timeline.dart';
import 'package:package_info/package_info.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wiredash/wiredash.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'env/firebase_options_dev.dart' as dev;
import 'env/firebase_options_prod.dart' as prod;


// Import the generated file


// https://github.com/Meshkat-Shadik/WeatherApp/blob/279c8bc1dd/lib/infrastructure/weather_repository.dart#L11

// final revenuecatProvider = ChangeNotifierProvider.autoDispose<RevenueCatProvider>(
//   (ref) => RevenueCatProvider());

// 参照: https://codeux.design/articles/manage-secrets-flutter-project/

const flavor = String.fromEnvironment('FLAVOR');

void main() {
  startApp();
}


Future<void> startApp() async {
  // final _navigatorKey = GlobalKey<NavigatorState>();

  WidgetsFlutterBinding.ensureInitialized();
  
  

  await dotenv.load(fileName: '.env');
 
  // FirebaseOptions? firebaseOptions;
  // if ((Platform.isIOS && flavor == 'dev')) {
  //   firebaseOptions = FirebaseOptions(
  //    apiKey: dotenv.env['FIREBASE_API_KEY_IOS_DEV']!,
  //     appId: dotenv.env['FIREBASE_APP_ID_IOS_DEV']!,
  //      messagingSenderId: dotenv.env['FIREBASE_GCM_SENDER_ID_IOS_DEV']!,
  //       projectId: dotenv.env['FIREBASE_PROJECT_ID_IOS_DEV']!,
  //       storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET_IOS_DEV']!,
  //       databaseURL: dotenv.env['FIREBASE_DETABASE_URL_IOS_DEV']!,
  //       );
  // } 
  // else {
  //   firebaseOptions = const FirebaseOptions(
  //     apiKey: apiKey,
  //      appId: appId,
  //       messagingSenderId: messagingSenderId,
  //        projectId: projectId);
  // }
  // https://qiita.com/KazaKago/items/5dbe67032ecc7d459d74
  FirebaseOptions firebaseOptions() {
  switch (flavor) {
    case 'dev':
      return dev.DefaultFirebaseOptions.currentPlatform;
    case 'prod':
      return prod.DefaultFirebaseOptions.currentPlatform;
    default:
      throw ArgumentError('Not available flavor');
  }
}

  await Firebase.initializeApp(
      options: firebaseOptions(),
      );

  // await PurchaseApi.init();
  await Purchases.setDebugLogsEnabled(kDebugMode);
  await Purchases.setup(dotenv.env['REVENUECAT_SECRET_KEY'].toString());

  // final appleSignInAvailable = await AppleSignInAvailable.check();

  final result = await checkFirstRun();
  if (result == true) {
    await AppTrackingTransparency.requestTrackingAuthorization();
  }

  timeago.setLocaleMessages('ja', const MyCustomMessages());
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const Center(
        child: CircularProgressIndicator(
      backgroundColor: Colors.white,
    ));
  };
  await MobileAds.instance.initialize();
  if(flavor == 'stg') {
    await LineSDK.instance.setup(dotenv.env['LINE_CHANNEL_ID_STG'].toString());
  }
  else {
    await LineSDK.instance.setup(dotenv.env['LINE_CHANNEL_ID'].toString());
  }
  SharedPreferences.getInstance().then((prefs) {
    // runeZonedGuardedに包むことによってFlutter起動中のエラーを非同期的に全部拾ってくれる(らしい)
    runZonedGuarded(() async {
      runApp(
        ProviderScope(
          child: MyApp(
            prefs: prefs,
            key: UniqueKey(),
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
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Wiredash(
      // key: UniqueKey(),
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
        // key: UniqueKey(),
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
              '/notify': (BuildContext context) => const NotificationPage(
              ),
          '/test': (BuildContext context) => const TestWidget(),
          '/onbo': (BuildContext context) => const OnboardingPage(),
          '/env': (BuildContext context) => const CheckEnvPage()
        },
        home: firebaseAuth.currentUser != null ? splashScreen : const OnboardingPage(),
      ),
    );
  }
}

Widget splashScreen = SplashScreenView(
  navigateRoute: const HomePage(),
  duration: 2000,
  imageSize: 130,
  imageSrc: Assets.images.face.path,
  text: 'Hello, world',
  textType: TextType.NormalText,
  textStyle: const TextStyle(
    fontSize: 30.0,
  ),
  backgroundColor: Colors.white,
);

Future<bool> checkFirstRun() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool _firstRun = prefs.getBool('firstRun') ?? true;
    if (_firstRun) {
      prefs.setBool('firstRun', false);
      return true;
    } else {
      return false;
    }
  }

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