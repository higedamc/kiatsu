// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'weather_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

WeatherClass _$WeatherClassFromJson(Map<String, dynamic> json) {
  return _WeatherClass.fromJson(json);
}

/// @nodoc
class _$WeatherClassTearOff {
  const _$WeatherClassTearOff();

  _WeatherClass call(
      {Coord? coord,
      List<WeatherElement>? weather,
      String? base,
      Main? main,
      int? visibility,
      Wind? wind,
      Clouds? clouds,
      int? dt,
      Sys? sys,
      int? timezone,
      int? id,
      String? name,
      int? cod}) {
    return _WeatherClass(
      coord: coord,
      weather: weather,
      base: base,
      main: main,
      visibility: visibility,
      wind: wind,
      clouds: clouds,
      dt: dt,
      sys: sys,
      timezone: timezone,
      id: id,
      name: name,
      cod: cod,
    );
  }

  WeatherClass fromJson(Map<String, Object?> json) {
    return WeatherClass.fromJson(json);
  }
}

/// @nodoc
const $WeatherClass = _$WeatherClassTearOff();

/// @nodoc
mixin _$WeatherClass {
  Coord? get coord => throw _privateConstructorUsedError;
  List<WeatherElement>? get weather => throw _privateConstructorUsedError;
  String? get base => throw _privateConstructorUsedError;
  Main? get main => throw _privateConstructorUsedError;
  int? get visibility => throw _privateConstructorUsedError;
  Wind? get wind => throw _privateConstructorUsedError;
  Clouds? get clouds => throw _privateConstructorUsedError;
  int? get dt => throw _privateConstructorUsedError;
  Sys? get sys => throw _privateConstructorUsedError;
  int? get timezone => throw _privateConstructorUsedError;
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  int? get cod => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WeatherClassCopyWith<WeatherClass> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeatherClassCopyWith<$Res> {
  factory $WeatherClassCopyWith(
          WeatherClass value, $Res Function(WeatherClass) then) =
      _$WeatherClassCopyWithImpl<$Res>;
  $Res call(
      {Coord? coord,
      List<WeatherElement>? weather,
      String? base,
      Main? main,
      int? visibility,
      Wind? wind,
      Clouds? clouds,
      int? dt,
      Sys? sys,
      int? timezone,
      int? id,
      String? name,
      int? cod});

  $CoordCopyWith<$Res>? get coord;
  $MainCopyWith<$Res>? get main;
  $WindCopyWith<$Res>? get wind;
  $CloudsCopyWith<$Res>? get clouds;
  $SysCopyWith<$Res>? get sys;
}

/// @nodoc
class _$WeatherClassCopyWithImpl<$Res> implements $WeatherClassCopyWith<$Res> {
  _$WeatherClassCopyWithImpl(this._value, this._then);

  final WeatherClass _value;
  // ignore: unused_field
  final $Res Function(WeatherClass) _then;

  @override
  $Res call({
    Object? coord = freezed,
    Object? weather = freezed,
    Object? base = freezed,
    Object? main = freezed,
    Object? visibility = freezed,
    Object? wind = freezed,
    Object? clouds = freezed,
    Object? dt = freezed,
    Object? sys = freezed,
    Object? timezone = freezed,
    Object? id = freezed,
    Object? name = freezed,
    Object? cod = freezed,
  }) {
    return _then(_value.copyWith(
      coord: coord == freezed
          ? _value.coord
          : coord // ignore: cast_nullable_to_non_nullable
              as Coord?,
      weather: weather == freezed
          ? _value.weather
          : weather // ignore: cast_nullable_to_non_nullable
              as List<WeatherElement>?,
      base: base == freezed
          ? _value.base
          : base // ignore: cast_nullable_to_non_nullable
              as String?,
      main: main == freezed
          ? _value.main
          : main // ignore: cast_nullable_to_non_nullable
              as Main?,
      visibility: visibility == freezed
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as int?,
      wind: wind == freezed
          ? _value.wind
          : wind // ignore: cast_nullable_to_non_nullable
              as Wind?,
      clouds: clouds == freezed
          ? _value.clouds
          : clouds // ignore: cast_nullable_to_non_nullable
              as Clouds?,
      dt: dt == freezed
          ? _value.dt
          : dt // ignore: cast_nullable_to_non_nullable
              as int?,
      sys: sys == freezed
          ? _value.sys
          : sys // ignore: cast_nullable_to_non_nullable
              as Sys?,
      timezone: timezone == freezed
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as int?,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      cod: cod == freezed
          ? _value.cod
          : cod // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  @override
  $CoordCopyWith<$Res>? get coord {
    if (_value.coord == null) {
      return null;
    }

    return $CoordCopyWith<$Res>(_value.coord!, (value) {
      return _then(_value.copyWith(coord: value));
    });
  }

  @override
  $MainCopyWith<$Res>? get main {
    if (_value.main == null) {
      return null;
    }

    return $MainCopyWith<$Res>(_value.main!, (value) {
      return _then(_value.copyWith(main: value));
    });
  }

  @override
  $WindCopyWith<$Res>? get wind {
    if (_value.wind == null) {
      return null;
    }

    return $WindCopyWith<$Res>(_value.wind!, (value) {
      return _then(_value.copyWith(wind: value));
    });
  }

  @override
  $CloudsCopyWith<$Res>? get clouds {
    if (_value.clouds == null) {
      return null;
    }

    return $CloudsCopyWith<$Res>(_value.clouds!, (value) {
      return _then(_value.copyWith(clouds: value));
    });
  }

  @override
  $SysCopyWith<$Res>? get sys {
    if (_value.sys == null) {
      return null;
    }

    return $SysCopyWith<$Res>(_value.sys!, (value) {
      return _then(_value.copyWith(sys: value));
    });
  }
}

/// @nodoc
abstract class _$WeatherClassCopyWith<$Res>
    implements $WeatherClassCopyWith<$Res> {
  factory _$WeatherClassCopyWith(
          _WeatherClass value, $Res Function(_WeatherClass) then) =
      __$WeatherClassCopyWithImpl<$Res>;
  @override
  $Res call(
      {Coord? coord,
      List<WeatherElement>? weather,
      String? base,
      Main? main,
      int? visibility,
      Wind? wind,
      Clouds? clouds,
      int? dt,
      Sys? sys,
      int? timezone,
      int? id,
      String? name,
      int? cod});

  @override
  $CoordCopyWith<$Res>? get coord;
  @override
  $MainCopyWith<$Res>? get main;
  @override
  $WindCopyWith<$Res>? get wind;
  @override
  $CloudsCopyWith<$Res>? get clouds;
  @override
  $SysCopyWith<$Res>? get sys;
}

/// @nodoc
class __$WeatherClassCopyWithImpl<$Res> extends _$WeatherClassCopyWithImpl<$Res>
    implements _$WeatherClassCopyWith<$Res> {
  __$WeatherClassCopyWithImpl(
      _WeatherClass _value, $Res Function(_WeatherClass) _then)
      : super(_value, (v) => _then(v as _WeatherClass));

  @override
  _WeatherClass get _value => super._value as _WeatherClass;

  @override
  $Res call({
    Object? coord = freezed,
    Object? weather = freezed,
    Object? base = freezed,
    Object? main = freezed,
    Object? visibility = freezed,
    Object? wind = freezed,
    Object? clouds = freezed,
    Object? dt = freezed,
    Object? sys = freezed,
    Object? timezone = freezed,
    Object? id = freezed,
    Object? name = freezed,
    Object? cod = freezed,
  }) {
    return _then(_WeatherClass(
      coord: coord == freezed
          ? _value.coord
          : coord // ignore: cast_nullable_to_non_nullable
              as Coord?,
      weather: weather == freezed
          ? _value.weather
          : weather // ignore: cast_nullable_to_non_nullable
              as List<WeatherElement>?,
      base: base == freezed
          ? _value.base
          : base // ignore: cast_nullable_to_non_nullable
              as String?,
      main: main == freezed
          ? _value.main
          : main // ignore: cast_nullable_to_non_nullable
              as Main?,
      visibility: visibility == freezed
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as int?,
      wind: wind == freezed
          ? _value.wind
          : wind // ignore: cast_nullable_to_non_nullable
              as Wind?,
      clouds: clouds == freezed
          ? _value.clouds
          : clouds // ignore: cast_nullable_to_non_nullable
              as Clouds?,
      dt: dt == freezed
          ? _value.dt
          : dt // ignore: cast_nullable_to_non_nullable
              as int?,
      sys: sys == freezed
          ? _value.sys
          : sys // ignore: cast_nullable_to_non_nullable
              as Sys?,
      timezone: timezone == freezed
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as int?,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      cod: cod == freezed
          ? _value.cod
          : cod // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_WeatherClass implements _WeatherClass {
  const _$_WeatherClass(
      {this.coord,
      this.weather,
      this.base,
      this.main,
      this.visibility,
      this.wind,
      this.clouds,
      this.dt,
      this.sys,
      this.timezone,
      this.id,
      this.name,
      this.cod});

  factory _$_WeatherClass.fromJson(Map<String, dynamic> json) =>
      _$$_WeatherClassFromJson(json);

  @override
  final Coord? coord;
  @override
  final List<WeatherElement>? weather;
  @override
  final String? base;
  @override
  final Main? main;
  @override
  final int? visibility;
  @override
  final Wind? wind;
  @override
  final Clouds? clouds;
  @override
  final int? dt;
  @override
  final Sys? sys;
  @override
  final int? timezone;
  @override
  final int? id;
  @override
  final String? name;
  @override
  final int? cod;

  @override
  String toString() {
    return 'WeatherClass(coord: $coord, weather: $weather, base: $base, main: $main, visibility: $visibility, wind: $wind, clouds: $clouds, dt: $dt, sys: $sys, timezone: $timezone, id: $id, name: $name, cod: $cod)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WeatherClass &&
            const DeepCollectionEquality().equals(other.coord, coord) &&
            const DeepCollectionEquality().equals(other.weather, weather) &&
            const DeepCollectionEquality().equals(other.base, base) &&
            const DeepCollectionEquality().equals(other.main, main) &&
            const DeepCollectionEquality()
                .equals(other.visibility, visibility) &&
            const DeepCollectionEquality().equals(other.wind, wind) &&
            const DeepCollectionEquality().equals(other.clouds, clouds) &&
            const DeepCollectionEquality().equals(other.dt, dt) &&
            const DeepCollectionEquality().equals(other.sys, sys) &&
            const DeepCollectionEquality().equals(other.timezone, timezone) &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.cod, cod));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(coord),
      const DeepCollectionEquality().hash(weather),
      const DeepCollectionEquality().hash(base),
      const DeepCollectionEquality().hash(main),
      const DeepCollectionEquality().hash(visibility),
      const DeepCollectionEquality().hash(wind),
      const DeepCollectionEquality().hash(clouds),
      const DeepCollectionEquality().hash(dt),
      const DeepCollectionEquality().hash(sys),
      const DeepCollectionEquality().hash(timezone),
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(cod));

  @JsonKey(ignore: true)
  @override
  _$WeatherClassCopyWith<_WeatherClass> get copyWith =>
      __$WeatherClassCopyWithImpl<_WeatherClass>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_WeatherClassToJson(this);
  }
}

abstract class _WeatherClass implements WeatherClass {
  const factory _WeatherClass(
      {Coord? coord,
      List<WeatherElement>? weather,
      String? base,
      Main? main,
      int? visibility,
      Wind? wind,
      Clouds? clouds,
      int? dt,
      Sys? sys,
      int? timezone,
      int? id,
      String? name,
      int? cod}) = _$_WeatherClass;

  factory _WeatherClass.fromJson(Map<String, dynamic> json) =
      _$_WeatherClass.fromJson;

  @override
  Coord? get coord;
  @override
  List<WeatherElement>? get weather;
  @override
  String? get base;
  @override
  Main? get main;
  @override
  int? get visibility;
  @override
  Wind? get wind;
  @override
  Clouds? get clouds;
  @override
  int? get dt;
  @override
  Sys? get sys;
  @override
  int? get timezone;
  @override
  int? get id;
  @override
  String? get name;
  @override
  int? get cod;
  @override
  @JsonKey(ignore: true)
  _$WeatherClassCopyWith<_WeatherClass> get copyWith =>
      throw _privateConstructorUsedError;
}

Clouds _$CloudsFromJson(Map<String, dynamic> json) {
  return _Clouds.fromJson(json);
}

/// @nodoc
class _$CloudsTearOff {
  const _$CloudsTearOff();

  _Clouds call({int? all}) {
    return _Clouds(
      all: all,
    );
  }

  Clouds fromJson(Map<String, Object?> json) {
    return Clouds.fromJson(json);
  }
}

/// @nodoc
const $Clouds = _$CloudsTearOff();

/// @nodoc
mixin _$Clouds {
  int? get all => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CloudsCopyWith<Clouds> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CloudsCopyWith<$Res> {
  factory $CloudsCopyWith(Clouds value, $Res Function(Clouds) then) =
      _$CloudsCopyWithImpl<$Res>;
  $Res call({int? all});
}

/// @nodoc
class _$CloudsCopyWithImpl<$Res> implements $CloudsCopyWith<$Res> {
  _$CloudsCopyWithImpl(this._value, this._then);

  final Clouds _value;
  // ignore: unused_field
  final $Res Function(Clouds) _then;

  @override
  $Res call({
    Object? all = freezed,
  }) {
    return _then(_value.copyWith(
      all: all == freezed
          ? _value.all
          : all // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
abstract class _$CloudsCopyWith<$Res> implements $CloudsCopyWith<$Res> {
  factory _$CloudsCopyWith(_Clouds value, $Res Function(_Clouds) then) =
      __$CloudsCopyWithImpl<$Res>;
  @override
  $Res call({int? all});
}

/// @nodoc
class __$CloudsCopyWithImpl<$Res> extends _$CloudsCopyWithImpl<$Res>
    implements _$CloudsCopyWith<$Res> {
  __$CloudsCopyWithImpl(_Clouds _value, $Res Function(_Clouds) _then)
      : super(_value, (v) => _then(v as _Clouds));

  @override
  _Clouds get _value => super._value as _Clouds;

  @override
  $Res call({
    Object? all = freezed,
  }) {
    return _then(_Clouds(
      all: all == freezed
          ? _value.all
          : all // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Clouds implements _Clouds {
  const _$_Clouds({this.all});

  factory _$_Clouds.fromJson(Map<String, dynamic> json) =>
      _$$_CloudsFromJson(json);

  @override
  final int? all;

  @override
  String toString() {
    return 'Clouds(all: $all)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Clouds &&
            const DeepCollectionEquality().equals(other.all, all));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(all));

  @JsonKey(ignore: true)
  @override
  _$CloudsCopyWith<_Clouds> get copyWith =>
      __$CloudsCopyWithImpl<_Clouds>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CloudsToJson(this);
  }
}

abstract class _Clouds implements Clouds {
  const factory _Clouds({int? all}) = _$_Clouds;

  factory _Clouds.fromJson(Map<String, dynamic> json) = _$_Clouds.fromJson;

  @override
  int? get all;
  @override
  @JsonKey(ignore: true)
  _$CloudsCopyWith<_Clouds> get copyWith => throw _privateConstructorUsedError;
}

Coord _$CoordFromJson(Map<String, dynamic> json) {
  return _Coord.fromJson(json);
}

/// @nodoc
class _$CoordTearOff {
  const _$CoordTearOff();

  _Coord call({double? lon, double? lat}) {
    return _Coord(
      lon: lon,
      lat: lat,
    );
  }

  Coord fromJson(Map<String, Object?> json) {
    return Coord.fromJson(json);
  }
}

/// @nodoc
const $Coord = _$CoordTearOff();

/// @nodoc
mixin _$Coord {
  double? get lon => throw _privateConstructorUsedError;
  double? get lat => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CoordCopyWith<Coord> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoordCopyWith<$Res> {
  factory $CoordCopyWith(Coord value, $Res Function(Coord) then) =
      _$CoordCopyWithImpl<$Res>;
  $Res call({double? lon, double? lat});
}

/// @nodoc
class _$CoordCopyWithImpl<$Res> implements $CoordCopyWith<$Res> {
  _$CoordCopyWithImpl(this._value, this._then);

  final Coord _value;
  // ignore: unused_field
  final $Res Function(Coord) _then;

  @override
  $Res call({
    Object? lon = freezed,
    Object? lat = freezed,
  }) {
    return _then(_value.copyWith(
      lon: lon == freezed
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
      lat: lat == freezed
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
abstract class _$CoordCopyWith<$Res> implements $CoordCopyWith<$Res> {
  factory _$CoordCopyWith(_Coord value, $Res Function(_Coord) then) =
      __$CoordCopyWithImpl<$Res>;
  @override
  $Res call({double? lon, double? lat});
}

/// @nodoc
class __$CoordCopyWithImpl<$Res> extends _$CoordCopyWithImpl<$Res>
    implements _$CoordCopyWith<$Res> {
  __$CoordCopyWithImpl(_Coord _value, $Res Function(_Coord) _then)
      : super(_value, (v) => _then(v as _Coord));

  @override
  _Coord get _value => super._value as _Coord;

  @override
  $Res call({
    Object? lon = freezed,
    Object? lat = freezed,
  }) {
    return _then(_Coord(
      lon: lon == freezed
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
      lat: lat == freezed
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Coord implements _Coord {
  const _$_Coord({this.lon, this.lat});

  factory _$_Coord.fromJson(Map<String, dynamic> json) =>
      _$$_CoordFromJson(json);

  @override
  final double? lon;
  @override
  final double? lat;

  @override
  String toString() {
    return 'Coord(lon: $lon, lat: $lat)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Coord &&
            const DeepCollectionEquality().equals(other.lon, lon) &&
            const DeepCollectionEquality().equals(other.lat, lat));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(lon),
      const DeepCollectionEquality().hash(lat));

  @JsonKey(ignore: true)
  @override
  _$CoordCopyWith<_Coord> get copyWith =>
      __$CoordCopyWithImpl<_Coord>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CoordToJson(this);
  }
}

abstract class _Coord implements Coord {
  const factory _Coord({double? lon, double? lat}) = _$_Coord;

  factory _Coord.fromJson(Map<String, dynamic> json) = _$_Coord.fromJson;

  @override
  double? get lon;
  @override
  double? get lat;
  @override
  @JsonKey(ignore: true)
  _$CoordCopyWith<_Coord> get copyWith => throw _privateConstructorUsedError;
}

Main _$MainFromJson(Map<String, dynamic> json) {
  return _Main.fromJson(json);
}

/// @nodoc
class _$MainTearOff {
  const _$MainTearOff();

  _Main call(
      {double? temp,
      double? feelsLike,
      double? tempMin,
      double? tempMax,
      int? pressure,
      int? humidity}) {
    return _Main(
      temp: temp,
      feelsLike: feelsLike,
      tempMin: tempMin,
      tempMax: tempMax,
      pressure: pressure,
      humidity: humidity,
    );
  }

  Main fromJson(Map<String, Object?> json) {
    return Main.fromJson(json);
  }
}

/// @nodoc
const $Main = _$MainTearOff();

/// @nodoc
mixin _$Main {
  double? get temp => throw _privateConstructorUsedError;
  double? get feelsLike => throw _privateConstructorUsedError;
  double? get tempMin => throw _privateConstructorUsedError;
  double? get tempMax => throw _privateConstructorUsedError;
  int? get pressure => throw _privateConstructorUsedError;
  int? get humidity => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MainCopyWith<Main> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MainCopyWith<$Res> {
  factory $MainCopyWith(Main value, $Res Function(Main) then) =
      _$MainCopyWithImpl<$Res>;
  $Res call(
      {double? temp,
      double? feelsLike,
      double? tempMin,
      double? tempMax,
      int? pressure,
      int? humidity});
}

/// @nodoc
class _$MainCopyWithImpl<$Res> implements $MainCopyWith<$Res> {
  _$MainCopyWithImpl(this._value, this._then);

  final Main _value;
  // ignore: unused_field
  final $Res Function(Main) _then;

  @override
  $Res call({
    Object? temp = freezed,
    Object? feelsLike = freezed,
    Object? tempMin = freezed,
    Object? tempMax = freezed,
    Object? pressure = freezed,
    Object? humidity = freezed,
  }) {
    return _then(_value.copyWith(
      temp: temp == freezed
          ? _value.temp
          : temp // ignore: cast_nullable_to_non_nullable
              as double?,
      feelsLike: feelsLike == freezed
          ? _value.feelsLike
          : feelsLike // ignore: cast_nullable_to_non_nullable
              as double?,
      tempMin: tempMin == freezed
          ? _value.tempMin
          : tempMin // ignore: cast_nullable_to_non_nullable
              as double?,
      tempMax: tempMax == freezed
          ? _value.tempMax
          : tempMax // ignore: cast_nullable_to_non_nullable
              as double?,
      pressure: pressure == freezed
          ? _value.pressure
          : pressure // ignore: cast_nullable_to_non_nullable
              as int?,
      humidity: humidity == freezed
          ? _value.humidity
          : humidity // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
abstract class _$MainCopyWith<$Res> implements $MainCopyWith<$Res> {
  factory _$MainCopyWith(_Main value, $Res Function(_Main) then) =
      __$MainCopyWithImpl<$Res>;
  @override
  $Res call(
      {double? temp,
      double? feelsLike,
      double? tempMin,
      double? tempMax,
      int? pressure,
      int? humidity});
}

/// @nodoc
class __$MainCopyWithImpl<$Res> extends _$MainCopyWithImpl<$Res>
    implements _$MainCopyWith<$Res> {
  __$MainCopyWithImpl(_Main _value, $Res Function(_Main) _then)
      : super(_value, (v) => _then(v as _Main));

  @override
  _Main get _value => super._value as _Main;

  @override
  $Res call({
    Object? temp = freezed,
    Object? feelsLike = freezed,
    Object? tempMin = freezed,
    Object? tempMax = freezed,
    Object? pressure = freezed,
    Object? humidity = freezed,
  }) {
    return _then(_Main(
      temp: temp == freezed
          ? _value.temp
          : temp // ignore: cast_nullable_to_non_nullable
              as double?,
      feelsLike: feelsLike == freezed
          ? _value.feelsLike
          : feelsLike // ignore: cast_nullable_to_non_nullable
              as double?,
      tempMin: tempMin == freezed
          ? _value.tempMin
          : tempMin // ignore: cast_nullable_to_non_nullable
              as double?,
      tempMax: tempMax == freezed
          ? _value.tempMax
          : tempMax // ignore: cast_nullable_to_non_nullable
              as double?,
      pressure: pressure == freezed
          ? _value.pressure
          : pressure // ignore: cast_nullable_to_non_nullable
              as int?,
      humidity: humidity == freezed
          ? _value.humidity
          : humidity // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Main implements _Main {
  const _$_Main(
      {this.temp,
      this.feelsLike,
      this.tempMin,
      this.tempMax,
      this.pressure,
      this.humidity});

  factory _$_Main.fromJson(Map<String, dynamic> json) => _$$_MainFromJson(json);

  @override
  final double? temp;
  @override
  final double? feelsLike;
  @override
  final double? tempMin;
  @override
  final double? tempMax;
  @override
  final int? pressure;
  @override
  final int? humidity;

  @override
  String toString() {
    return 'Main(temp: $temp, feelsLike: $feelsLike, tempMin: $tempMin, tempMax: $tempMax, pressure: $pressure, humidity: $humidity)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Main &&
            const DeepCollectionEquality().equals(other.temp, temp) &&
            const DeepCollectionEquality().equals(other.feelsLike, feelsLike) &&
            const DeepCollectionEquality().equals(other.tempMin, tempMin) &&
            const DeepCollectionEquality().equals(other.tempMax, tempMax) &&
            const DeepCollectionEquality().equals(other.pressure, pressure) &&
            const DeepCollectionEquality().equals(other.humidity, humidity));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(temp),
      const DeepCollectionEquality().hash(feelsLike),
      const DeepCollectionEquality().hash(tempMin),
      const DeepCollectionEquality().hash(tempMax),
      const DeepCollectionEquality().hash(pressure),
      const DeepCollectionEquality().hash(humidity));

  @JsonKey(ignore: true)
  @override
  _$MainCopyWith<_Main> get copyWith =>
      __$MainCopyWithImpl<_Main>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MainToJson(this);
  }
}

abstract class _Main implements Main {
  const factory _Main(
      {double? temp,
      double? feelsLike,
      double? tempMin,
      double? tempMax,
      int? pressure,
      int? humidity}) = _$_Main;

  factory _Main.fromJson(Map<String, dynamic> json) = _$_Main.fromJson;

  @override
  double? get temp;
  @override
  double? get feelsLike;
  @override
  double? get tempMin;
  @override
  double? get tempMax;
  @override
  int? get pressure;
  @override
  int? get humidity;
  @override
  @JsonKey(ignore: true)
  _$MainCopyWith<_Main> get copyWith => throw _privateConstructorUsedError;
}

Sys _$SysFromJson(Map<String, dynamic> json) {
  return _Sys.fromJson(json);
}

/// @nodoc
class _$SysTearOff {
  const _$SysTearOff();

  _Sys call({int? type, int? id, String? country, int? sunrise, int? sunset}) {
    return _Sys(
      type: type,
      id: id,
      country: country,
      sunrise: sunrise,
      sunset: sunset,
    );
  }

  Sys fromJson(Map<String, Object?> json) {
    return Sys.fromJson(json);
  }
}

/// @nodoc
const $Sys = _$SysTearOff();

/// @nodoc
mixin _$Sys {
  int? get type => throw _privateConstructorUsedError;
  int? get id => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  int? get sunrise => throw _privateConstructorUsedError;
  int? get sunset => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SysCopyWith<Sys> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SysCopyWith<$Res> {
  factory $SysCopyWith(Sys value, $Res Function(Sys) then) =
      _$SysCopyWithImpl<$Res>;
  $Res call({int? type, int? id, String? country, int? sunrise, int? sunset});
}

/// @nodoc
class _$SysCopyWithImpl<$Res> implements $SysCopyWith<$Res> {
  _$SysCopyWithImpl(this._value, this._then);

  final Sys _value;
  // ignore: unused_field
  final $Res Function(Sys) _then;

  @override
  $Res call({
    Object? type = freezed,
    Object? id = freezed,
    Object? country = freezed,
    Object? sunrise = freezed,
    Object? sunset = freezed,
  }) {
    return _then(_value.copyWith(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int?,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      country: country == freezed
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      sunrise: sunrise == freezed
          ? _value.sunrise
          : sunrise // ignore: cast_nullable_to_non_nullable
              as int?,
      sunset: sunset == freezed
          ? _value.sunset
          : sunset // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
abstract class _$SysCopyWith<$Res> implements $SysCopyWith<$Res> {
  factory _$SysCopyWith(_Sys value, $Res Function(_Sys) then) =
      __$SysCopyWithImpl<$Res>;
  @override
  $Res call({int? type, int? id, String? country, int? sunrise, int? sunset});
}

/// @nodoc
class __$SysCopyWithImpl<$Res> extends _$SysCopyWithImpl<$Res>
    implements _$SysCopyWith<$Res> {
  __$SysCopyWithImpl(_Sys _value, $Res Function(_Sys) _then)
      : super(_value, (v) => _then(v as _Sys));

  @override
  _Sys get _value => super._value as _Sys;

  @override
  $Res call({
    Object? type = freezed,
    Object? id = freezed,
    Object? country = freezed,
    Object? sunrise = freezed,
    Object? sunset = freezed,
  }) {
    return _then(_Sys(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int?,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      country: country == freezed
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      sunrise: sunrise == freezed
          ? _value.sunrise
          : sunrise // ignore: cast_nullable_to_non_nullable
              as int?,
      sunset: sunset == freezed
          ? _value.sunset
          : sunset // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Sys implements _Sys {
  const _$_Sys({this.type, this.id, this.country, this.sunrise, this.sunset});

  factory _$_Sys.fromJson(Map<String, dynamic> json) => _$$_SysFromJson(json);

  @override
  final int? type;
  @override
  final int? id;
  @override
  final String? country;
  @override
  final int? sunrise;
  @override
  final int? sunset;

  @override
  String toString() {
    return 'Sys(type: $type, id: $id, country: $country, sunrise: $sunrise, sunset: $sunset)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Sys &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.country, country) &&
            const DeepCollectionEquality().equals(other.sunrise, sunrise) &&
            const DeepCollectionEquality().equals(other.sunset, sunset));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(country),
      const DeepCollectionEquality().hash(sunrise),
      const DeepCollectionEquality().hash(sunset));

  @JsonKey(ignore: true)
  @override
  _$SysCopyWith<_Sys> get copyWith =>
      __$SysCopyWithImpl<_Sys>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SysToJson(this);
  }
}

abstract class _Sys implements Sys {
  const factory _Sys(
      {int? type,
      int? id,
      String? country,
      int? sunrise,
      int? sunset}) = _$_Sys;

  factory _Sys.fromJson(Map<String, dynamic> json) = _$_Sys.fromJson;

  @override
  int? get type;
  @override
  int? get id;
  @override
  String? get country;
  @override
  int? get sunrise;
  @override
  int? get sunset;
  @override
  @JsonKey(ignore: true)
  _$SysCopyWith<_Sys> get copyWith => throw _privateConstructorUsedError;
}

WeatherElement _$WeatherElementFromJson(Map<String, dynamic> json) {
  return _WeatherElement.fromJson(json);
}

/// @nodoc
class _$WeatherElementTearOff {
  const _$WeatherElementTearOff();

  _WeatherElement call({int? id, String? main, String? description}) {
    return _WeatherElement(
      id: id,
      main: main,
      description: description,
    );
  }

  WeatherElement fromJson(Map<String, Object?> json) {
    return WeatherElement.fromJson(json);
  }
}

/// @nodoc
const $WeatherElement = _$WeatherElementTearOff();

/// @nodoc
mixin _$WeatherElement {
  int? get id => throw _privateConstructorUsedError;
  String? get main => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WeatherElementCopyWith<WeatherElement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeatherElementCopyWith<$Res> {
  factory $WeatherElementCopyWith(
          WeatherElement value, $Res Function(WeatherElement) then) =
      _$WeatherElementCopyWithImpl<$Res>;
  $Res call({int? id, String? main, String? description});
}

/// @nodoc
class _$WeatherElementCopyWithImpl<$Res>
    implements $WeatherElementCopyWith<$Res> {
  _$WeatherElementCopyWithImpl(this._value, this._then);

  final WeatherElement _value;
  // ignore: unused_field
  final $Res Function(WeatherElement) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? main = freezed,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      main: main == freezed
          ? _value.main
          : main // ignore: cast_nullable_to_non_nullable
              as String?,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$WeatherElementCopyWith<$Res>
    implements $WeatherElementCopyWith<$Res> {
  factory _$WeatherElementCopyWith(
          _WeatherElement value, $Res Function(_WeatherElement) then) =
      __$WeatherElementCopyWithImpl<$Res>;
  @override
  $Res call({int? id, String? main, String? description});
}

/// @nodoc
class __$WeatherElementCopyWithImpl<$Res>
    extends _$WeatherElementCopyWithImpl<$Res>
    implements _$WeatherElementCopyWith<$Res> {
  __$WeatherElementCopyWithImpl(
      _WeatherElement _value, $Res Function(_WeatherElement) _then)
      : super(_value, (v) => _then(v as _WeatherElement));

  @override
  _WeatherElement get _value => super._value as _WeatherElement;

  @override
  $Res call({
    Object? id = freezed,
    Object? main = freezed,
    Object? description = freezed,
  }) {
    return _then(_WeatherElement(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      main: main == freezed
          ? _value.main
          : main // ignore: cast_nullable_to_non_nullable
              as String?,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_WeatherElement implements _WeatherElement {
  const _$_WeatherElement({this.id, this.main, this.description});

  factory _$_WeatherElement.fromJson(Map<String, dynamic> json) =>
      _$$_WeatherElementFromJson(json);

  @override
  final int? id;
  @override
  final String? main;
  @override
  final String? description;

  @override
  String toString() {
    return 'WeatherElement(id: $id, main: $main, description: $description)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WeatherElement &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.main, main) &&
            const DeepCollectionEquality()
                .equals(other.description, description));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(main),
      const DeepCollectionEquality().hash(description));

  @JsonKey(ignore: true)
  @override
  _$WeatherElementCopyWith<_WeatherElement> get copyWith =>
      __$WeatherElementCopyWithImpl<_WeatherElement>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_WeatherElementToJson(this);
  }
}

abstract class _WeatherElement implements WeatherElement {
  const factory _WeatherElement({int? id, String? main, String? description}) =
      _$_WeatherElement;

  factory _WeatherElement.fromJson(Map<String, dynamic> json) =
      _$_WeatherElement.fromJson;

  @override
  int? get id;
  @override
  String? get main;
  @override
  String? get description;
  @override
  @JsonKey(ignore: true)
  _$WeatherElementCopyWith<_WeatherElement> get copyWith =>
      throw _privateConstructorUsedError;
}

Wind _$WindFromJson(Map<String, dynamic> json) {
  return _Wind.fromJson(json);
}

/// @nodoc
class _$WindTearOff {
  const _$WindTearOff();

  _Wind call({double? speed, int? deg}) {
    return _Wind(
      speed: speed,
      deg: deg,
    );
  }

  Wind fromJson(Map<String, Object?> json) {
    return Wind.fromJson(json);
  }
}

/// @nodoc
const $Wind = _$WindTearOff();

/// @nodoc
mixin _$Wind {
  double? get speed => throw _privateConstructorUsedError;
  int? get deg => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WindCopyWith<Wind> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WindCopyWith<$Res> {
  factory $WindCopyWith(Wind value, $Res Function(Wind) then) =
      _$WindCopyWithImpl<$Res>;
  $Res call({double? speed, int? deg});
}

/// @nodoc
class _$WindCopyWithImpl<$Res> implements $WindCopyWith<$Res> {
  _$WindCopyWithImpl(this._value, this._then);

  final Wind _value;
  // ignore: unused_field
  final $Res Function(Wind) _then;

  @override
  $Res call({
    Object? speed = freezed,
    Object? deg = freezed,
  }) {
    return _then(_value.copyWith(
      speed: speed == freezed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double?,
      deg: deg == freezed
          ? _value.deg
          : deg // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
abstract class _$WindCopyWith<$Res> implements $WindCopyWith<$Res> {
  factory _$WindCopyWith(_Wind value, $Res Function(_Wind) then) =
      __$WindCopyWithImpl<$Res>;
  @override
  $Res call({double? speed, int? deg});
}

/// @nodoc
class __$WindCopyWithImpl<$Res> extends _$WindCopyWithImpl<$Res>
    implements _$WindCopyWith<$Res> {
  __$WindCopyWithImpl(_Wind _value, $Res Function(_Wind) _then)
      : super(_value, (v) => _then(v as _Wind));

  @override
  _Wind get _value => super._value as _Wind;

  @override
  $Res call({
    Object? speed = freezed,
    Object? deg = freezed,
  }) {
    return _then(_Wind(
      speed: speed == freezed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double?,
      deg: deg == freezed
          ? _value.deg
          : deg // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Wind implements _Wind {
  const _$_Wind({this.speed, this.deg});

  factory _$_Wind.fromJson(Map<String, dynamic> json) => _$$_WindFromJson(json);

  @override
  final double? speed;
  @override
  final int? deg;

  @override
  String toString() {
    return 'Wind(speed: $speed, deg: $deg)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Wind &&
            const DeepCollectionEquality().equals(other.speed, speed) &&
            const DeepCollectionEquality().equals(other.deg, deg));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(speed),
      const DeepCollectionEquality().hash(deg));

  @JsonKey(ignore: true)
  @override
  _$WindCopyWith<_Wind> get copyWith =>
      __$WindCopyWithImpl<_Wind>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_WindToJson(this);
  }
}

abstract class _Wind implements Wind {
  const factory _Wind({double? speed, int? deg}) = _$_Wind;

  factory _Wind.fromJson(Map<String, dynamic> json) = _$_Wind.fromJson;

  @override
  double? get speed;
  @override
  int? get deg;
  @override
  @JsonKey(ignore: true)
  _$WindCopyWith<_Wind> get copyWith => throw _privateConstructorUsedError;
}
