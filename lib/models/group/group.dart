import 'package:beacon/models/user/user_info.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../beacon/beacon.dart';

part 'group.g.dart';

@HiveType(typeId: 5)
class Group extends HiveObject {
  Group({
    this.id,
    this.shortcode,
    this.title,
    this.leader,
    this.members,
    this.beacons,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['_id'] as String,
      title: json['title'] != null ? json['title'] as String : null,
      shortcode: json['shortcode'] as String,
      leader: json['leader'] != null
          ? User.fromJson(json['leader'] as Map<String, dynamic>)
          : null,
      members: json['members'] != null
          ? (json['members'] as List<dynamic>)
              .map((e) => User.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      beacons: json['beacons'] != null
          ? (json['beacons'] as List<dynamic>)
              .map((e) => Beacon.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String shortcode;
  @HiveField(3)
  User leader;
  @HiveField(4)
  List<User> members = [];
  @HiveField(5)
  List<Beacon> beacons = [];

  print() {
    debugPrint('shortCode: ${this.shortcode}');
    debugPrint('_id: ${this.id}');
    debugPrint('groupLeader: ${this.leader}');
  }
}
