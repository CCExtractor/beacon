import 'package:beacon/data/models/user/user_model.dart';
import 'package:beacon/domain/entities/subscriptions/join_leave_beacon_entity/join_leave_beacon_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'join_leave_beacon_model.g.dart';

@JsonSerializable()
class JoinLeaveBeaconModel implements JoinLeaveBeaconEntity {
  UserModel? inactiveuser;
  UserModel? newfollower;

  JoinLeaveBeaconModel({this.inactiveuser, this.newfollower});

  @override
  $JoinLeaveBeaconEntityCopyWith<JoinLeaveBeaconEntity> get copyWith =>
      throw UnimplementedError();

  factory JoinLeaveBeaconModel.fromJson(Map<String, dynamic> json) =>
      _$JoinLeaveBeaconModelFromJson(json);

  Map<String, dynamic> toJson() => _$JoinLeaveBeaconModelToJson(this);
}
