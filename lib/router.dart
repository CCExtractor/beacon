import 'package:beacon/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:beacon/main.dart';
import 'package:beacon/views/auth_screen.dart';
import 'package:beacon/views/home.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.splashScreen:
      return MaterialPageRoute(
          builder: (context) => const SplashScreen(key: Key('SplashScreen')));
    case Routes.authScreen:
      return MaterialPageRoute(
          builder: (context) => const AuthScreen(key: Key('auth')));
    case Routes.mainScreen:
      return MaterialPageRoute(
          builder: (context) => const MainScreen(key: Key('MainScreen')));
    default:
      return MaterialPageRoute(
          builder: (context) => const DemoPageView(
                key: Key("DemoPage"),
              ));
  }
}
