// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geofence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeofenceModel _$GeofenceModelFromJson(Map<String, dynamic> json) =>
    GeofenceModel(
      center: json['center'] == null
          ? null
          : LocationModel.fromJson(json['center'] as Map<String, dynamic>),
      radius: (json['radius'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$GeofenceModelToJson(GeofenceModel instance) =>
    <String, dynamic>{
      'radius': instance.radius,
      'center': instance.center,
    };
