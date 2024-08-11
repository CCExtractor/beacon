import 'package:beacon/data/models/location/location_model.dart';
import 'package:beacon/domain/entities/geofence/geofence_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'geofence_model.g.dart';

@JsonSerializable()
class GeofenceModel implements GeofenceEntity {
  @HiveField(0)
  final double? radius;
  @HiveField(1)
  final LocationModel? center;

  const GeofenceModel({this.center, this.radius});

  factory GeofenceModel.fromJson(Map<String, dynamic> json) =>
      _$GeofenceModelFromJson(json);

  Map<String, dynamic> toJson() => _$GeofenceModelToJson(this);

  @override
  $GeofenceEntityCopyWith<GeofenceEntity> get copyWith =>
      throw UnimplementedError();
}
