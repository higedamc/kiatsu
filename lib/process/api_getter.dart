import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:kiatsu/model/weather_model.dart';

String key = '85b471dd6643e05717257b12894250d1';

class ApiGetter {
//  Future<Secret> secret = SecretLoader(secretPath: "api_key.json").load();
  Future<WeatherClass> getWeather() async {
    RemoteConfig remoteConfig = await RemoteConfig.instance;
    await remoteConfig.fetch(expiration: Duration(hours: 1));
    await remoteConfig.activateFetched();
    String secret = remoteConfig.getValue('weather_api_key').asString();
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//    print(secret);
    String url = 'http://api.openweathermap.org/data/2.5/weather?lat=' +
        position.latitude.toString() +
        '&lon=' +
        position.longitude.toString() +
        '&APPID=$key';
    final response = await http.get(url);
    return WeatherClass.fromJson(json.decode(response.body));
  }
}
