import 'package:beacon/domain/entities/geofence/geofence_entity.dart';
import 'package:beacon/domain/entities/landmark/landmark_entity.dart';
import 'package:beacon/domain/entities/location/location_entity.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'beacon_locations_entity.freezed.dart';

@freezed
class BeaconLocationsEntity with _$BeaconLocationsEntity {
  factory BeaconLocationsEntity({
    UserEntity? userSOS,
    List<LocationEntity?>? route,
    GeofenceEntity? geofence,
    LandMarkEntity? landmark,
    UserEntity? user,
  }) = _BeaconLocationsEntity;
}
