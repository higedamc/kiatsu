import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:kiatsu/weather_model.dart';
import 'package:share/share.dart';

class Status extends StatefulWidget {
  Status({
    Key key,
    this.res_p,
  }) : super(key: key);

  final String res_p;

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  String api_key = '85b471dd6643e05717257b12894250d1';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Kiatsu check meter",
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share('hPa ぴえん');
            },
          )
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
                            child: const Text(
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
                          child: const Text(
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
                            'Place: ' + snapshot.data.name.toString(),
                            style: TextStyle(
                              color: Colors.indigoAccent,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        Center(
                          child: const Text(
                            '(ΦωΦ)',
                            style: TextStyle(
                                color: Colors.orangeAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Center(
                          child: const Text(
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
    );
  }
}
