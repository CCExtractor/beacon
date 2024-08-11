import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'group_entity.freezed.dart';

@freezed
class GroupEntity with _$GroupEntity {
  const factory GroupEntity(
      {String? id,
      List<BeaconEntity?>? beacons,
      List<UserEntity?>? members,
      UserEntity? leader,
      String? title,
      String? shortcode,
      @Default(false) bool hasBeaconActivity,
      @Default(false) bool hasMemberActivity}) = _GroupEntity;
}

extension GroupEntityCopyWithExtension on GroupEntity {
  GroupEntity copywith(
      {String? id,
      List<BeaconEntity?>? beacons,
      List<UserEntity?>? members,
      UserEntity? leader,
      String? title,
      String? shortcode,
      bool? hasBeaconActiby,
      bool? hasMemberActivity}) {
    return GroupEntity(
        id: id ?? this.id,
        beacons: beacons ?? this.beacons,
        members: members ?? this.members,
        leader: leader ?? this.leader,
        title: title ?? this.title,
        shortcode: shortcode ?? this.shortcode,
        hasBeaconActivity: hasBeaconActiby ?? this.hasBeaconActivity,
        hasMemberActivity: hasMemberActivity ?? this.hasMemberActivity);
  }
}
