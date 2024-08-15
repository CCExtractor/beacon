import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
part 'location_state.freezed.dart';

@freezed
class LocationState with _$LocationState {
  factory LocationState.initial() = InitialLocationState;
  factory LocationState.loaded({
    @Default(MapType.normal) MapType mapType,
    @Default({}) Set<Circle> geofence,
    @Default({}) Set<Marker> locationMarkers,
    @Default({}) Set<Polyline> polyline,
    String? message,
    @Default(0) int version,
  }) = LoadedLocationState;

  factory LocationState.error({String? message}) = LocationErrorState;
}
