import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:kiatsu/weather_model.dart';
import 'package:share/share.dart';
import 'package:wiredash/wiredash.dart';
// import 'package:share/share.dart';
import 'const/constant.dart' as Constant;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  // WeatherClass weather = WeatherClass.empty();
  String a = Constant.key;
  String b = Constant.projectId;
  String c = Constant.secret;

  // SetState使わない実装方法
  // final StreamController<String> _streamController = StreamController();
  Future<WeatherClass> weather;


//  Weather w2;
  // static const String _res = 'にゃーん';
  static const String _res2 = "ちんちん";

  // WeatherStation ws;
  //  WeatherStation ws;
//  int res_p = 0;

  @override
  void initState() {
    super.initState();
    weather = getWeather();
//    ws = new WeatherStation(key);
//    initPlatformState();
  }

  // Future _onRefresher() async {
  //   _getchuWeather();
  //   print("どうよ？");
  // }

  /**
   * Get Weather
   * ! This is a test purpose only comment using Better Comments
   * ? Question version
   * TODO: ToDo version
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

//  void queryForecast() async {
//    List<Weather> f = await ws.fiveDayForecast();
//    setState(() {
//      _res = f.toString();
//    });
//  }

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
    _refresher() async {
      setState(() {
        weather = getWeather();
      });
    }

  // Platform messages are asynchronous, so we initialize in an async method.
//  Future<void> initPlatformState() async {
//    queryWeather();
////    queryBarometer();
//  }
  /*
  Future<void> _onRefresh() async {
    print('future');
    queryWeather();
    queryBarometer();
    queryForecast();
  }
   */

  @override
  Widget build(BuildContext context) {
    return Wiredash(
      projectId: b,
      secret: c,
      navigatorKey: _navigatorKey,
      child: MaterialApp(
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
                // sns share button
                // https://qiita.com/shimopata/items/142b39bab6176b6a5da9
                // IconButton(icon: const Icon(Icons.share), onPressed: () {})
              ],
            ),
            body: FutureBuilder<WeatherClass>(
                future: getWeather(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(
                        child: Center(
                          child: Text('読み込み中...'),
                        ));
                  }
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
                                    fontSize: 100.0),
                              ),
                            ),
                            SizedBox(height: 60.0),
                            Center(
                              child: const Text(
                                '---weather status---',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w100,
                                    fontSize: 18.0),
                              ),
                            ),
                            SizedBox(
                              height: 24.0,
                            ),
                            Center(
                              child: const Text(_res2,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w100)),
                            ),
                            Center(
                              child: Text(
                                '＾ｑ＾',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w100),
                              ),
                            ),
                            Center(
                              child: const Text(
                                'にゃーん',
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
                      child: Text('データが存在しません'),
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
                      Share.share(snapshot.data.main.pressure.toString() + 'hPa is 低気圧しんどいぴえん🥺️');
                      // Wiredash.of(context).show();
                    });
              }
            ),
          )),
    );
  }
}
