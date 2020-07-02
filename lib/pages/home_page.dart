import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:kiatsu/model/weather_model.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;
import 'package:weather/weather_library.dart';
import 'package:kiatsu/const/constant.dart' as Constant;


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
static const String a = Constant.key;

DateTime updatedAt = new DateTime.now();
Weather w;
  // _MyAppState({this.remoteConfig});

  // final RemoteConfig remoteConfig;

  // 以下 2 つ Wiredash 用のストリング
  // String b = Constant.projectId;
  // String c = Constant.secret;
  
  Future<WeatherClass> weather;

  WeatherStation ws = new WeatherStation(a);

 String _res2 = '';

  @override
  void initState(){
    super.initState();
    weather = getWeather();
  }

Future<void> _refresher() async {
      setState(() {
        weather = getWeather();
        updatedAt = new DateTime.now();
        // 引っ張ったときに5日分の天気データ取得する
        // queryForecast();
      });
    }

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

Future<WeatherClass> getWeather() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    String url = 'http://api.openweathermap.org/data/2.5/weather?lat=' +
        position.latitude.toString() +
        '&lon=' +
        position.longitude.toString() +
        '&APPID=$a';
    final response = await http.get(url);
    return WeatherClass.fromJson(jsonDecode(response.body));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
                      Container(
                        child: Center(
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
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      Center(
                        child: Container(
                          // color: Colors.amber,
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          height: 220,
                          width: double.maxFinite,
                          child: Card(
                            color: Colors.transparent,
                            elevation: 5,
                            child: Text(
                              snapshot.data.main.pressure.toString() + ' hPa',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w100,
                                  fontSize: 70.0),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        alignment: Alignment.center,
                        child: Text('test'),
                      ),
                      Container(
                        // constraints: BoxConstraints.expand(),
                        height: 100,
                        // width: 50,
                        alignment: Alignment.center,
                        child:
                        snapshot.data.weather[0].main == 'clouds' ?
                        Text('Cloudy',
                        style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w100,
                              fontSize: 70.0),)
                        : snapshot.data.weather[0].main.toString() == 'Clear Sky' ?
                        Text('Sunny',
                        style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w100,
                              fontSize: 70.0),)
                        : snapshot.data.weather[0].main.toString() == 'Rain' ?
                        Text('Rainy',
                        style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w100,
                              fontSize: 70.0),)
                        
                         : Text(snapshot.data.weather[0].main.toString(),
                         style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w100,
                              fontSize: 30,
                              ),),
                      ),
                      SizedBox(height: 60.0),
                      Center(


                        child:
                        snapshot.data.main.pressure < 1010 ? 
                        Text('今日はちょっと注意しましょう',



                          style: TextStyle(
                              color: Colors.yellow[900],
                              fontWeight: FontWeight.w100,
                              fontSize: 18.0),
                        )
                        : snapshot.data.main.pressure < 1008 ?
                        Text('さぁ地獄のはじまりです＾ｑ＾',
                        style: TextStyle(
                          color: Colors.red[400],
                        ),)
                        : snapshot.data.main.pressure < 1000 ?
                        Text("YOU'RE DEAD",
                        style: TextStyle(
                          color: Colors.redAccent[700],
                        ),)
                        : Center(child: Text('今日は天国です🌟🌟',style: TextStyle(
                          color: Colors.yellow,
                        ),)),
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
              return Container(
                child: Center(
                  child: Text('データがありません'),
                ),
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
        );
  }
}