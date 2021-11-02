import 'dart:convert';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:kiatsu/model/weather_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'failures.dart';

abstract class WeatherRepository {
  Future<WeatherClass> getWeather (String cityName);
}

class WeatherRepositoryImpl implements WeatherRepository {
  final http.Client _client;
  WeatherRepositoryImpl(this._client);

  @override
  Future<WeatherClass> getWeather(String cityName) async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true);
        final rr = dotenv.env['FIREBASE_API_KEY'];
        final double lat = position.latitude;
        final double lon = position.longitude;
        Map<String, String> queryParams = {
        'lat': lat.toString(),
        'lon': lon.toString(),
        'APPID': rr.toString(),
      };
      final uri = Uri(
        scheme: 'https',
        host: 'api.openweathermap.org',
        path: '/data/2.5/weather',
        queryParameters: queryParams,
      );
      final http.Response response =
          await _client.get(uri);
      if (response.statusCode == 200) {
        final parsedData = jsonDecode(response.body);
        final weatherData = WeatherClass.fromJson(parsedData);
        return weatherData;
      } else if (response.statusCode == 404) {
        throw Failure("データが見つかりませんでした🥺");
      } else {
        throw Failure("ネットワークまたはGPSエラーです＾q＾");
      }
    } on SocketException {
      throw Failure("ネットワークまたはGPSエラーです＾q＾");
    }
  }
}