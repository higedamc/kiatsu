import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocation/geolocation.dart' as geo;
import 'package:geolocation/geolocation.dart';
import 'package:kiatsu/env/production_secrets.dart';
import 'package:kiatsu/model/weather_model.dart';
import 'package:http/http.dart' as http;

class GetWeather {
  Future<WeatherClass> getWeather() async {
    var dummy;
    final GeolocationResult result =
        await Geolocation.requestLocationPermission(
      permission: const geo.LocationPermission(
        android: LocationPermissionAndroid.fine,
        ios: LocationPermissionIOS.always,
      ),
      openSettingsIfDenied: true,
    );

    if (result.isSuccessful) {
      final rr = ProductionSecrets().firebaseApiKey;
      final result = await Geolocation.lastKnownLocation();
      double lat = result.location.latitude;
      double lon = result.location.longitude;
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
      return WeatherClass.fromJson(jsonDecode(response.body));
    } else {
      switch (result.error.type) {
        case geo.GeolocationResultErrorType.runtime:
          print('Runtime Error');
          break;
        case geo.GeolocationResultErrorType.locationNotFound:
          print('Location Not Found');
          break;
        case geo.GeolocationResultErrorType.serviceDisabled:
          print('Service Are Disabled');
          break;
        case geo.GeolocationResultErrorType.permissionNotGranted:
            print("Permission For Location Not Granted");
          break;
        case geo.GeolocationResultErrorType.permissionDenied:
          print('Permissons Denied');
          break;
        case geo.GeolocationResultErrorType.playServicesUnavailable:
          switch (
              result.error.additionalInfo as GeolocationAndroidPlayServices) {
            case geo.GeolocationAndroidPlayServices.missing:
              print("Something went wrong with Play Services");
              break;
            case geo.GeolocationAndroidPlayServices.updating:
              print("Something went wrong with Play Services");
              break;
            case geo.GeolocationAndroidPlayServices.versionUpdateRequired:
             print('Play Services gotta be updated');
              break;
            case geo.GeolocationAndroidPlayServices.disabled:
              print('Play Services are disabled');
              break;
            case geo.GeolocationAndroidPlayServices.invalid:
              print('Something went wrong with Play Services');
              break;
          }
          break;
      }
    } return dummy;
  }
}