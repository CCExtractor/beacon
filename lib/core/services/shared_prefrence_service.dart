import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static SharedPreferenceService _instance =
      SharedPreferenceService._internal();

  SharedPreferenceService._internal();

  factory SharedPreferenceService() {
    return _instance;
  }

  late SharedPreferences _prefs;

  init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveData(String key, dynamic value) async {
    try {
      if (value is String) {
        await _prefs.setString(key, value);
      } else if (value is int) {
        await _prefs.setInt(key, value);
      } else if (value is bool) {
        await _prefs.setBool(key, value);
      } else if (value is double) {
        await _prefs.setDouble(key, value);
      } else if (value is List<String>) {
        await _prefs.setStringList(key, value);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> loadData(String key) async {
    return _prefs.get(key);
  }

  Future deleteData(String key) async {
    return await _prefs.remove(key);
  }
}
