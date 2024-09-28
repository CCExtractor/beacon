import 'package:beacon/data/models/beacon/beacon_model.dart';
import 'package:beacon/data/models/user/user_model.dart';
import 'package:beacon/domain/entities/subscriptions/updated_group_entity/updated_group_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'updated_group_model.g.dart';

@JsonSerializable()
class UpdatedGroupModel implements UpdatedGroupEntity {
  @JsonKey(name: 'groupId')
  String? id;
  UserModel? newUser;
  BeaconModel? newBeacon;
  BeaconModel? updatedBeacon;
  BeaconModel? deletedBeacon;

  UpdatedGroupModel({
    this.id,
    this.newUser,
    this.newBeacon,
    this.updatedBeacon,
    this.deletedBeacon,
  });

  factory UpdatedGroupModel.fromJson(Map<String, dynamic> json) =>
      _$UpdatedGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatedGroupModelToJson(this);

  @override
  $UpdatedGroupEntityCopyWith<UpdatedGroupEntity> get copyWith =>
      throw UnimplementedError();
}
