import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();

  LocationService._internal();

  factory LocationService() {
    return _instance;
  }

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  Future<Position?> getCurrentLocation() async {
    // ignore: unused_local_variable
    bool serviceEnabled;
    // ignore: unused_local_variable
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location service is disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission is denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission is permanently denied.');
    }

    try {
      Position location = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      _currentPosition = location;

      return location;
    } catch (e) {
      return Future.error('Failed to get location: $e');
    }
  }

  Future<void> openSettings() async {
    await Geolocator.openAppSettings();
  }

  Future<double> calculateDistance(LatLng first, LatLng second) async {
    double distanceInMeters = await Geolocator.distanceBetween(
      first.latitude,
      first.longitude,
      second.latitude,
      second.longitude,
    );

    return distanceInMeters;
  }
}
