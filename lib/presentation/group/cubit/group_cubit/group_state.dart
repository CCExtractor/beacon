import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
part 'group_state.freezed.dart';

enum filters { ALL, ACTIVE, UPCOMING, NEARBY, INACTIVE }

@freezed
abstract class GroupState with _$GroupState {
  const factory GroupState.initial() = InitialGroupState;

  const factory GroupState.loading() = LoadingGroupState;

  const factory GroupState.shrimmer() = ShrimmerGroupState;

  const factory GroupState.allBeacon(
      {@Default(false) bool isLoadingMore,
      @Default(false) bool isCompletelyFetched,
      String? message,
      @Default(filters.ALL) filters type,
      required List<BeaconEntity> beacons,
      @Default(0) int version}) = AllBeaconGroupState;

  const factory GroupState.nearbyBeacon(
      {String? message,
      @Default(filters.NEARBY) filters type,
      required List<BeaconEntity> beacons,
      @Default(1000.0) double radius,
      @Default(0) int version}) = NearbyBeaconGroupState;

  const factory GroupState.statusFilterBeacon(
      {@Default(false) bool isLoadingMore,
      @Default(false) bool isCompletelyFetched,
      String? message,
      filters? type,
      required List<BeaconEntity> beacons,
      @Default(0) int version}) = StatusFilterBeaconGroupState;

  const factory GroupState.error({
    required String message,
  }) = ErrorGroupState;
}
