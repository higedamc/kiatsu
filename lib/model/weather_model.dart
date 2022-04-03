// To parse this JSON data, do
//
//     final weather = weatherFromJson(jsonString);

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_model.freezed.dart';
part 'weather_model.g.dart';


WeatherClass weatherFromJson(Map<String, dynamic> str) =>
    WeatherClass.fromJson(json.decode(str.toString()) as Map<String, dynamic>);

String weatherToJson(WeatherClass data) => json.encode(data.toJson());

@freezed
abstract class WeatherClass with _$WeatherClass {
  const factory WeatherClass({
  @required Coord? coord,
  @required List<WeatherElement>? weather,
  @required String? base,
  @required Main? main,
  @required int? visibility,
  @required Wind? wind,
  @required Clouds? clouds,
  @required int? dt,
  @required Sys? sys,
  @required int? timezone,
  @required int? id,
  @required String? name,
  @required int? cod,
  }) = _WeatherClass;

  factory WeatherClass.fromJson(Map<String, dynamic> json) =>
   _$WeatherClassFromJson(json);
}

@freezed
abstract class Clouds with _$Clouds {

  const factory Clouds({
    @required int? all,
  }) = _Clouds;

  factory Clouds.fromJson(Map<String, dynamic> json) => _$CloudsFromJson(json);
}

@freezed
abstract class Coord with _$Coord {

  const factory Coord({
    @required double? lon,
    @required double? lat,
  }) = _Coord;

  factory Coord.fromJson(Map<String, dynamic> json) => _$CoordFromJson(json);
}

@freezed
abstract class Main with _$Main {

  const factory Main({
    @required double? temp,
    @required double? feelsLike,
    @required double? tempMin,
    @required double? tempMax,
    @required int? pressure,
    @required int? humidity,
  }) = _Main;

  factory Main.fromJson(Map<String, dynamic> json) => _$MainFromJson(json);
}

@freezed
abstract class Sys with _$Sys {
  
  const factory Sys ({
    @required int? type,
    @required int? id,
    @required String? country,
    @required int? sunrise,
    @required int? sunset,
  }) = _Sys;

  factory Sys.fromJson(Map<String, dynamic> json) => _$SysFromJson(json);
        
}

@freezed
abstract class WeatherElement with _$WeatherElement {

  const factory WeatherElement({
    @required int? id,
    @required String? main,
    @required String? description,
  }) = _WeatherElement;

  factory WeatherElement.fromJson(
    Map<String, dynamic> json,
    ) => _$WeatherElementFromJson(json);
}

@freezed
abstract class Wind with _$Wind {

  const factory Wind({
    @required double? speed,
    @required int? deg,
  }) = _Wind;

  factory Wind.fromJson(Map<String, dynamic> json) => _$WindFromJson(json);
}
