// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'landmark_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LandMarkModelAdapter extends TypeAdapter<LandMarkModel> {
  @override
  final int typeId = 50;

  @override
  LandMarkModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LandMarkModel(
      title: fields[0] as String?,
      location: fields[1] as LocationModel?,
      id: fields[2] as String?,
      createdBy: fields[3] as UserModel?,
    );
  }

  @override
  void write(BinaryWriter writer, LandMarkModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.location)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.createdBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LandMarkModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LandMarkModel _$LandMarkModelFromJson(Map<String, dynamic> json) =>
    LandMarkModel(
      title: json['title'] as String?,
      location: json['location'] == null
          ? null
          : LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      id: json['_id'] as String?,
      createdBy: json['createdBy'] == null
          ? null
          : UserModel.fromJson(json['createdBy'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LandMarkModelToJson(LandMarkModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'location': instance.location,
      '_id': instance.id,
      'createdBy': instance.createdBy,
    };
