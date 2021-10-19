import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kiatsu/api/api_state.dart';
import 'package:kiatsu/repository/locator_repository.dart';

class LocationStateNotifer extends StateNotifier<LocationState> {
  final LocationRepository locationRepository;
  LocationStateNotifer(this.locationRepository)
      : super(const LocationState.initial());

  Future<void> getMyLocation() async {
    try {
      state = LocationState.initial();
      Position data = await locationRepository.getCoordinates();
      Placemark place = await locationRepository.getLocationName(
          data.latitude, data.longitude);
      String address = "${place.locality}, ${place.country}";
      state = LocationState.success(address);
    } catch (e) {
      state = LocationState.error("$e");
    }
  }
}