// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beacon.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BeaconAdapter extends TypeAdapter<Beacon> {
  @override
  final int typeId = 3;

  @override
  Beacon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Beacon(
      id: fields[0] as String,
      shortcode: fields[1] as String,
      startsAt: fields[2] as int,
      expiresAt: fields[3] as int,
      title: fields[7] as String,
      leader: fields[4] as User,
      followers: (fields[5] as List)?.cast<User>(),
      route: (fields[6] as List)?.cast<Location>(),
      landmarks: (fields[8] as List)?.cast<Landmark>(),
      location: fields[9] as Location,
      group: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Beacon obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.shortcode)
      ..writeByte(2)
      ..write(obj.startsAt)
      ..writeByte(3)
      ..write(obj.expiresAt)
      ..writeByte(4)
      ..write(obj.leader)
      ..writeByte(5)
      ..write(obj.followers)
      ..writeByte(6)
      ..write(obj.route)
      ..writeByte(7)
      ..write(obj.title)
      ..writeByte(8)
      ..write(obj.landmarks)
      ..writeByte(9)
      ..write(obj.location)
      ..writeByte(10)
      ..write(obj.group);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BeaconAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
