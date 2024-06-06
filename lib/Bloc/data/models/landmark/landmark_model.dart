import 'package:beacon/Bloc/data/models/location/location_model.dart';
import 'package:beacon/Bloc/domain/entities/landmark/landmark_entity.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'landmark_model.g.dart';

@JsonSerializable()
class LandMarkModel implements LandMarkEntity {
  String? title;
  LocationModel? location;

  LandMarkModel({this.title, this.location});

  @override
  $LandMarkEntityCopyWith<LandMarkEntity> get copyWith =>
      throw UnimplementedError();

  factory LandMarkModel.fromJson(Map<String, dynamic> json) =>
      _$LandMarkModelFromJson(json);

  Map<String, dynamic> toJson() => _$LandMarkModelToJson(this);

  LandMarkModel copyWithModel({
    String? title,
    LocationModel? location,
  }) {
    return LandMarkModel(
      title: title ?? this.title,
      location: location ?? this.location,
    );
  }
}

class LandMarkModelAdapter extends TypeAdapter<LandMarkModel> {
  @override
  final int typeId = 50;

  @override
  LandMarkModel read(BinaryReader reader) {
    final fields = reader.readMap().cast<String, dynamic>();
    return LandMarkModel.fromJson(fields);
  }

  @override
  void write(BinaryWriter writer, LandMarkModel obj) {
    writer.writeMap(obj.toJson());
  }
}
