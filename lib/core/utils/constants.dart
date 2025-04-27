import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
const double labelsize = 24;
const double hintsize = 16;
final double homebheight = 4.5.h;
final double homebwidth = 3.5.w;
const double optbheight = 18.0;
const double optbwidth = 30.0;

// GraphQL Registering Errors
const String exceptionError = "Exception Errors";
const String otherError = "Other Errors";
const String logSuccess = "Successful Login";

class AppConstants {
  static const _imagePath = 'images';
  static const filterIconPath = '$_imagePath/filter_icon.png';
}

//routes

class Routes {
  static const String demoPageViewRoute = "/demoPageViewRoute";
  static const String splashScreen = "/";
  static const String authScreen = "/auth";
  static const String mainScreen = "/main";
  static const String hikeScreen = "/hikeScreen";
  static const String groupScreen = "/groupScreen";
}

class Style {
  static const double padding = 20;
  static const double avatarRadius = 15;

  static Color textGray = const Color(0xffC8BDBB);
  static Color bgWhite = const Color(0xffFEFEFE);
  static Color primaryColor = const Color(0xff48201A);
  static Color secondaryColor = const Color(0xffFEF3EC);
  static Color neutralColor = HexColor.fromHex("111315");

  static Color gray100 = HexColor.fromHex("828282");
  static Color gray200 = HexColor.fromHex("EEEFF1");

  static Color primary = HexColor.fromHex("25283D");

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

  static TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static TextStyle subHeading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: primaryColor,
  );
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('ff');
    }
    buffer.write(hexString.replaceAll('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
