import 'dart:ffi';

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
      this.route});

  factory Beacon.fromJson(Map<String, dynamic> json) {
    return Beacon(
      id: json['_id'] as String,
      shortcode: json['shortcode'] as String,
      title: json['title'] as String,
      startsAt: json['startsAt'] as DateTime,
      expiresAt: json['expiresAt'] as DateTime,
      leader: User.fromJson(json['leader'] as Map<String, dynamic>),
      followers: (json['followers'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      route: (json['route'] as List<dynamic>)
          .map((e) => Location.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @HiveField(0)
  String id;
  @HiveField(1)
  String shortcode;
  @HiveField(2)
  DateTime startsAt;
  @HiveField(3)
  DateTime expiresAt;
  @HiveField(4)
  User leader;
  @HiveField(5)
  List<User> followers = [];
  @HiveField(6)
  List<Location> route = [];
  @HiveField(7)
  String title;

  print() {
    debugPrint('shortCode: ${this.shortcode}');
    debugPrint('_id: ${this.id}');
    debugPrint('startsAt: ${this.startsAt}');
    debugPrint('expiresAt: ${this.expiresAt}');
  }
}
