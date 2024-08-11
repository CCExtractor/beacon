import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'panel_state.freezed.dart';

@freezed
class SlidingPanelState with _$SlidingPanelState {
  factory SlidingPanelState.initial() = InitialPanelState;
  factory SlidingPanelState.loaded({
    bool? isActive,
    String? expiringTime,
    String? leaderAddress,
    UserEntity? leader,
    List<UserEntity?>? followers,
    String? message,
  }) = LoadedPanelState;

  factory SlidingPanelState.error({String? message}) = ErrorPanelState;
}
