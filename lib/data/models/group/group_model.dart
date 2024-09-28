import 'package:beacon/data/models/beacon/beacon_model.dart';
import 'package:beacon/data/models/user/user_model.dart';
import 'package:beacon/domain/entities/group/group_entity.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'group_model.g.dart';

@HiveType(typeId: 30)
@JsonSerializable()
class GroupModel implements GroupEntity {
  @JsonKey(name: '_id')
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  UserModel? leader;
  @HiveField(3)
  List<UserModel?>? members;
  @HiveField(4)
  String? shortcode;
  @HiveField(5)
  List<BeaconModel?>? beacons;

  GroupModel({
    this.id,
    this.title,
    this.leader,
    this.members,
    this.shortcode,
    this.beacons,
  });

  @override
  $GroupEntityCopyWith<GroupEntity> get copyWith => throw UnimplementedError();

  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroupModelToJson(this);

  GroupModel copyWithModel({
    String? id,
    String? title,
    UserModel? leader,
    List<UserModel?>? members,
    String? shortcode,
    List<BeaconModel?>? beacons,
  }) {
    return GroupModel(
      id: id ?? this.id,
      title: title ?? this.title,
      leader: leader ?? this.leader,
      members: members ?? this.members,
      shortcode: shortcode ?? this.shortcode,
      beacons: beacons ?? this.beacons,
    );
  }

  @override
  bool get hasBeaconActivity => false;

  @override
  bool get hasMemberActivity => false;
}
