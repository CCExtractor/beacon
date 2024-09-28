// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updated_group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdatedGroupModel _$UpdatedGroupModelFromJson(Map<String, dynamic> json) =>
    UpdatedGroupModel(
      id: json['groupId'] as String?,
      newUser: json['newUser'] == null
          ? null
          : UserModel.fromJson(json['newUser'] as Map<String, dynamic>),
      newBeacon: json['newBeacon'] == null
          ? null
          : BeaconModel.fromJson(json['newBeacon'] as Map<String, dynamic>),
      updatedBeacon: json['updatedBeacon'] == null
          ? null
          : BeaconModel.fromJson(json['updatedBeacon'] as Map<String, dynamic>),
      deletedBeacon: json['deletedBeacon'] == null
          ? null
          : BeaconModel.fromJson(json['deletedBeacon'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdatedGroupModelToJson(UpdatedGroupModel instance) =>
    <String, dynamic>{
      'groupId': instance.id,
      'newUser': instance.newUser,
      'newBeacon': instance.newBeacon,
      'updatedBeacon': instance.updatedBeacon,
      'deletedBeacon': instance.deletedBeacon,
    };
