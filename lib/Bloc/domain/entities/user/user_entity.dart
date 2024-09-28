import 'package:beacon/Bloc/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/Bloc/domain/entities/group/group_entity.dart';
import 'package:beacon/Bloc/domain/entities/location/location_entity.dart';
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
      LocationEntity? location}) = _UserEntity;
}
