import 'package:beacon/domain/entities/location/location_entity.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'landmark_entity.freezed.dart';

@freezed
class LandMarkEntity with _$LandMarkEntity {
  const factory LandMarkEntity(
      {String? id,
      String? title,
      LocationEntity? location,
      UserEntity? createdBy}) = _LandMarkEntity;
}

extension LandMarkEntityCopyWithExtension on LandMarkEntity {
  LandMarkEntity copywith(
      {String? id,
      String? title,
      LocationEntity? location,
      UserEntity? createdBy}) {
    return LandMarkEntity(
        id: id ?? this.id,
        title: title ?? this.title,
        location: location ?? this.location,
        createdBy: createdBy ?? this.createdBy);
  }
}
