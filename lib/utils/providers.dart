import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kiatsu/api/api_state.dart';
import 'package:kiatsu/providers/location_notifier.dart';
import 'package:kiatsu/providers/revenuecat.dart';
import 'package:kiatsu/providers/weather_notifier.dart';
import 'package:kiatsu/repository/locator_repository.dart';
import 'package:kiatsu/repository/weather_repository.dart';
import 'package:http/http.dart' as http;

final revenuecatProvider = ChangeNotifierProvider((_) => RevenueCatProvider());

final weatherClientProvider = Provider.autoDispose<WeatherRepository>(
    (ref) => WeatherRepositoryImpl(http.Client()));

final locationClientProvider =
    Provider.autoDispose<LocationRepository>((ref) => LocationRepositoryImpl());

// 依存ソース
final weatherStateNotifierProvider =
    StateNotifierProvider.autoDispose<WeatherStateNotifer, WeatherClassState>(
        (ref) => WeatherStateNotifer(ref.watch(weatherClientProvider)));

final locationStateNotifierProvider =
    StateNotifierProvider.autoDispose<LocationStateNotifer, LocationState>(
        (ref) => LocationStateNotifer(ref.watch(locationClientProvider)));

//backup use for textEditingController
final cityNameProvider = StateProvider.autoDispose<String>((ref) => '');