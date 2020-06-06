import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:kiatsu/const/secret.dart';
import 'package:kiatsu/model/weather_model.dart';
import 'package:kiatsu/process/secret_loader.dart';

//String key = '85b471dd6643e05717257b12894250d1';

class ApiGetter {
  Future<Secret> secret = SecretLoader(secretPath: "api_key.json").load();
  Future<WeatherClass> getWeather() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String url = 'http://api.openweathermap.org/data/2.5/weather?lat=' +
        position.latitude.toString() +
        '&lon=' +
        position.longitude.toString() +
        '&APPID=$secret';
    final response = await http.get(url);
    return WeatherClass.fromJson(json.decode(response.body));
  }
}
