import 'dart:async';
import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:kiatsu/model/weather_model.dart';
import 'package:kiatsu/settingPage.dart';
import 'package:share/share.dart';
import 'package:weather/weather_library.dart';
import 'const/constant.dart' as Constant;
import 'package:timeago/timeago.dart' as timeago;

void main() {
  // デバッグ中もクラッシュ情報収集できる
  Crashlytics.instance.enableInDevMode = true;
  // 以下 6 行 Firebase Crashlytics用のおまじない
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  // runeZonedGuardedに包むことによってFlutter起動中のエラーを非同期的に全部拾ってくれる(らしい)
  runZonedGuarded(() async {
      runApp(MyApp(
          ));
    }, (e, s) => Crashlytics.instance.recordError(e, s));
  }
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // API Key呼び出し
  static const String a = Constant.key;

  static String fine = '元気すぎわろた＾ｑ＾';
  static String pien = '低気圧つらすぎぴえん🥺';

  List<String> items = [pien, fine];
  DateTime updatedAt = new DateTime.now();
  Weather w;
  // _MyAppState({this.remoteConfig});

  // final RemoteConfig remoteConfig;

  // 以下 2 つ Wiredash 用のストリング
  // String b = Constant.projectId;
  // String c = Constant.secret;
  
  Future<WeatherClass> weather;

  WeatherStation ws = new WeatherStation(a);

  final _navigatorKey = GlobalKey<NavigatorState>();
  String _res2 = '';

  @override
  void initState() {
    super.initState();
    weather = getWeather();
  }

  get value => null;

  // Future _onRefresher() async {
  //   _getchuWeather();
  //   print("どうよ？");
  // }

  /**
   * Get Weather
   * ! This is a test purpose only comment using Better Comments
   * ? Question version
   */
  Future<WeatherClass> getWeather() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    String url = 'http://api.openweathermap.org/data/2.5/weather?lat=' +
        position.latitude.toString() +
        '&lon=' +
        position.longitude.toString() +
        '&APPID=$a';
    final response = await http.get(url);
    return WeatherClass.fromJson(json.decode(response.body));
  }

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
 Future<void> queryForecast() async {
   // 位置情報取得
  Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
        // Weather クラスに 5日分の天気情報格納
   List<Weather> f = await ws.fiveDayForecast(position.latitude.toDouble(), position.longitude.toDouble());
   setState(() {
     // "_res2" の Text を List "f" にぶっこむ
     _res2 = f.toString();
   });
 }

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
    // ListView 更新
    Future<void> _refresher() async {
      setState(() {
        weather = getWeather();
        
        updatedAt = new DateTime.now();
        // 引っ張ったときに5日分の天気データ取得する
        // queryForecast();
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
        // initialRoute: '/a',
        routes: {
          '/a': (BuildContext context) => SettingPage(),
        },
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: GradientAppBar(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [const Color(0xFFc423ba), const Color(0xFF00d5bf)],
                tileMode: TileMode.repeated),
            centerTitle: true,
            title: const Text(
              "THE KIATSU",
            ),
            actions: <Widget>[
              /** Builder がないと「Navigatorを含むコンテクストが必要」って怒られる */
              Builder(
                builder: (context) => IconButton(icon: const Icon(Icons.settings), onPressed: () {
                  Navigator.of(context).pushNamed( '/a');
                }),
              )
            ],
          ),
          body: FutureBuilder<WeatherClass>(
              future: getWeather(),
              builder: (context, snapshot) {
                // if (snapshot.connectionState != ConnectionState.done) {
                //   return Center(
                //     child: Text('読み込み中...'),
                //   );
                // }
                if (snapshot.hasError) print(snapshot.error);
                if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFFc423ba),
                              const Color(0xFF00d5bf)
                            ],
                            tileMode: TileMode.repeated)),
                    // color: Colors.black,
                    key: GlobalKey(),
                    child: RefreshIndicator(
                      onRefresh: () {
                        return _refresher();
                      },
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: <Widget>[
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              margin: EdgeInsets.all(10.0),
                              child: const Text(
                                '---pressure status---',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w100,
                                    fontSize: 18.0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 24.0,
                          ),
                          Center(
                            child: Text(
                              snapshot.data.main.pressure.toString() + ' hPa',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w100,
                                  fontSize: 99.0),
                            ),
                          ),
                          Container(
                            height: 10,
                            alignment: Alignment.centerRight,
                            child:
                              Image.network(
                                'http://openweathermap.org/img/wn/' + 
                                snapshot.data.weather[0].icon + 
                                '.png',
                                // height: 200,
                                // width: 150,
                                // fit: BoxFit.fitHeight,
                                ),
                          ),
                          SizedBox(height: 60.0),
                          Center(


                            child:
                            snapshot.data.main.pressure < 1000 ? 
                            Text('今日は地獄です',



                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w100,
                                  fontSize: 18.0),
                            )
                            : Center(child: Text('今日は天国です')),
                          ),
                          SizedBox(
                            height: 24.0,
                          ),
                          Center(
                            // 5日分の天気データ
                            child: Text(_res2,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w100)),
                          ),
                          Center(
                            child: Text(
                              "最終更新 - " + timeago.format(updatedAt).toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w100),
                            ),
                          ),
                          Center(
                            child: Text(
                              _res2,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w100),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: const Text('データが存在しません'),
                  );
                }
              }),
          floatingActionButton: FutureBuilder<WeatherClass>(
            future: getWeather(),
            builder: (context, snapshot) {
              return FloatingActionButton(
                  backgroundColor: Colors.pinkAccent,
                  child: Icon(Icons.share),
                  onPressed: () {
                    // sns share button
                    // https://qiita.com/shimopata/items/142b39bab6176b6a5da9
                    Share.share(snapshot.data.main.pressure.toString() + 'hPa is 低気圧しんどいぴえん🥺️ #thekiatsu');
                    // Wiredash.of(context).show();
                  });
            }
          ),
        ));
  }
}

// Future<RemoteConfig> setupRemoteConfig() async {
//   // Yes not very useful in this case
//   final Future<RemoteConfig> _fakeRemoteConfig = RemoteConfig.instance;
//   final RemoteConfig remoteConfig = await RemoteConfig.instance;
//   // Enable developer mode to relax fetch throttling
//   remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
//   remoteConfig.setDefaults(<String, dynamic>{
//     'weather_api_key': 'apiKey',
//   });
//   return remoteConfig;
// }


