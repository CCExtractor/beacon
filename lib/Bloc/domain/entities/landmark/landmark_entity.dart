import 'package:beacon/Bloc/domain/entities/location/location_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'landmark_entity.freezed.dart';

@freezed
class LandMarkEntity with _$LandMarkEntity {
  const factory LandMarkEntity({String? title, LocationEntity? location}) =
      _LandMarkEntity;
}
