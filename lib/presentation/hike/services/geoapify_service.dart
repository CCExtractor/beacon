import 'dart:convert';
import 'package:beacon/data/models/landmark/location_suggestion.dart';
import 'package:http/http.dart' as http;

class GeoapifyService {
  static const String _apiKey = '9ee96579425c4945ab53a5134d533b2c';
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
      print("Fetching location suggestions for query: $query");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Response received with ${data['results']?.length ?? 0} results");

        List results = data['results'] ?? [];

        return results.map<LocationSuggestion>((item) {
          return LocationSuggestion.fromJson(item);
        }).toList();
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        throw Exception(
            "Failed to fetch location suggestions: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred: $e");
      throw Exception("Failed to fetch location suggestions: $e");
    }
  }
}
