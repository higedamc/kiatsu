import 'package:kiatsu/model/weather_model.dart';
import 'package:kiatsu/utils/providers.dart';
import 'package:riverpod/riverpod.dart';

late final WeatherClass weather;
DateTime updatedAt = DateTime.now();

class Refresher extends StateNotifier {
  Refresher() : super([]);


  

  refresher() async {
    weather = weatherStateFuture as WeatherClass;
    updatedAt = new DateTime.now();
  }
}