// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'beacon_locations_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BeaconLocationsEntity {
  UserEntity? get userSOS => throw _privateConstructorUsedError;
  List<LocationEntity?>? get route => throw _privateConstructorUsedError;
  LandMarkEntity? get landmark => throw _privateConstructorUsedError;
  UserEntity? get user => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BeaconLocationsEntityCopyWith<BeaconLocationsEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BeaconLocationsEntityCopyWith<$Res> {
  factory $BeaconLocationsEntityCopyWith(BeaconLocationsEntity value,
          $Res Function(BeaconLocationsEntity) then) =
      _$BeaconLocationsEntityCopyWithImpl<$Res, BeaconLocationsEntity>;
  @useResult
  $Res call(
      {UserEntity? userSOS,
      List<LocationEntity?>? route,
      LandMarkEntity? landmark,
      UserEntity? user});

  $UserEntityCopyWith<$Res>? get userSOS;
  $LandMarkEntityCopyWith<$Res>? get landmark;
  $UserEntityCopyWith<$Res>? get user;
}

/// @nodoc
class _$BeaconLocationsEntityCopyWithImpl<$Res,
        $Val extends BeaconLocationsEntity>
    implements $BeaconLocationsEntityCopyWith<$Res> {
  _$BeaconLocationsEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userSOS = freezed,
    Object? route = freezed,
    Object? landmark = freezed,
    Object? user = freezed,
  }) {
    return _then(_value.copyWith(
      userSOS: freezed == userSOS
          ? _value.userSOS
          : userSOS // ignore: cast_nullable_to_non_nullable
              as UserEntity?,
      route: freezed == route
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as List<LocationEntity?>?,
      landmark: freezed == landmark
          ? _value.landmark
          : landmark // ignore: cast_nullable_to_non_nullable
              as LandMarkEntity?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserEntity?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserEntityCopyWith<$Res>? get userSOS {
    if (_value.userSOS == null) {
      return null;
    }

    return $UserEntityCopyWith<$Res>(_value.userSOS!, (value) {
      return _then(_value.copyWith(userSOS: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $LandMarkEntityCopyWith<$Res>? get landmark {
    if (_value.landmark == null) {
      return null;
    }

    return $LandMarkEntityCopyWith<$Res>(_value.landmark!, (value) {
      return _then(_value.copyWith(landmark: value) as $Val);
    });
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
}

/// @nodoc
abstract class _$$BeaconLocationsEntityImplCopyWith<$Res>
    implements $BeaconLocationsEntityCopyWith<$Res> {
  factory _$$BeaconLocationsEntityImplCopyWith(
          _$BeaconLocationsEntityImpl value,
          $Res Function(_$BeaconLocationsEntityImpl) then) =
      __$$BeaconLocationsEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {UserEntity? userSOS,
      List<LocationEntity?>? route,
      LandMarkEntity? landmark,
      UserEntity? user});

  @override
  $UserEntityCopyWith<$Res>? get userSOS;
  @override
  $LandMarkEntityCopyWith<$Res>? get landmark;
  @override
  $UserEntityCopyWith<$Res>? get user;
}

/// @nodoc
class __$$BeaconLocationsEntityImplCopyWithImpl<$Res>
    extends _$BeaconLocationsEntityCopyWithImpl<$Res,
        _$BeaconLocationsEntityImpl>
    implements _$$BeaconLocationsEntityImplCopyWith<$Res> {
  __$$BeaconLocationsEntityImplCopyWithImpl(_$BeaconLocationsEntityImpl _value,
      $Res Function(_$BeaconLocationsEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userSOS = freezed,
    Object? route = freezed,
    Object? landmark = freezed,
    Object? user = freezed,
  }) {
    return _then(_$BeaconLocationsEntityImpl(
      userSOS: freezed == userSOS
          ? _value.userSOS
          : userSOS // ignore: cast_nullable_to_non_nullable
              as UserEntity?,
      route: freezed == route
          ? _value._route
          : route // ignore: cast_nullable_to_non_nullable
              as List<LocationEntity?>?,
      landmark: freezed == landmark
          ? _value.landmark
          : landmark // ignore: cast_nullable_to_non_nullable
              as LandMarkEntity?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserEntity?,
    ));
  }
}

/// @nodoc

class _$BeaconLocationsEntityImpl implements _BeaconLocationsEntity {
  _$BeaconLocationsEntityImpl(
      {this.userSOS,
      final List<LocationEntity?>? route,
      this.landmark,
      this.user})
      : _route = route;

  @override
  final UserEntity? userSOS;
  final List<LocationEntity?>? _route;
  @override
  List<LocationEntity?>? get route {
    final value = _route;
    if (value == null) return null;
    if (_route is EqualUnmodifiableListView) return _route;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final LandMarkEntity? landmark;
  @override
  final UserEntity? user;

  @override
  String toString() {
    return 'BeaconLocationsEntity(userSOS: $userSOS, route: $route, landmark: $landmark, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BeaconLocationsEntityImpl &&
            (identical(other.userSOS, userSOS) || other.userSOS == userSOS) &&
            const DeepCollectionEquality().equals(other._route, _route) &&
            (identical(other.landmark, landmark) ||
                other.landmark == landmark) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userSOS,
      const DeepCollectionEquality().hash(_route), landmark, user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BeaconLocationsEntityImplCopyWith<_$BeaconLocationsEntityImpl>
      get copyWith => __$$BeaconLocationsEntityImplCopyWithImpl<
          _$BeaconLocationsEntityImpl>(this, _$identity);
}

abstract class _BeaconLocationsEntity implements BeaconLocationsEntity {
  factory _BeaconLocationsEntity(
      {final UserEntity? userSOS,
      final List<LocationEntity?>? route,
      final LandMarkEntity? landmark,
      final UserEntity? user}) = _$BeaconLocationsEntityImpl;

  @override
  UserEntity? get userSOS;
  @override
  List<LocationEntity?>? get route;
  @override
  LandMarkEntity? get landmark;
  @override
  UserEntity? get user;
  @override
  @JsonKey(ignore: true)
  _$$BeaconLocationsEntityImplCopyWith<_$BeaconLocationsEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}
