import 'package:beacon/data/models/beacon/beacon_model.dart';
import 'package:beacon/data/models/group/group_model.dart';
import 'package:beacon/data/models/location/location_model.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@HiveType(typeId: 10)
@JsonSerializable()
class UserModel implements UserEntity {
  @JsonKey(name: '_id')
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? email;

  @HiveField(3)
  String? authToken;

  @HiveField(4)
  bool? isGuest;

  @HiveField(5)
  List<GroupModel?>? groups;

  @HiveField(6)
  List<BeaconModel?>? beacons;

  @HiveField(7)
  LocationModel? location;

  @HiveField(8)
  bool? isVerified;

  UserModel(
      {this.authToken,
      this.beacons,
      this.email,
      this.groups,
      this.id,
      this.isGuest,
      this.location,
      this.name,
      this.isVerified});

  @override
  $UserEntityCopyWith<UserEntity> get copyWith => throw UnimplementedError();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWithModel({
    String? id,
    String? name,
    String? authToken,
    String? email,
    bool? isGuest,
    bool? isVerified,
    List<GroupModel?>? groups,
    List<BeaconModel?>? beacons,
    LocationModel? location,
  }) {
    return UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        authToken: authToken ?? this.authToken,
        email: email ?? this.email,
        isGuest: isGuest ?? this.isGuest,
        groups: groups ?? this.groups,
        beacons: beacons ?? this.beacons,
        location: location ?? this.location,
        isVerified: isVerified ?? this.isVerified);
  }
}
