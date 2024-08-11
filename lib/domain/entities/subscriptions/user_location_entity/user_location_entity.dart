import 'package:beacon/domain/entities/location/location_entity.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
part 'user_location_entity.freezed.dart';

@freezed
class UserLocationEntity with _$UserLocationEntity {
  factory UserLocationEntity({UserEntity? user, LocationEntity? location}) =
      _UserLocationEntity;
}

extension UserLocationEntityCopyWithExtension on UserLocationEntity {
  UserLocationEntity copywith({UserEntity? user, LocationEntity? location}) {
    return UserLocationEntity(
        location: location ?? this.location, user: user ?? this.user);
  }
}
