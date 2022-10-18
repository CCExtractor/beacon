import 'package:beacon/models/landmarks/landmark.dart';
import 'package:beacon/models/location/location.dart';
import 'package:beacon/models/user/user_info.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'beacon.g.dart';

@HiveType(typeId: 3)
class Beacon extends HiveObject {
  Beacon(
      {this.id,
      this.shortcode,
      this.startsAt,
      this.expiresAt,
      this.title,
      this.leader,
      this.followers,
      this.route,
      this.landmarks,
      this.location,
      this.group});

  factory Beacon.fromJson(Map<String, dynamic> json) {
    return Beacon(
      id: json['_id'] as String,
      shortcode: json['shortcode'] as String,
      title: json['title'] != null ? json['title'] as String : null,
      startsAt: json['startsAt'] as int,
      expiresAt: json['expiresAt'] as int,
      leader: json['leader'] != null
          ? User.fromJson(json['leader'] as Map<String, dynamic>)
          : null,
      location: json['location'] != null
          ? Location.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      followers: json['followers'] != null
          ? (json['followers'] as List<dynamic>)
              .map((e) => User.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      route: json['route'] != null
          ? (json['route'] as List<dynamic>)
              .map((e) => Location.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      landmarks: json['landmarks'] != null
          ? (json['landmarks'] as List<dynamic>)
              .map((e) => Landmark.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      // group: json['group'] != null
      //     ? Group.fromJson(json['group'] as Map<String, dynamic>)
      //     : null,
      group: json['group'] != null ? json['group']['_id'] : null,
    );
  }

  @HiveField(0)
  String id;
  @HiveField(1)
  String shortcode;
  @HiveField(2)
  int startsAt;
  @HiveField(3)
  int expiresAt;
  @HiveField(4)
  User leader;
  @HiveField(5)
  List<User> followers = [];
  @HiveField(6)
  List<Location> route = [];
  @HiveField(7)
  String title;
  @HiveField(8)
  List<Landmark> landmarks = [];
  @HiveField(9)
  Location location;
  @HiveField(10)
  String group;

  print() {
    debugPrint('shortCode: ${this.shortcode}');
    debugPrint('_id: ${this.id}');
    debugPrint('startsAt: ${this.startsAt}');
    debugPrint('expiresAt: ${this.expiresAt}');
  }
}
