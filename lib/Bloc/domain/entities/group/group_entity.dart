import 'package:beacon/Bloc/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/Bloc/domain/entities/user/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_entity.freezed.dart';

@freezed
class GroupEntity with _$GroupEntity {
  const factory GroupEntity({
    String? id,
    List<BeaconEntity?>? beacons,
    List<UserEntity?>? members,
    UserEntity? leader,
    String? title,
    String? shortcode,
  }) = _GroupEntity;
}
