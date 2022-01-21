import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'location.g.dart';

@HiveType(typeId: 2)
class Location extends HiveObject {
  Location({this.lat, this.lon});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat'] != null ? json['lat'] as String : null,
      lon: json['lon'] != null ? json['lon'] as String : null,
    );
  }

  @HiveField(0)
  String lat;
  @HiveField(1)
  String lon;

  print() {
    debugPrint('lat: ${this.lat}');
    debugPrint('long: ${this.lon}');
  }
}
