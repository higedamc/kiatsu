import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiatsu/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

//void main() => runApp(MyApp());
void main() {
  //エラーをCrashlyticsで収集してFirebaseへ送信
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) {
    runZoned(() async {
      runApp(MyApp());
    }, onError: Crashlytics.instance.recordError);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: HomePage());
  }
}
