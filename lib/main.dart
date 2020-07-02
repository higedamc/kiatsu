import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:kiatsu/pages/home_page.dart';
import 'package:kiatsu/pages/setting_page.dart';
import 'package:kiatsu/services/authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';




void main() {
  // デバッグ中もクラッシュ情報収集できる
  Crashlytics.instance.enableInDevMode = true;
  // 以下 6 行 Firebase Crashlytics用のおまじない
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) {
    // runeZonedGuardedに包むことによってFlutter起動中のエラーを非同期的に全部拾ってくれる(らしい)
    runZonedGuarded(() async {
      runApp(MyApp(
        prefs: prefs
          ));
    }, (e, s) async => await Crashlytics.instance.recordError(e, s));
  });
  
  
  }
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

class MyApp extends StatelessWidget {
  // API Key呼び出し
  final SharedPreferences prefs;
  MyApp({this.prefs});

  // static String fine = '元気すぎわろた＾ｑ＾';
  // static String pien = '低気圧つらすぎぴえん🥺';

  final String headerTitle = 'ホーム';
  // List<String> items = [pien, fine];
  // final String screenName = 'THE KIATSU';
  
  


  final _navigatorKey = GlobalKey<NavigatorState>();


 

 

    // Future _showPieng() async {
    //   setState(() {
    //     var result = getWeather();

    //   });
    // }

    // _showWiredash() {
    //   setState(() {
    //     Wiredash.of(context).show();
    //   });
    // }

   

  // @override
  // void initState() {
    
    
  //   super.initState();
    
  // }

  // get value => null;

  // Future _onRefresher() async {
  //   _getchuWeather();
  //   print("どうよ？");
  // }

  /**
   * Get Weather
   * ! This is a test purpose only comment using Better Comments
   * ? Question version
   */
  

  // Future _remoteConfig() async {
  //   RemoteConfig remoteConfig = await RemoteConfig.instance;
  //   await remoteConfig.fetch(expiration: const Duration(minutes: 60));
  //   await remoteConfig.activateFetched();
  //   String secret = remoteConfig.getString('weather_api_key');
  //   return secret;
  // }

  // RemoteConfig用のgetWeather
  // Future<WeatherClass> getWeather() async {
  //   var result = remoteConfig.getString('weather_api_key');
  //   Position position = await Geolocator()
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
  //   String url = 'http://api.openweathermap.org/data/2.5/weather?lat=' +
  //       position.latitude.toString() +
  //       '&lon=' +
  //       position.longitude.toString() +
  //       '&APPID=$result';
  //   final response = await http.get(url);
  //   return WeatherClass.fromJson(json.decode(response.body));
  // }

  // Future で 5日分の天気取得
 

//  void queryWeather() async {
////    Weather w = await ws.currentWeather(latitude, longitude);
//    Weather w = (await getWeather()) as Weather;
//    setState(() {
//      _res = w.toString();
//      print('weather api test*****************************');
//      print(_res);
//    });
//  }

//  void queryBarometer() async {
//    Weather w2 = await ws.currentWeather(latitude, longtitude);
//    double pressure = w2.pressure.toDouble();
//    setState(() {
//      _res2 = w2.toString();
//      res_p = pressure.toInt();
//      print('pressure *****************');
//      print(w2);
//      print('pressure *****************');
//      print(pressure);
//    });
//  }
  // void _getchuWeather() async {
  //   WeatherClass bitch = await getWeather();
  //   setState(() {
  //     weather = bitch;
  //   });

  // }

    

  

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
          // '/loginsignup': (BuildContext context) => LoginSignupPage(),
          // '/root': (BuildContext context) => RootPage(),
        },
        debugShowCheckedModeBanner: false,
        home: HomePage(),
                );
          }
        
          // Widget _handleCurrentScreen() {
          //   bool _seen = (prefs.getBool('_seen') ?? false);
          //   if (_seen) {
          //     return new RootPage(
          //       auth: new Auth(),
          //     );
          //   } else {
          //     return new HomePage(),
          //   }

          // }
}

