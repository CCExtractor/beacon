import 'package:beacon/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:beacon/views/auth_screen.dart';
import 'package:beacon/views/home.dart';
import 'package:beacon/views/hike_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.authScreen:
      return MaterialPageRoute(
          builder: (context) => const AuthScreen(key: Key('auth')));
    case Routes.mainScreen:
      return MaterialPageRoute(
          builder: (context) => const MainScreen(key: Key('MainScreen')));
    case Routes.hikeScreen:
      HikeScreen arguments = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => HikeScreen(
                arguments.beacon,
                isLeader: arguments.isLeader,
              ));
    default:
      return MaterialPageRoute(
          builder: (context) => const SplashScreen(key: Key('SplashScreen')));
  }
}
