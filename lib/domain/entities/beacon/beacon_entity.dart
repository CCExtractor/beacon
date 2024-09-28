import 'package:beacon/domain/entities/group/group_entity.dart';
import 'package:beacon/domain/entities/landmark/landmark_entity.dart';
import 'package:beacon/domain/entities/location/location_entity.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'beacon_entity.freezed.dart';

@freezed
class BeaconEntity with _$BeaconEntity {
  const factory BeaconEntity({
    String? id,
    String? shortcode,
    int? startsAt,
    int? expiresAt,
    String? title,
    UserEntity? leader,
    List<UserEntity?>? followers,
    List<LocationEntity?>? route,
    List<LandMarkEntity?>? landmarks,
    LocationEntity? location,
    GroupEntity? group,
  }) = _BeaconEntity;
}

extension BeaconEntityCopyWithExtension on BeaconEntity {
  BeaconEntity copywith(
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
      GroupEntity? group}) {
    return BeaconEntity(
      id: id ?? this.id,
      shortcode: shortcode ?? this.shortcode,
      startsAt: startsAt ?? this.startsAt,
      expiresAt: expiresAt ?? this.expiresAt,
      title: title ?? this.title,
      leader: leader ?? this.leader,
      followers: followers ?? this.followers,
      route: route ?? this.route,
      landmarks: landmarks ?? this.landmarks,
      location: location ?? this.location,
      group: group ?? this.group,
    );
  }
}
