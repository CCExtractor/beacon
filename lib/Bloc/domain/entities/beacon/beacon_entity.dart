import 'package:beacon/Bloc/domain/entities/group/group_entity.dart';
import 'package:beacon/Bloc/domain/entities/landmark/landmark_entity.dart';
import 'package:beacon/Bloc/domain/entities/location/location_entity.dart';
import 'package:beacon/Bloc/domain/entities/user/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'beacon_entity.freezed.dart';

@freezed
class BeaconEntity with _$BeaconEntity {
  const factory BeaconEntity(
      {String? id,
      String? shortcode,
      int? startsAt,
      int? expiresAt,
      String? title,
      UserEntity? leader,
      List<UserEntity?>? followers,
      List<LocationEntity?>? route,
      List<LandMarkEntity?>? landmarks,
      LocationEntity? location,
      GroupEntity? group}) = _BeaconEntity;
}
