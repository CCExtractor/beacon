import 'package:flutter/material.dart';

class CustomTheme {
  static const String _fontFamily =
      'FuturaBold'; // Match the name in pubspec.yaml

  // Define your custom colors
  Color kYellow = Color(0xFFFDBB2C);
  Color kBlue = Color(0xFF222375);
  Color lightkBlue = Color(0xFF535393);
  Color kLightBlue = Color(0xFFE8F1F8);
  Color kBlack = Color(0xFF343434);
  Color shimmerSkeletonColor = Color(0xff4e4f91);
  Color hintColor = Colors.black54;

  // Define your custom theme data
  ThemeData myTheme = ThemeData(
    fontFamily: _fontFamily,
    // Define primary colors
    primaryColor: const Color(0xFF222375),
    hintColor: const Color.fromARGB(255, 105, 103, 103),

    // Define text themes
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.bold,
        fontFamily: _fontFamily,
        color: Colors.white,
      ),
      displayMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        fontFamily: _fontFamily,
        color: Colors.black,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontFamily: _fontFamily,
        color: Colors.white,
      ),
    ),

    // Define other theme properties such as fonts, buttons, etc.
  );
}
