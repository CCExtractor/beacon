import 'package:beacon/Bloc/data/models/group/group_model.dart';
import 'package:beacon/Bloc/data/models/landmark/landmark_model.dart';
import 'package:beacon/Bloc/data/models/location/location_model.dart';
import 'package:beacon/Bloc/data/models/user/user_model.dart';
import 'package:beacon/Bloc/domain/entities/beacon/beacon_entity.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'beacon_model.g.dart';

@JsonSerializable()
class BeaconModel implements BeaconEntity {
  String? id;
  String? title;
  UserModel? leader;
  GroupModel? group;
  String? shortcode;
  List<UserModel?>? followers;
  List<LandMarkModel?>? landmarks;
  LocationModel? location;
  List<LocationModel?>? route;
  int? startsAt;
  int? expiresAt;

  BeaconModel({
    this.id,
    this.title,
    this.leader,
    this.group,
    this.shortcode,
    this.followers,
    this.landmarks,
    this.location,
    this.route,
    this.startsAt,
    this.expiresAt,
  });

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
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}

class BeaconModelAdapter extends TypeAdapter<BeaconModel> {
  @override
  final int typeId = 20;

  @override
  BeaconModel read(BinaryReader reader) {
    final fields = reader.readMap().cast<String, dynamic>();
    return BeaconModel.fromJson(fields);
  }

  @override
  void write(BinaryWriter writer, BeaconModel obj) {
    writer.writeMap(obj.toJson());
  }
}
