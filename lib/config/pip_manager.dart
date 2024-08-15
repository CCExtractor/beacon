import 'package:flutter/services.dart';

class PIPMode {
  static const platform = MethodChannel("com.example.beacon/pip");

  // static Future<void> enterPIPMode() async {
  //   try {
  //     await platform.invokeMethod('enablePIPMode');
  //   } on PlatformException catch (e) {
  //     print("Failed to enter PIP mode: '${e.message}'.");
  //   }
  // }

  static Future<void> disablePIPMode() async {
    try {
      await platform.invokeMethod('disablePIPMode');
    } on PlatformException catch (e) {
      print("Failed to enter PIP mode: '${e.message}'.");
    }
  }

  static Future<void> switchPIPMode() async {
    try {
      await platform.invokeMethod('switchPIPMode');
    } on PlatformException catch (e) {
      print("Failed to enter PIP mode: '${e.message}'.");
    }
  }
}
