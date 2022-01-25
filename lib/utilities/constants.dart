import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

const Color kYellow = Color(0xFFFDBB2C);
const Color kBlue = Color(0xFF222375);
const Color lightkBlue = Color(0xFF535393);
const Color kLightBlue = Color(0xFFE8F1F8);
const Color kBlack = Color(0xFF343434);
const Color shimmerSkeletonColor = Color(0xff4e4f91);
const Color hintColor = Colors.black54; // Hint Text Color
const double CAMERA_ZOOM = 15;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;

// Button Sizings
final double labelsize = 20;
final double hintsize = 18;
final double homebheight = 4.45.h;
final double homebwidth = 3.w;
final double optbheight = 3.h;
final double optbwidth = 6.w;

// GraphQL Registering Errors
const String exceptionError = "Exception Errors";
const String otherError = "Other Errors";
const String logSuccess = "Successful Login";

class AppConstants {
  static Future<LatLng> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
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

class Style {
  static final boldHeadingStyle = TextStyle(
      fontSize: 28.0,
      color: Colors.black,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.0);
  static final headingStyle = TextStyle(
      fontSize: 28.0,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.0);
  static final baseTextStyle = const TextStyle(fontFamily: 'Poppins');
  static final smallTextStyle = commonTextStyle.copyWith(
    fontSize: 9.0,
  );
  static final commonTextStyle = baseTextStyle.copyWith(
      color: const Color(0xffb6b2df),
      fontSize: 14.0,
      fontWeight: FontWeight.w400);
  static final titleTextStyle = baseTextStyle.copyWith(
      color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600);
  static final headerTextStyle = baseTextStyle.copyWith(
      color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w400);
}
