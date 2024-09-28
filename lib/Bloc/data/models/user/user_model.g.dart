// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      authToken: json['authToken'] as String?,
      beacons: (json['beacons'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : BeaconModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      email: json['email'] as String?,
      groups: (json['groups'] as List<dynamic>?)
          ?.map((e) =>
              e == null ? null : GroupModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['_id'] as String?,
      isGuest: json['isGuest'] as bool?,
      location: json['location'] == null
          ? null
          : LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'authToken': instance.authToken,
      'email': instance.email,
      'isGuest': instance.isGuest,
      'groups': instance.groups,
      'beacons': instance.beacons,
      'location': instance.location,
    };
