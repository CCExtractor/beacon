import 'package:freezed_annotation/freezed_annotation.dart';
part 'location_entity.freezed.dart';

@freezed
class LocationEntity with _$LocationEntity {
  factory LocationEntity({String? id, String? lat, String? lon}) =
      _LocationEntity;
}

extension LocationEntityCopyWithExtension on LocationEntity {
  LocationEntity copywith({
    String? id,
    String? lat,
    String? lon,
  }) {
    return LocationEntity(
      id: id ?? this.id,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
    );
  }
}
