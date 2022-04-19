import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiatsu/api/api_state.dart';
import 'package:kiatsu/repository/location_repository.dart';

class LocationStateNotifer extends StateNotifier<LocationState> {
    LocationStateNotifer(this.locationRepository)
      : super(const LocationState.initial());
  final LocationRepository locationRepository;


  Future<void> getMyLocation() async {
    try {
      state = const LocationState.initial();
      final data = await locationRepository.getCoordinates();
      final place = await locationRepository.getLocationName(
          data.latitude, data.longitude);
      final address = '${place.locality}, ${place.country}';
      state = LocationState.success(address);
    } catch (e) {
      state = LocationState.error('$e');
    }
  }
}