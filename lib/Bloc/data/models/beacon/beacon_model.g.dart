// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beacon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BeaconModel _$BeaconModelFromJson(Map<String, dynamic> json) => BeaconModel(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      leader: json['leader'] == null
          ? null
          : UserModel.fromJson(json['leader'] as Map<String, dynamic>),
      group: json['group'] == null
          ? null
          : GroupModel.fromJson(json['group'] as Map<String, dynamic>),
      shortcode: json['shortcode'] as String?,
      followers: (json['followers'] as List<dynamic>?)
          ?.map((e) =>
              e == null ? null : UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      landmarks: (json['landmarks'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : LandMarkModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      location: json['location'] == null
          ? null
          : LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      route: (json['route'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : LocationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      startsAt: json['startsAt'] as int?,
      expiresAt: json['expiresAt'] as int?,
    );

Map<String, dynamic> _$BeaconModelToJson(BeaconModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'leader': instance.leader,
      'group': instance.group,
      'shortcode': instance.shortcode,
      'followers': instance.followers,
      'landmarks': instance.landmarks,
      'location': instance.location,
      'route': instance.route,
      'startsAt': instance.startsAt,
      'expiresAt': instance.expiresAt,
    };
