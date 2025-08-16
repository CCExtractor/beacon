import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentConfig {
  static String? get httpEndpoint => dotenv.env['HTTP_ENDPOINT'];

  static String? get websocketEndpoint => dotenv.env['WEBSOCKET_ENDPOINT'];

  static String? get googleMapApi {
    if (Platform.isAndroid) {
      return dotenv.env['ANDROID_MAP_API_KEY'];
    }
    return dotenv.env['IOS_MAP_API_KEY'];
  }

  static String? get geoApifyApiKey => dotenv.env['GEOAPIFY_API_KEY'];

  static String? get openWeatherMapApiKey =>
      dotenv.env['OPEN_WEATHER_MAP_API_KEY'];

  static Future<void> loadEnvVariables() async {
    await dotenv.load(fileName: '.env');
  }
}
