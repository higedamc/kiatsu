import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiatsu/api/api_state.dart';
import 'package:kiatsu/repository/weather_repository.dart';

class WeatherStateNotifer extends StateNotifier<WeatherClassState> {
  WeatherStateNotifer(this.weatherRepository)
      : super(const WeatherClassState.initial());
  final WeatherRepository weatherRepository;

  Future<void> getWeather(
    String cityName,
    WidgetRef ref,
  ) async {
    try {
      state = const WeatherClassState.loading();
      final data = await weatherRepository.getWeather(cityName, ref);
      state = WeatherClassState.success(data);
    } on PlatformException catch (e) {
      state = WeatherClassState.error('$e');
    }
  }
}
