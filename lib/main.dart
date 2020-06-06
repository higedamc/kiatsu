import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:kiatsu/settings.dart';
import 'package:kiatsu/status.dart';
import 'package:kiatsu/weather_model.dart';
import 'package:weather/weather_library.dart';

import 'charts.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
//  Weather w2;
//  String _res = 'にゃーん';
  String _res2 = "ちんちん";
  String api_key = '85b471dd6643e05717257b12894250d1';
  WeatherStation ws;
  int res_p = 0;
//  WeatherStation ws;
//  int res_p = 0;

  @override
  void initState() {
    super.initState();
//    ws = new WeatherStation(key);
//    initPlatformState();
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

  Future<WeatherClass> getWeather() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String url = 'http://api.openweathermap.org/data/2.5/weather?lat=' +
        position.latitude.toString() +
        '&lon=' +
        position.longitude.toString() +
        '&APPID=$api_key';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: Status(res_p: res_p.toString(),),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => Status(
              res_p: res_p.toString(),
            ),
        '/setting': (BuildContext context) => Settings(),
        '/charts': (BuildContext context) => Charts(),
      },
    );
  }
}
