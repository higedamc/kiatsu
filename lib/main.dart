import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:kiatsu/weather_model.dart';
import 'package:share/share.dart';
import 'package:weather/weather_library.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
//  Weather w2;
//  String _res = 'にゃーん';
  String _res2 = "ちんちん";
  String key = '85b471dd6643e05717257b12894250d1';
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
        '&APPID=$key';
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
    print('object');
    //print(MaterialLocalizations.of(context));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Kiatsu check meter",
          ),
          actions: <Widget>[
            // sns share button
            // https://qiita.com/shimopata/items/142b39bab6176b6a5da9
            IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  Share.share(res_p.toString() + 'hPa is 低気圧しんどいぴえん🥺️');
                })
          ],
        ),
        body: FutureBuilder<WeatherClass>(
            future: getWeather(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? Container(
                      child: ListView(
                        children: <Widget>[
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              margin: EdgeInsets.all(10.0),
                              child: Text(
                                '---pressure status---',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Colors.indigoAccent),
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
                                  color: Colors.indigoAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0),
                            ),
                          ),
                          SizedBox(height: 60.0),
                          Center(
                            child: Text(
                              '---weather status---',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.indigoAccent),
                            ),
                          ),
                          SizedBox(
                            height: 24.0,
                          ),
                          Center(
                            child: Text(
                              _res2,
                            ),
                          ),
                          Center(
                            child: Text(
                              '(ΦωΦ)',
                              style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Center(
                            child: Text(
                              'にゃーん',
                              style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                          backgroundColor: Colors.pinkAccent),
                    );
            }),
//        floatingActionButton: FloatingActionButton(
//            onPressed: , child: Icon(Icons.file_download)),
      ),
    );
  }
}
