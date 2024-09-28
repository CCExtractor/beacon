import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'hike_state.freezed.dart';

@freezed
class HikeState with _$HikeState {
  factory HikeState.initial() = InitialHikeState;
  factory HikeState.loaded({BeaconEntity? beacon, String? message}) =
      LoadedHikeState;

  factory HikeState.error({String? errmessage}) = ErrorHikeState;
}
