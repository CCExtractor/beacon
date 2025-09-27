import 'dart:convert';
import 'package:beacon/config/enviornment_config.dart';
import 'package:beacon/data/models/landmark/location_suggestion.dart';
import 'package:http/http.dart' as http;

class GeoapifyService {
  static String _apiKey = EnvironmentConfig.geoApifyApiKey!;

  static const String _baseUrl =
      'https://api.geoapify.com/v1/geocode/autocomplete';

  Future<List<LocationSuggestion>> getLocationSuggestions(String query) async {
    if (query.isEmpty) {
      return [];
    }

    final url = Uri.parse(
        "$_baseUrl?text=${Uri.encodeComponent(query)}&format=json&type=city&apiKey=$_apiKey");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List results = data['results'] ?? [];

        return results.map<LocationSuggestion>((item) {
          return LocationSuggestion.fromJson(item);
        }).toList();
      } else {
        throw Exception(
            "Failed to fetch location suggestions: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to fetch location suggestions: $e");
    }
  }
}
