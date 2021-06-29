import 'package:beacon/models/location/location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

const Color kYellow = Color(0xFFFDBB2C);
const Color kBlue = Color(0xFF222375);
const Color kLightBlue = Color(0xFFE8F1F8);
const Color kBlack = Color(0xFF343434);

class AppConstants {
  static Future<Location> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return Location(
        lat: position.latitude.toString(), lon: position.longitude.toString());
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
