// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beacon_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BeaconModelAdapter extends TypeAdapter<BeaconModel> {
  @override
  final int typeId = 20;

  @override
  BeaconModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BeaconModel(
      id: fields[0] as String?,
      title: fields[1] as String?,
      leader: fields[2] as UserModel?,
      group: fields[3] as GroupModel?,
      shortcode: fields[4] as String?,
      followers: (fields[5] as List?)?.cast<UserModel?>(),
      landmarks: (fields[6] as List?)?.cast<LandMarkModel?>(),
      location: fields[7] as LocationModel?,
      route: (fields[8] as List?)?.cast<LocationModel?>(),
      startsAt: fields[9] as int?,
      expiresAt: fields[10] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, BeaconModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.leader)
      ..writeByte(3)
      ..write(obj.group)
      ..writeByte(4)
      ..write(obj.shortcode)
      ..writeByte(5)
      ..write(obj.followers)
      ..writeByte(6)
      ..write(obj.landmarks)
      ..writeByte(7)
      ..write(obj.location)
      ..writeByte(8)
      ..write(obj.route)
      ..writeByte(9)
      ..write(obj.startsAt)
      ..writeByte(10)
      ..write(obj.expiresAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BeaconModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
      startsAt: (json['startsAt'] as num?)?.toInt(),
      expiresAt: (json['expiresAt'] as num?)?.toInt(),
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
