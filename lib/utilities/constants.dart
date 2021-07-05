import 'package:beacon/models/location/location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const Color kYellow = Color(0xFFFDBB2C);
const Color kBlue = Color(0xFF222375);
const Color kLightBlue = Color(0xFFE8F1F8);
const Color kBlack = Color(0xFF343434);

class AppConstants {
  static Future<LatLng> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return LatLng(position.latitude, position.longitude);
  }
}

//routes

class Routes {
  static const String demoPageViewRoute = "/demoPageViewRoute";
  static const String splashScreen = "/";
  static const String authScreen = "/auth";
  static const String mainScreen = "/main";
  static const String hikeScreen = "/hikeScreen";
}
