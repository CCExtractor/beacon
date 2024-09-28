import 'package:beacon/Bloc/data/models/beacon/beacon_model.dart';
import 'package:beacon/Bloc/data/models/user/user_model.dart';
import 'package:beacon/Bloc/domain/entities/group/group_entity.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'group_model.g.dart';

@JsonSerializable()
class GroupModel implements GroupEntity {
  String? id;
  String? title;
  UserModel? leader;
  List<UserModel?>? members;
  String? shortcode;
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
}

class GroupModelAdapter extends TypeAdapter<GroupModel> {
  @override
  final int typeId = 30;

  @override
  GroupModel read(BinaryReader reader) {
    final fields = reader.readMap().cast<String, dynamic>();
    return GroupModel.fromJson(fields);
  }

  @override
  void write(BinaryWriter writer, GroupModel obj) {
    writer.writeMap(obj.toJson());
  }
}
