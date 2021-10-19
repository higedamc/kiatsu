import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocation/geolocation.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kiatsu/model/weather_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// final weatherStateFuture = FutureProvider<List<WeatherClass>>((ref) async {
//   return fetchWeather();
// });

// List<WeatherClass> parseWeather(String responseBody) {
//   final list = json.decode(responseBody)['results'] as List<dynamic>;
//   List<WeatherClass> weather = list.map((model) => WeatherClass.fromJson(model)).toList();
//   return weather;
// }

WeatherClass parseWeather(String responseBody) {
  final parsedWeather = weatherFromJson(responseBody);
  // List<WeatherClass> weather = list.map((model) => WeatherClass.fromJson(model)).toList();
  return parsedWeather;
}

Future<WeatherClass> fetchWeather() async {
  final GeolocationResult result = await Geolocation.requestLocationPermission(
    permission: const LocationPermission(
      android: LocationPermissionAndroid.fine,
      ios: LocationPermissionIOS.always,
    ),
    openSettingsIfDenied: true,
  );
  print('result');
  final rr = dotenv.env['FIREBASE_API_KEY'];
  final result2 = await Geolocation.lastKnownLocation();
  double lat = result2.location.latitude;
  double lon = result2.location.longitude;
  Map<String, String> queryParams = {
    'lat': lat.toString(),
    'lon': lon.toString(),
    'APPID': rr.toString(),
  };
  var uri = Uri(
    scheme: 'https',
    host: 'api.openweathermap.org',
    path: '/data/2.5/weather',
    queryParameters: queryParams,
  );
  final response = await http.get(uri);
  if (response.statusCode == 200)
    return compute(parseWeather, response.body);
  else
  throw Exception('Can\'t get weather');

  // else {
  //   switch (result.error.type) {
  //     case GeolocationResultErrorType.runtime:
  //       print('Runtime Error');
  //       break;
  //     case GeolocationResultErrorType.locationNotFound:
  //       print('Location Not Found');
  //       break;
  //     case GeolocationResultErrorType.serviceDisabled:
  //       print('Service Are Disabled');
  //       break;
  //     case GeolocationResultErrorType.permissionNotGranted:
  //       print("Permission For Location Not Granted");
  //       break;
  //     case GeolocationResultErrorType.permissionDenied:
  //       print('Permissons Denied');
  //       break;
  //     case GeolocationResultErrorType.playServicesUnavailable:
  //       switch (result.error.additionalInfo as GeolocationAndroidPlayServices) {
  //         case GeolocationAndroidPlayServices.missing:
  //           print("Something went wrong with Play Services");
  //           break;
  //         case GeolocationAndroidPlayServices.updating:
  //           print("Something went wrong with Play Services");
  //           break;
  //         case GeolocationAndroidPlayServices.versionUpdateRequired:
  //           print('Play Services gotta be updated');
  //           break;
  //         case GeolocationAndroidPlayServices.disabled:
  //           print('Play Services are disabled');
  //           break;
  //         case GeolocationAndroidPlayServices.invalid:
  //           print('Something went wrong with Play Services');
  //           break;
  //       }
  //       break;
  //   }
  // }
}
