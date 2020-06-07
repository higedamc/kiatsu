import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:kiatsu/constant/const.dart' as Constants;
import 'package:kiatsu/weather_model.dart';
import 'package:share/share.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _res2 = "ちんちん";
  String a = Constants.key;

  @override
  void initState() {
    super.initState();
  }

  Future<WeatherClass> getWeather() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String url = 'http://api.openweathermap.org/data/2.5/weather?lat=' +
        position.latitude.toString() +
        '&lon=' +
        position.longitude.toString() +
        '&APPID=$a';
    final response = await http.get(url);
    return WeatherClass.fromJson(json.decode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<WeatherClass>(
          future: getWeather(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? Scaffold(
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
                              Share.share(
                                  snapshot.data.main.pressure.toString() +
                                      'hPa is 低気圧しんどいぴえん🥺️ #kiatsu');
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
                                          snapshot.data.main.pressure
                                                  .toString() +
                                              ' hPa',
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
                  )
                : Center(
                    child:
                        CircularProgressIndicator(backgroundColor: Colors.pink),
                  );
          }),
    );
  }
}
