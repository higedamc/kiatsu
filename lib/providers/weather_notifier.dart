

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiatsu/repository/weather_repository.dart';
import 'package:kiatsu/api/api_state.dart';

class WeatherStateNotifer extends StateNotifier<WeatherClassState> {
  final WeatherRepository weatherRepository;
  WeatherStateNotifer(this.weatherRepository)
      : super(const WeatherClassState.initial());

  Future<void> getWeather(String cityName) async {
    try {
      state = const WeatherClassState.loading();
      var data = await weatherRepository.getWeather(cityName);
      state = WeatherClassState.success(data);
    } catch (e) {
      state = WeatherClassState.error('$e');
    }
  }
}