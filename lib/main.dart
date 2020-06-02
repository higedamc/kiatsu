import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Weather w2;
  String _res = 'にゃーん';
  String _res2 = "ちんちん";
  String key = '85b471dd6643e05717257b12894250d1';
  WeatherStation ws;

  @override
  void initState() {
    super.initState();
    ws = new WeatherStation(key);
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    queryWeather();
    queryBarometer();
  }

  void queryForecast() async {
    List<Weather> f = await ws.fiveDayForecast();
    setState(() {
      _res = f.toString();
    });
  }

  void queryWeather() async {
    Weather w = await ws.currentWeather();
    setState(() {
      _res = w.toString();
      print('weather api test*****************************');
      print(_res);
    });
  }

  void queryBarometer() async {
    Weather w2 = await ws.currentWeather();
    double pressure = w2.pressure.toDouble();
    setState(() {
      _res2 = w2.toString();
      print('pressure *****************');
      print(w2);
      print('pressure *****************');
      print(pressure);
//      print('pressure *****************');
//      print(_res2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Kiatsu Example"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _res,
              ),
              Text(
                '(ΦωΦ)',
                style: TextStyle(
                    color: Colors.orangeAccent, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: queryForecast, child: Icon(Icons.file_download)),
      ),
    );
  }
}
