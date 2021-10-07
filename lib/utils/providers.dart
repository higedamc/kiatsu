import 'package:kiatsu/model/weather_model.dart';
import 'package:kiatsu/utils/refresher.dart';
import 'package:kiatsu/utils/weather_request.dart';
import 'package:riverpod/riverpod.dart';

final weatherStateFuture = FutureProvider<WeatherClass>((ref) async {
  return FetchWeatherClass.fetchWeather();
});

final refresherProvider = StateNotifierProvider((_) => Refresher());