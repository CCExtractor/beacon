import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'user_info.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  User(
      {this.authToken,
      this.email,
      this.name,
      // this.location,
      // this.beacon,
      @required this.id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      // location: json['location'] as String,
      // beacon: (json['beacon'] as List<dynamic>).toList(),
    );
  }

  @HiveField(0)
  String id;
  @HiveField(1)
  String authToken;
  @HiveField(2)
  String name;
  @HiveField(3)
  String email;
  // @HiveField(4)
  // String location;
  // @HiveField(5)
  // List<String> beacon = [];

  print() {
    debugPrint('authToken: ${this.authToken}');
    debugPrint('_id: ${this.id}');
    debugPrint('firstName: ${this.name}');
    debugPrint('email: ${this.email}');
    // debugPrint('joinedOrganizations: ${this.location}');
    // debugPrint('adminFor: ${this.beacon}');
  }

  // updateBeacon(List<String> beaconList) {
  //   this.beacon = beaconList;
  // }

  update(User details) {
    this.authToken = details.authToken;
    this.name = details.name;
    this.email = details.email;
    // this.location = details.location;
    // this.beacon = details.beacon;
  }
}
