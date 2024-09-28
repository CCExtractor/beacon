import 'package:beacon/Bloc/data/models/beacon/beacon_model.dart';
import 'package:beacon/Bloc/data/models/group/group_model.dart';
import 'package:beacon/Bloc/data/models/location/location_model.dart';
import 'package:beacon/Bloc/domain/entities/user/user_entity.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel implements UserEntity {
  String? id;
  String? name;
  String? authToken;
  String? email;
  bool? isGuest;
  List<GroupModel?>? groups;
  List<BeaconModel?>? beacons;
  LocationModel? location;

  UserModel(
      {this.authToken,
      this.beacons,
      this.email,
      this.groups,
      this.id,
      this.isGuest,
      this.location,
      this.name});

  @override
  $UserEntityCopyWith<UserEntity> get copyWith => throw UnimplementedError();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWithModel({
    String? id,
    String? name,
    String? authToken,
    String? email,
    bool? isGuest,
    List<GroupModel?>? groups,
    List<BeaconModel?>? beacons,
    LocationModel? location,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      authToken: authToken ?? this.authToken,
      email: email ?? this.email,
      isGuest: isGuest ?? this.isGuest,
      groups: groups ?? this.groups,
      beacons: beacons ?? this.beacons,
      location: location ?? this.location,
    );
  }
}

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 10;
  @override
  UserModel read(BinaryReader reader) {
    final fields = reader.readMap().cast<String, dynamic>();
    return UserModel.fromJson(fields);
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer.writeMap(obj.toJson());
  }
}
