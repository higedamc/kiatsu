import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kiatsu/model/weather_model.dart';

part 'api_state.freezed.dart';

@freezed
abstract class WeatherClassState with _$WeatherClassState {
  const factory WeatherClassState.initial() = _WeatherInitial;
  const factory WeatherClassState.loading() = _WeatherLoading;
  const factory WeatherClassState.success(WeatherClass weatherClass) =
      _WeatherLoadedSuccess;
  const factory WeatherClassState.error([String? message]) = _WeatherLoadedError;
}

@freezed
abstract class LocationState with _$LocationState {
  const factory LocationState.initial() = _LocationInitial;
  const factory LocationState.loading() = _LocationLoading;
  const factory LocationState.success(String address) = _LocationSuccess;
  const factory LocationState.error([String? message]) =
      _LocationLoadedError;
}
