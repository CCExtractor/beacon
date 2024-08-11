import 'package:beacon/data/models/location/location_model.dart';
import 'package:beacon/data/models/user/user_model.dart';
import 'package:beacon/domain/entities/location/location_entity.dart';
import 'package:beacon/domain/entities/subscriptions/user_location_entity/user_location_entity.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_location_model.g.dart';

@JsonSerializable()
class UserLocationModel implements UserLocationEntity {
  UserModel? user;
  LocationModel? location;

  UserLocationModel({this.user, this.location});

  factory UserLocationModel.fromJson(Map<String, dynamic> json) =>
      _$UserLocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserLocationModelToJson(this);

  @override
  $UserLocationEntityCopyWith<UserLocationEntity> get copyWith =>
      throw UnimplementedError();
}
