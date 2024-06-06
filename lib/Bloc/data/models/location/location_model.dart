import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:beacon/Bloc/domain/entities/location/location_entity.dart';
part 'location_model.g.dart';

@JsonSerializable()
class LocationModel implements LocationEntity {
  final String? lat;
  final String? long;

  LocationModel({
    this.lat,
    this.long,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);

  LocationModel copyWithModel({
    String? lat,
    String? long,
  }) {
    return LocationModel(
      lat: lat ?? this.lat,
      long: long ?? this.long,
    );
  }

  @override
  $LocationEntityCopyWith<LocationEntity> get copyWith =>
      throw UnimplementedError();
}

class LocationModelAdapter extends TypeAdapter<LocationModel> {
  @override
  final int typeId = 40;

  @override
  LocationModel read(BinaryReader reader) {
    final fields = reader.readMap().cast<String, dynamic>();
    return LocationModel.fromJson(fields);
  }

  @override
  void write(BinaryWriter writer, LocationModel obj) {
    writer.writeMap(obj.toJson());
  }
}
