import 'dart:io';

import 'package:flutter_config/flutter_config.dart';

class EnvironmentConfig {
  static String get httpEndpoint => FlutterConfig.get('HTTP_ENDPOINT');

  static String get websocketEndpoint =>
      FlutterConfig.get('WEBSOCKET_ENDPOINT');

  static String get googleMapApi {
    if (Platform.isAndroid) {
      return FlutterConfig.get('ANDROID_MAP_API_KEY');
    }
    return FlutterConfig.get('IOS_MAP_API_KEY');
  }

  static Future<void> loadEnvVariables() async {
    await FlutterConfig.loadEnvVariables();
  }
}
