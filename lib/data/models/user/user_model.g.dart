// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 10;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      authToken: fields[3] as String?,
      beacons: (fields[6] as List?)?.cast<BeaconModel?>(),
      email: fields[2] as String?,
      groups: (fields[5] as List?)?.cast<GroupModel?>(),
      id: fields[0] as String?,
      isGuest: fields[4] as bool?,
      location: fields[7] as LocationModel?,
      name: fields[1] as String?,
      isVerified: fields[8] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.authToken)
      ..writeByte(4)
      ..write(obj.isGuest)
      ..writeByte(5)
      ..write(obj.groups)
      ..writeByte(6)
      ..write(obj.beacons)
      ..writeByte(7)
      ..write(obj.location)
      ..writeByte(8)
      ..write(obj.isVerified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
      isVerified: json['isVerified'] as bool?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'authToken': instance.authToken,
      'isGuest': instance.isGuest,
      'groups': instance.groups,
      'beacons': instance.beacons,
      'location': instance.location,
      'isVerified': instance.isVerified,
    };
