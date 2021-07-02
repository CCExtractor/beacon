import 'dart:ffi';

import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/models/location/location.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'user_info.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  User(
      {this.authToken,
      this.email,
      this.name,
      this.location,
      this.beacon,
      @required this.id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['_id'] as String,
        name: json['name'] != null ? json['name'] as String : 'Anonymous',
        email: json['email'] != null ? json['email'] as String : '',
        location: json['location'] != null
            ? (json['location'] as List<dynamic>)
                .map((e) => Location.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
        beacon: json['beacons'] != null
            ? (json['beacons'] as List<dynamic>)
                .map((e) => Beacon.fromJson(e as Map<String, dynamic>))
                .toList()
            : []);
  }

  @HiveField(0)
  String id;
  @HiveField(1)
  String authToken;
  @HiveField(2)
  String name;
  @HiveField(3)
  String email;
  @HiveField(4)
  List<Beacon> beacon = [];
  @HiveField(5)
  List<Location> location = [];

  print() {
    debugPrint('authToken: ${this.authToken}');
    debugPrint('_id: ${this.id}');
    debugPrint('firstName: ${this.name}');
    debugPrint('email: ${this.email}');
    debugPrint('location: ${this.location}');
    debugPrint('beacons: ${this.beacon}');
  }

  // updateBeacon(List<String> beaconList) {
  //   this.beacon = beaconList;
  // }

  update(User details) {
    this.authToken = details.authToken;
    this.name = details.name;
    this.email = details.email;
    this.location = details.location;
    this.beacon = details.beacon;
  }
}
