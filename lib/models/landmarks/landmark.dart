import 'package:beacon/models/location/location.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'landmark.g.dart';

@HiveType(typeId: 4)
class Landmark extends HiveObject {
  Landmark({this.title, this.location});

  factory Landmark.fromJson(Map<String, dynamic> json) {
    return Landmark(
      title: json['title'] != null ? json['title'] as String : null,
      location: json['location'] != null
          ? Location.fromJson(json['location'] as Map<String, dynamic>)
          : null,
    );
  }

  @HiveField(0)
  String title;
  @HiveField(1)
  Location location;

  print() {
    debugPrint('title: ${this.title}');
  }
}
