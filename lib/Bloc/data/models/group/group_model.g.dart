// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupModel _$GroupModelFromJson(Map<String, dynamic> json) => GroupModel(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      leader: json['leader'] == null
          ? null
          : UserModel.fromJson(json['leader'] as Map<String, dynamic>),
      members: (json['members'] as List<dynamic>?)
          ?.map((e) =>
              e == null ? null : UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      shortcode: json['shortcode'] as String?,
      beacons: (json['beacons'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : BeaconModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GroupModelToJson(GroupModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'leader': instance.leader,
      'members': instance.members,
      'shortcode': instance.shortcode,
      'beacons': instance.beacons,
    };
