// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GroupModelAdapter extends TypeAdapter<GroupModel> {
  @override
  final int typeId = 30;

  @override
  GroupModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroupModel(
      id: fields[0] as String?,
      title: fields[1] as String?,
      leader: fields[2] as UserModel?,
      members: (fields[3] as List?)?.cast<UserModel?>(),
      shortcode: fields[4] as String?,
      beacons: (fields[5] as List?)?.cast<BeaconModel?>(),
    );
  }

  @override
  void write(BinaryWriter writer, GroupModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.leader)
      ..writeByte(3)
      ..write(obj.members)
      ..writeByte(4)
      ..write(obj.shortcode)
      ..writeByte(5)
      ..write(obj.beacons);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
