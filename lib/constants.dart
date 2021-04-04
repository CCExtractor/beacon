import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class AppConstants {
  static double lat = 0.0;
  static double long = 0.0;

  static Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    AppConstants.long = position.longitude;
    AppConstants.lat = position.latitude;
  }

  static Color background = Color(0xff161427);
  static Color foreground = Color(0xff6bd2ab);
  static Color field = Color(0xff2a2549);
}
