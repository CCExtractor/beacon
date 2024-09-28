import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'join_leave_beacon_entity.freezed.dart';

@freezed
class JoinLeaveBeaconEntity with _$JoinLeaveBeaconEntity {
  factory JoinLeaveBeaconEntity(
      {UserEntity? newfollower,
      UserEntity? inactiveuser}) = _JoinLeaveBeaconEntity;
}
