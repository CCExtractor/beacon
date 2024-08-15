// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beacon_locations_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BeaconLocationsModel _$BeaconLocationsModelFromJson(
        Map<String, dynamic> json) =>
    BeaconLocationsModel(
      userSOS: json['userSOS'] == null
          ? null
          : UserModel.fromJson(json['userSOS'] as Map<String, dynamic>),
      route: (json['route'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : LocationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      landmark: json['landmark'] == null
          ? null
          : LandMarkModel.fromJson(json['landmark'] as Map<String, dynamic>),
      user: json['updatedUser'] == null
          ? null
          : UserModel.fromJson(json['updatedUser'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BeaconLocationsModelToJson(
        BeaconLocationsModel instance) =>
    <String, dynamic>{
      'userSOS': instance.userSOS,
      'route': instance.route,
      'landmark': instance.landmark,
      'updatedUser': instance.user,
    };
