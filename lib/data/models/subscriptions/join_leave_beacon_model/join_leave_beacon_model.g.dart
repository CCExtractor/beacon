// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_leave_beacon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JoinLeaveBeaconModel _$JoinLeaveBeaconModelFromJson(
        Map<String, dynamic> json) =>
    JoinLeaveBeaconModel(
      inactiveuser: json['inactiveuser'] == null
          ? null
          : UserModel.fromJson(json['inactiveuser'] as Map<String, dynamic>),
      newfollower: json['newfollower'] == null
          ? null
          : UserModel.fromJson(json['newfollower'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JoinLeaveBeaconModelToJson(
        JoinLeaveBeaconModel instance) =>
    <String, dynamic>{
      'inactiveuser': instance.inactiveuser,
      'newfollower': instance.newfollower,
    };
