import 'dart:convert';
import 'package:http/http.dart' as http;

class GeoapifyService {
  static const String _apiKey = '1e810532f9934cd3a0d964b4caabd5d0';
  static const String _baseUrl =
      'https://api.geoapify.com/v1/geocode/autocomplete';

  Future<List<String>> getLocationSuggestions(String query) async {
    final url = Uri.parse("$_baseUrl?text=$query&limit=5&apiKey=$_apiKey");

    if (query.isEmpty) {
      return [];
    }

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List suggestions = data['features'];

      return suggestions
          .map<String>((item) => item['properties']['formatted'] as String)
          .toList();
    } else {
      throw Exception("Failed to fetch location suggestions");
    }
  }
}
