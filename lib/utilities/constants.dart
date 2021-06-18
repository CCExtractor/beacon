import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

const Color kYellow = Color(0xFFFDBB2C);
const Color kBlue = Color(0xFF222375);
const Color kLightBlue = Color(0xFFE8F1F8);
const Color kBlack = Color(0xFF343434);

class AppConstants {
  static double lat = 0.0;
  static double long = 0.0;

  static Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    AppConstants.long = position.longitude;
    AppConstants.lat = position.latitude;
  }
}
