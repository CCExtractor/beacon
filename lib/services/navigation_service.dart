import 'package:beacon/utilities/constants.dart';
import 'package:flutter/material.dart';

class NavigationService {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> pushScreen(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementScreen(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  void fromInviteLink(List<String> routeNames, List<dynamic> arguments) {
    int i = 0;
    removeAllAndPush('/${routeNames[i]}', '/', arguments: arguments[i]);
    for (i = 1; i < routeNames.length; i++) {
      pushScreen('/${routeNames[i]}', arguments: arguments[i]);
    }
  }

  Future<dynamic> removeAllAndPush(String routeName, String tillRoute,
      {dynamic arguments}) {
    return navigatorKey.currentState.pushNamedAndRemoveUntil(
        routeName, ModalRoute.withName(tillRoute),
        arguments: arguments);
  }

  void pushDialog(Widget dialog) {
    showDialog(
        context: navigatorKey.currentContext,
        barrierColor: Colors.transparent,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  void showSnackBar(String message,
      {Duration duration = const Duration(seconds: 2)}) {
    ScaffoldMessenger.of(navigatorKey.currentContext).showSnackBar(
      SnackBar(
        duration: duration,
        content: Text(
          message,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: kLightBlue.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 5,
      ),
    );
  }

  void pop() {
    return navigatorKey.currentState.pop();
  }
}
