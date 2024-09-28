import 'package:freezed_annotation/freezed_annotation.dart';
part 'location_entity.freezed.dart';

@freezed
class LocationEntity with _$LocationEntity {
  factory LocationEntity({String? lat, String? lon}) = _LocationEntity;
}
