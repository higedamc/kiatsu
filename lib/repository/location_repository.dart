import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

abstract class LocationRepository {
  Future<Position> getCoordinates();
  Future<Placemark> getLocationName(double longitude, double latitude);
}

class LocationRepositoryImpl implements LocationRepository {
  @override
  Future<Position> getCoordinates() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      forceAndroidLocationManager: true,
    );
    return position;
  }

  @override
  Future<Placemark> getLocationName(double latitude, double longitude) async {
    final placemarks = await placemarkFromCoordinates(latitude, longitude);
    final place = placemarks[0];
    return place;
  }
}
