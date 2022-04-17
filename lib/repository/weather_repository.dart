import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:kiatsu/model/weather_model.dart';
import 'package:permission_handler/permission_handler.dart';


const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
late LocationSettings locationSettings;

//TODO: Android版で天気情報が取得できない問題をなんとかする


// ignore: one_member_abstracts
abstract class WeatherRepository {
  Future<WeatherClass> getWeather(String cityName);
}

class WeatherRepositoryImpl implements WeatherRepository {
  WeatherRepositoryImpl(this._client);
  final http.Client _client;
  //TODO: Sort constructor declarations before other members.
  Future<bool> handlePermission() async {
    final statuses = await [
      Permission.location,
      // Permission.locationAlways,
      Permission.locationWhenInUse,
    ].request();
    if (kDebugMode) {
      print(statuses);
    }
    if (statuses[Permission.location] == PermissionStatus.granted &&
        // statuses[Permission.locationAlways] == PermissionStatus.granted &&
        statuses[Permission.locationWhenInUse] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
  

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
      
      await handlePermission();
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          forceAndroidLocationManager: true,
          );
      // Position position = _determinePosition() as Position;
      final rr = (flavor == 'prod') ?
       dotenv.env['OPENWEATHERMAP_API_KEY'] :
        dotenv.env['OPENWEATHERMAP_API_KEY_DEV'];
      final lat = position.latitude;
      final lon = position.longitude;
      final queryParams = {
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
      final response = await _client.get(uri);
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
      throw Exception(e.toString());
    }
  }
}
