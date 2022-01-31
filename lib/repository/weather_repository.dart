import 'dart:convert';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:kiatsu/model/weather_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:geocode/geocode.dart';

import 'failures.dart';

//TODO: Android版で天気情報が取得できない問題をなんとかする

abstract class WeatherRepository {
  Future<WeatherClass> getWeather(String cityName);
}

class WeatherRepositoryImpl implements WeatherRepository {
  final http.Client _client;
  WeatherRepositoryImpl(this._client);

  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //   return await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.best,
  //     forceAndroidLocationManager: true,
  //     // timeLimit: const Duration(seconds: 10),
  //   );
  // }

  @override
  Future<WeatherClass> getWeather(String cityName) async {
    try {
      //参考URL: https://camposha.info/flutter/flutter-location/#gsc.tab=0
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          forceAndroidLocationManager: true);
      // Position position = _determinePosition() as Position;
      final rr = dotenv.env['FIREBASE_API_KEY'];
      final double lat = position.latitude;
      final double lon = position.longitude;
      final Map<String, String> queryParams = {
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
      final http.Response response = await _client.get(uri);
      if (response.statusCode == 200) {
        final parsedData = jsonDecode(response.body);
        final weatherData = WeatherClass.fromJson(parsedData);
        return weatherData;
      } else if (response.statusCode == 404) {
        print(response);
        throw Failure('データが見つかりませんでした🥺');
      } else {
        print(response);
        throw Failure('ネットワークまたはGPSエラーです＾q＾');
      }
    } on SocketException {
      throw Failure('ネットワークまたはGPSエラーです＾q＾');
    }
  }
}
