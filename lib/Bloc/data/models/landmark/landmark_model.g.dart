// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'landmark_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LandMarkModel _$LandMarkModelFromJson(Map<String, dynamic> json) =>
    LandMarkModel(
      title: json['title'] as String?,
      location: json['location'] == null
          ? null
          : LocationModel.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LandMarkModelToJson(LandMarkModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'location': instance.location,
    };
