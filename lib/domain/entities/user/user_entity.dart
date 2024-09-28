import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/domain/entities/group/group_entity.dart';
import 'package:beacon/domain/entities/location/location_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity(
      {String? id,
      List<GroupEntity?>? groups,
      List<BeaconEntity?>? beacons,
      String? authToken,
      String? email,
      bool? isGuest,
      String? name,
      bool? isVerified,
      LocationEntity? location}) = _UserEntity;
}

extension UserEntityCopyWithExtension on UserEntity {
  UserEntity copywith({
    String? id,
    List<GroupEntity?>? groups,
    List<BeaconEntity?>? beacons,
    String? authToken,
    String? email,
    bool? isGuest,
    String? name,
    bool? isVerified,
    LocationEntity? location,
  }) {
    return UserEntity(
        id: id ?? this.id,
        groups: groups ?? this.groups,
        beacons: beacons ?? this.beacons,
        authToken: authToken ?? this.authToken,
        email: email ?? this.email,
        isGuest: isGuest ?? this.isGuest,
        name: name ?? this.name,
        location: location ?? this.location,
        isVerified: isVerified ?? this.isVerified);
  }
}
