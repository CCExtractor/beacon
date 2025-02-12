import 'dart:developer';
import 'package:beacon/core/utils/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graphql/client.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Utils {
  void showSnackBar(String message, BuildContext context,
      {Duration duration = const Duration(seconds: 2),
      bool icon = false,
      bool top = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        content: Row(
          children: [
            icon
                ? Image.asset(
                    'images/male_avatar.png',
                    height: 35,
                  )
                : Container(),
            icon ? Gap(20) : Container(),
            Text(
              message,
              style: TextStyle(color: Colors.black, fontSize: 12),
            )
          ],
        ),
        backgroundColor: kLightBlue.withValues(alpha: 0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        margin: top
            ? EdgeInsets.only(top: 0, right: 10, left: 10, bottom: 85.h)
            : null,
        behavior: SnackBarBehavior.floating,
        elevation: 5,
      ),
    );
  }

  String filterException(OperationException exception) {
    // checking grapqhl exceptions
    if (exception.graphqlErrors.isNotEmpty) {
      return exception.graphqlErrors.first.message;
    }
    // checking link exception
    else if (exception.linkException != null) {
      log('Link Exception: ${exception.linkException!.originalStackTrace}');
      return 'Server exception';
    } else {
      return 'Network Error: The request could not be completed.';
    }
  }

  Future<bool> checkInternetConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.ethernet) {
      return true;
    }
    return false;
  }
}
