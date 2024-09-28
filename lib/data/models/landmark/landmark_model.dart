import 'package:beacon/data/models/location/location_model.dart';
import 'package:beacon/data/models/user/user_model.dart';
import 'package:beacon/domain/entities/landmark/landmark_entity.dart';

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
  @JsonKey(name: '_id')
  @HiveField(2)
  String? id;
  @HiveField(3)
  UserModel? createdBy;

  LandMarkModel({this.title, this.location, this.id, this.createdBy});

  @override
  $LandMarkEntityCopyWith<LandMarkEntity> get copyWith =>
      throw UnimplementedError();

  factory LandMarkModel.fromJson(Map<String, dynamic> json) =>
      _$LandMarkModelFromJson(json);

  Map<String, dynamic> toJson() => _$LandMarkModelToJson(this);

  LandMarkModel copyWithModel(
      {String? id,
      String? title,
      LocationModel? location,
      UserModel? createdBy}) {
    return LandMarkModel(
        id: id,
        title: title ?? this.title,
        location: location ?? this.location,
        createdBy: createdBy ?? this.createdBy);
  }
}
