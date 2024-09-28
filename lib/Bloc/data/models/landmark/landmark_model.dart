import 'package:beacon/Bloc/data/models/location/location_model.dart';
import 'package:beacon/Bloc/domain/entities/landmark/landmark_entity.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'landmark_model.g.dart';

@HiveType(typeId: 50)
@JsonSerializable()
class LandMarkModel implements LandMarkEntity {
  @HiveField(0)
  String? title;
  @HiveField(1)
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
