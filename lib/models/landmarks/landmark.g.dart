// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'landmark.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LandmarkAdapter extends TypeAdapter<Landmark> {
  @override
  final int typeId = 4;

  @override
  Landmark read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Landmark(
      title: fields[0] as String,
      location: fields[1] as Location,
    );
  }

  @override
  void write(BinaryWriter writer, Landmark obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.location);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LandmarkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
