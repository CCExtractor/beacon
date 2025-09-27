class LocationSuggestion {
  final String name;
  final double latitude;
  final double longitude;
  final String fullAddress;

  LocationSuggestion({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.fullAddress,
  });

  factory LocationSuggestion.fromJson(Map<String, dynamic> json) {
    return LocationSuggestion(
      name: json['formatted'] ?? json['address_line1'] ?? 'Unknown Location',
      latitude: (json['lat'] ?? 0.0).toDouble(),
      longitude: (json['lon'] ?? 0.0).toDouble(),
      fullAddress: json['formatted'] ?? 'Unknown Address',
    );
  }

  @override
  String toString() {
    return 'LocationSuggestion(name: $name, lat: $latitude, lon: $longitude)';
  }
}
