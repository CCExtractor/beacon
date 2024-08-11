// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_location_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserLocationEntity {
  UserEntity? get user => throw _privateConstructorUsedError;
  LocationEntity? get location => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserLocationEntityCopyWith<UserLocationEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserLocationEntityCopyWith<$Res> {
  factory $UserLocationEntityCopyWith(
          UserLocationEntity value, $Res Function(UserLocationEntity) then) =
      _$UserLocationEntityCopyWithImpl<$Res, UserLocationEntity>;
  @useResult
  $Res call({UserEntity? user, LocationEntity? location});

  $UserEntityCopyWith<$Res>? get user;
  $LocationEntityCopyWith<$Res>? get location;
}

/// @nodoc
class _$UserLocationEntityCopyWithImpl<$Res, $Val extends UserLocationEntity>
    implements $UserLocationEntityCopyWith<$Res> {
  _$UserLocationEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? location = freezed,
  }) {
    return _then(_value.copyWith(
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserEntity?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LocationEntity?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserEntityCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserEntityCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $LocationEntityCopyWith<$Res>? get location {
    if (_value.location == null) {
      return null;
    }

    return $LocationEntityCopyWith<$Res>(_value.location!, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserLocationEntityImplCopyWith<$Res>
    implements $UserLocationEntityCopyWith<$Res> {
  factory _$$UserLocationEntityImplCopyWith(_$UserLocationEntityImpl value,
          $Res Function(_$UserLocationEntityImpl) then) =
      __$$UserLocationEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UserEntity? user, LocationEntity? location});

  @override
  $UserEntityCopyWith<$Res>? get user;
  @override
  $LocationEntityCopyWith<$Res>? get location;
}

/// @nodoc
class __$$UserLocationEntityImplCopyWithImpl<$Res>
    extends _$UserLocationEntityCopyWithImpl<$Res, _$UserLocationEntityImpl>
    implements _$$UserLocationEntityImplCopyWith<$Res> {
  __$$UserLocationEntityImplCopyWithImpl(_$UserLocationEntityImpl _value,
      $Res Function(_$UserLocationEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? location = freezed,
  }) {
    return _then(_$UserLocationEntityImpl(
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserEntity?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LocationEntity?,
    ));
  }
}

/// @nodoc

class _$UserLocationEntityImpl implements _UserLocationEntity {
  _$UserLocationEntityImpl({this.user, this.location});

  @override
  final UserEntity? user;
  @override
  final LocationEntity? location;

  @override
  String toString() {
    return 'UserLocationEntity(user: $user, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserLocationEntityImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, location);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserLocationEntityImplCopyWith<_$UserLocationEntityImpl> get copyWith =>
      __$$UserLocationEntityImplCopyWithImpl<_$UserLocationEntityImpl>(
          this, _$identity);
}

abstract class _UserLocationEntity implements UserLocationEntity {
  factory _UserLocationEntity(
      {final UserEntity? user,
      final LocationEntity? location}) = _$UserLocationEntityImpl;

  @override
  UserEntity? get user;
  @override
  LocationEntity? get location;
  @override
  @JsonKey(ignore: true)
  _$$UserLocationEntityImplCopyWith<_$UserLocationEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
