import 'package:beacon/domain/entities/location/location_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'geofence_entity.freezed.dart';

@freezed
class GeofenceEntity with _$GeofenceEntity {
  factory GeofenceEntity({LocationEntity? center, double? radius}) =
      _GeofenceEntity;
}
