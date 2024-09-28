// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'join_leave_beacon_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$JoinLeaveBeaconEntity {
  UserEntity? get newfollower => throw _privateConstructorUsedError;
  UserEntity? get inactiveuser => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $JoinLeaveBeaconEntityCopyWith<JoinLeaveBeaconEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JoinLeaveBeaconEntityCopyWith<$Res> {
  factory $JoinLeaveBeaconEntityCopyWith(JoinLeaveBeaconEntity value,
          $Res Function(JoinLeaveBeaconEntity) then) =
      _$JoinLeaveBeaconEntityCopyWithImpl<$Res, JoinLeaveBeaconEntity>;
  @useResult
  $Res call({UserEntity? newfollower, UserEntity? inactiveuser});

  $UserEntityCopyWith<$Res>? get newfollower;
  $UserEntityCopyWith<$Res>? get inactiveuser;
}

/// @nodoc
class _$JoinLeaveBeaconEntityCopyWithImpl<$Res,
        $Val extends JoinLeaveBeaconEntity>
    implements $JoinLeaveBeaconEntityCopyWith<$Res> {
  _$JoinLeaveBeaconEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newfollower = freezed,
    Object? inactiveuser = freezed,
  }) {
    return _then(_value.copyWith(
      newfollower: freezed == newfollower
          ? _value.newfollower
          : newfollower // ignore: cast_nullable_to_non_nullable
              as UserEntity?,
      inactiveuser: freezed == inactiveuser
          ? _value.inactiveuser
          : inactiveuser // ignore: cast_nullable_to_non_nullable
              as UserEntity?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserEntityCopyWith<$Res>? get newfollower {
    if (_value.newfollower == null) {
      return null;
    }

    return $UserEntityCopyWith<$Res>(_value.newfollower!, (value) {
      return _then(_value.copyWith(newfollower: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UserEntityCopyWith<$Res>? get inactiveuser {
    if (_value.inactiveuser == null) {
      return null;
    }

    return $UserEntityCopyWith<$Res>(_value.inactiveuser!, (value) {
      return _then(_value.copyWith(inactiveuser: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$JoinLeaveBeaconEntityImplCopyWith<$Res>
    implements $JoinLeaveBeaconEntityCopyWith<$Res> {
  factory _$$JoinLeaveBeaconEntityImplCopyWith(
          _$JoinLeaveBeaconEntityImpl value,
          $Res Function(_$JoinLeaveBeaconEntityImpl) then) =
      __$$JoinLeaveBeaconEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UserEntity? newfollower, UserEntity? inactiveuser});

  @override
  $UserEntityCopyWith<$Res>? get newfollower;
  @override
  $UserEntityCopyWith<$Res>? get inactiveuser;
}

/// @nodoc
class __$$JoinLeaveBeaconEntityImplCopyWithImpl<$Res>
    extends _$JoinLeaveBeaconEntityCopyWithImpl<$Res,
        _$JoinLeaveBeaconEntityImpl>
    implements _$$JoinLeaveBeaconEntityImplCopyWith<$Res> {
  __$$JoinLeaveBeaconEntityImplCopyWithImpl(_$JoinLeaveBeaconEntityImpl _value,
      $Res Function(_$JoinLeaveBeaconEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newfollower = freezed,
    Object? inactiveuser = freezed,
  }) {
    return _then(_$JoinLeaveBeaconEntityImpl(
      newfollower: freezed == newfollower
          ? _value.newfollower
          : newfollower // ignore: cast_nullable_to_non_nullable
              as UserEntity?,
      inactiveuser: freezed == inactiveuser
          ? _value.inactiveuser
          : inactiveuser // ignore: cast_nullable_to_non_nullable
              as UserEntity?,
    ));
  }
}

/// @nodoc

class _$JoinLeaveBeaconEntityImpl implements _JoinLeaveBeaconEntity {
  _$JoinLeaveBeaconEntityImpl({this.newfollower, this.inactiveuser});

  @override
  final UserEntity? newfollower;
  @override
  final UserEntity? inactiveuser;

  @override
  String toString() {
    return 'JoinLeaveBeaconEntity(newfollower: $newfollower, inactiveuser: $inactiveuser)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JoinLeaveBeaconEntityImpl &&
            (identical(other.newfollower, newfollower) ||
                other.newfollower == newfollower) &&
            (identical(other.inactiveuser, inactiveuser) ||
                other.inactiveuser == inactiveuser));
  }

  @override
  int get hashCode => Object.hash(runtimeType, newfollower, inactiveuser);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$JoinLeaveBeaconEntityImplCopyWith<_$JoinLeaveBeaconEntityImpl>
      get copyWith => __$$JoinLeaveBeaconEntityImplCopyWithImpl<
          _$JoinLeaveBeaconEntityImpl>(this, _$identity);
}

abstract class _JoinLeaveBeaconEntity implements JoinLeaveBeaconEntity {
  factory _JoinLeaveBeaconEntity(
      {final UserEntity? newfollower,
      final UserEntity? inactiveuser}) = _$JoinLeaveBeaconEntityImpl;

  @override
  UserEntity? get newfollower;
  @override
  UserEntity? get inactiveuser;
  @override
  @JsonKey(ignore: true)
  _$$JoinLeaveBeaconEntityImplCopyWith<_$JoinLeaveBeaconEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}
