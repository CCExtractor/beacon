import 'package:beacon/data/models/group/group_model.dart';
import 'package:beacon/data/models/landmark/landmark_model.dart';
import 'package:beacon/data/models/location/location_model.dart';
import 'package:beacon/data/models/user/user_model.dart';
import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'beacon_model.g.dart';

@HiveType(typeId: 20)
@JsonSerializable()
class BeaconModel implements BeaconEntity {
  @JsonKey(name: '_id')
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  UserModel? leader;
  @HiveField(3)
  GroupModel? group;
  @HiveField(4)
  String? shortcode;
  @HiveField(5)
  List<UserModel?>? followers;
  @HiveField(6)
  List<LandMarkModel?>? landmarks;
  @HiveField(7)
  LocationModel? location;
  @HiveField(8)
  List<LocationModel?>? route;
  @HiveField(9)
  int? startsAt;
  @HiveField(10)
  int? expiresAt;

  BeaconModel(
      {this.id,
      this.title,
      this.leader,
      this.group,
      this.shortcode,
      this.followers,
      this.landmarks,
      this.location,
      this.route,
      this.startsAt,
      this.expiresAt});

  @override
  $BeaconEntityCopyWith<BeaconEntity> get copyWith =>
      throw UnimplementedError();

  factory BeaconModel.fromJson(Map<String, dynamic> json) =>
      _$BeaconModelFromJson(json);

  Map<String, dynamic> toJson() => _$BeaconModelToJson(this);

  BeaconModel copyWithModel({
    String? id,
    String? title,
    UserModel? leader,
    GroupModel? group,
    String? shortcode,
    List<UserModel?>? followers,
    List<LandMarkModel?>? landmarks,
    LocationModel? location,
    List<LocationModel?>? route,
    int? startsAt,
    int? expiresAt,
  }) {
    return BeaconModel(
        id: id ?? this.id,
        title: title ?? this.title,
        leader: leader ?? this.leader,
        group: group ?? this.group,
        shortcode: shortcode ?? this.shortcode,
        followers: followers ?? this.followers,
        landmarks: landmarks ?? this.landmarks,
        location: location ?? this.location,
        route: route ?? this.route,
        startsAt: startsAt ?? this.startsAt,
        expiresAt: expiresAt ?? this.expiresAt);
  }
}
