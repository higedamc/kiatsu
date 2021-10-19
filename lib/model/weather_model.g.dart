// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_WeatherClass _$_$_WeatherClassFromJson(Map<String, dynamic> json) {
  return _$_WeatherClass(
    coord: json['coord'] == null
        ? null
        : Coord.fromJson(json['coord'] as Map<String, dynamic>),
    weather: (json['weather'] as List<dynamic>?)
        ?.map((e) => WeatherElement.fromJson(e as Map<String, dynamic>))
        .toList(),
    base: json['base'] as String?,
    main: json['main'] == null
        ? null
        : Main.fromJson(json['main'] as Map<String, dynamic>),
    visibility: json['visibility'] as int?,
    wind: json['wind'] == null
        ? null
        : Wind.fromJson(json['wind'] as Map<String, dynamic>),
    clouds: json['clouds'] == null
        ? null
        : Clouds.fromJson(json['clouds'] as Map<String, dynamic>),
    dt: json['dt'] as int?,
    sys: json['sys'] == null
        ? null
        : Sys.fromJson(json['sys'] as Map<String, dynamic>),
    timezone: json['timezone'] as int?,
    id: json['id'] as int?,
    name: json['name'] as String?,
    cod: json['cod'] as int?,
  );
}

Map<String, dynamic> _$_$_WeatherClassToJson(_$_WeatherClass instance) =>
    <String, dynamic>{
      'coord': instance.coord,
      'weather': instance.weather,
      'base': instance.base,
      'main': instance.main,
      'visibility': instance.visibility,
      'wind': instance.wind,
      'clouds': instance.clouds,
      'dt': instance.dt,
      'sys': instance.sys,
      'timezone': instance.timezone,
      'id': instance.id,
      'name': instance.name,
      'cod': instance.cod,
    };

_$_Clouds _$_$_CloudsFromJson(Map<String, dynamic> json) {
  return _$_Clouds(
    all: json['all'] as int?,
  );
}

Map<String, dynamic> _$_$_CloudsToJson(_$_Clouds instance) => <String, dynamic>{
      'all': instance.all,
    };

_$_Coord _$_$_CoordFromJson(Map<String, dynamic> json) {
  return _$_Coord(
    lon: (json['lon'] as num?)?.toDouble(),
    lat: (json['lat'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$_$_CoordToJson(_$_Coord instance) => <String, dynamic>{
      'lon': instance.lon,
      'lat': instance.lat,
    };

_$_Main _$_$_MainFromJson(Map<String, dynamic> json) {
  return _$_Main(
    temp: (json['temp'] as num?)?.toDouble(),
    feelsLike: (json['feelsLike'] as num?)?.toDouble(),
    tempMin: (json['tempMin'] as num?)?.toDouble(),
    tempMax: (json['tempMax'] as num?)?.toDouble(),
    pressure: json['pressure'] as int?,
    humidity: json['humidity'] as int?,
  );
}

Map<String, dynamic> _$_$_MainToJson(_$_Main instance) => <String, dynamic>{
      'temp': instance.temp,
      'feelsLike': instance.feelsLike,
      'tempMin': instance.tempMin,
      'tempMax': instance.tempMax,
      'pressure': instance.pressure,
      'humidity': instance.humidity,
    };

_$_Sys _$_$_SysFromJson(Map<String, dynamic> json) {
  return _$_Sys(
    type: json['type'] as int?,
    id: json['id'] as int?,
    country: json['country'] as String?,
    sunrise: json['sunrise'] as int?,
    sunset: json['sunset'] as int?,
  );
}

Map<String, dynamic> _$_$_SysToJson(_$_Sys instance) => <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'country': instance.country,
      'sunrise': instance.sunrise,
      'sunset': instance.sunset,
    };

_$_WeatherElement _$_$_WeatherElementFromJson(Map<String, dynamic> json) {
  return _$_WeatherElement(
    id: json['id'] as int?,
    main: json['main'] as String?,
    description: json['description'] as String?,
  );
}

Map<String, dynamic> _$_$_WeatherElementToJson(_$_WeatherElement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'main': instance.main,
      'description': instance.description,
    };

_$_Wind _$_$_WindFromJson(Map<String, dynamic> json) {
  return _$_Wind(
    speed: (json['speed'] as num?)?.toDouble(),
    deg: json['deg'] as int?,
  );
}

Map<String, dynamic> _$_$_WindToJson(_$_Wind instance) => <String, dynamic>{
      'speed': instance.speed,
      'deg': instance.deg,
    };
