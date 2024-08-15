import 'package:beacon/data/models/landmark/landmark_model.dart';
import 'package:beacon/data/models/location/location_model.dart';
import 'package:beacon/data/models/user/user_model.dart';
import 'package:beacon/domain/entities/subscriptions/beacon_locations_entity/beacon_locations_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'beacon_locations_model.g.dart';

@JsonSerializable()
class BeaconLocationsModel implements BeaconLocationsEntity {
  UserModel? userSOS;
  List<LocationModel?>? route;
  LandMarkModel? landmark;
  @JsonKey(name: 'updatedUser')
  UserModel? user;

  BeaconLocationsModel({this.userSOS, this.route, this.landmark, this.user});

  factory BeaconLocationsModel.fromJson(Map<String, dynamic> json) =>
      _$BeaconLocationsModelFromJson(json);

  Map<String, dynamic> toJson() => _$BeaconLocationsModelToJson(this);

  @override
  $BeaconLocationsEntityCopyWith<BeaconLocationsEntity> get copyWith =>
      throw UnimplementedError();
}
