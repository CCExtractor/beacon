import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'members_state.freezed.dart';

@freezed
class MembersState with _$MembersState {
  factory MembersState.initial() = InitialMemberState;
  factory MembersState.loading() = LoadingMemberState;
  factory MembersState.reload({List<UserEntity>? members, String? message}) =
      LoadedMemberState;
}
