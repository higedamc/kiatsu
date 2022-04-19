import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:kiatsu/model/weather_model.dart';
import 'package:kiatsu/providers/providers.dart';
import 'package:permission_handler/permission_handler.dart';

const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
late LocationSettings locationSettings;

//TODO: 下記を参考にリファクタリングする
//参照: https://github.com/Meshkat-Shadik/WeatherApp/blob/main/lib/infrastructure/weather_repository.dart

class WeatherRepository {
  WeatherRepository(this._client);
  final http.Client _client;

  Future<WeatherClass> getWeather(String cityName, WidgetRef ref) async {
    try {
      final coords = await ref.watch(locationClientProvider).getCoordinates();
      //参考URL: https://camposha.info/flutter/flutter-location/#gsc.tab=0

      // await handlePermission();

      // final position = await Geolocator.getCurrentPosition(
      //     desiredAccuracy: LocationAccuracy.best,
      //     forceAndroidLocationManager: true,
      //     );
      final rr = (flavor == 'prod')
          ? dotenv.env['OPENWEATHERMAP_API_KEY']
          : dotenv.env['OPENWEATHERMAP_API_KEY_DEV'];
      final lat = coords.latitude;
      final lon = coords.longitude;
      final queryParams = {
        'lat': lat.toString(),
        'lon': lon.toString(),
        'APPID': rr.toString(),
      };
      final baseUrl = Uri(
        scheme: 'https',
        host: 'api.openweathermap.org',
        path: '/data/2.5/weather',
        queryParameters: queryParams,
      );
      // final baseUrl = "https://api.openweathermap.org/data/2.5/weather?q=appid=${dotenv.env['OPENWEATHERMAP_API_KEY']}&";
      final response = await _client.get(baseUrl);
      if (response.statusCode == 200) {
        final parsedData = jsonDecode(response.body) as Map<String, dynamic>;
        final weatherData = WeatherClass.fromJson(parsedData);
        return weatherData;
      } else if (response.statusCode == 404) {
        if (kDebugMode) {
          print(response);
        }
        throw Exception('データが見つかりませんでした🥺');
      } else {
        if (kDebugMode) {
          print(response);
        }
        throw Exception('ネットワークまたはGPSエラーです＾q＾');
      }
    } on PermissionDeniedException catch (e) {
      // if (e.message ==
      //     "User denied permissions to access the device's location.") {
      //   await [
      //     Permission.location,
      //     Permission.locationAlways,
      //     Permission.locationWhenInUse,
      //   ].request();
      // }
      throw Exception(e.toString());
// ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: const Text('このアプリは位置情報の許可が必須です'),
//                     action: SnackBarAction(
//                       label: '許可',
//                       onPressed: () async {
//                         //TODO: 一旦ボタンを表示させるために強制天気取得の処理を走らせてるが後で改善させる
//                         await Geolocator.openLocationSettings();
//                       },
//                     ),
//                   ),
//                 );

    }
  }
}
