import 'package:beacon/domain/entities/group/group_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState.initial() = InitialHomeState;
  const factory HomeState.shimmer() = ShimmerHomeState;
  const factory HomeState.loading() = LoadingHomeState;
  const factory HomeState.loaded({
    required List<GroupEntity> groups,
    String? message,
    @Default(false) bool isLoadingmore,
    @Default(false) bool hasReachedEnd,
  }) = LoadedHomeState;
}
