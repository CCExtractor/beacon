import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'updated_group_entity.freezed.dart';

@freezed
class UpdatedGroupEntity with _$UpdatedGroupEntity {
  factory UpdatedGroupEntity(
      {String? id,
      BeaconEntity? deletedBeacon,
      BeaconEntity? updatedBeacon,
      BeaconEntity? newBeacon,
      UserEntity? newUser}) = _UpdatedGroupEntity;
}

extension UpdatedGroupEntityCopyWithExtension on UpdatedGroupEntity {
  UpdatedGroupEntity copywith({
    String? id,
    BeaconEntity? deletedBeacon,
    BeaconEntity? updatedBeacon,
    BeaconEntity? newBeacon,
    UserEntity? newUser,
  }) {
    return UpdatedGroupEntity(
      id: id ?? this.id,
      deletedBeacon: deletedBeacon ?? this.deletedBeacon,
      updatedBeacon: updatedBeacon ?? this.updatedBeacon,
      newBeacon: newBeacon ?? this.newBeacon,
      newUser: newUser ?? this.newUser,
    );
  }
}
