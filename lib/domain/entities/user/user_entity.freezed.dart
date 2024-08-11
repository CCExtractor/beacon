// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserEntity {
  String? get id => throw _privateConstructorUsedError;
  List<GroupEntity?>? get groups => throw _privateConstructorUsedError;
  List<BeaconEntity?>? get beacons => throw _privateConstructorUsedError;
  String? get authToken => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  bool? get isGuest => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  bool? get isVerified => throw _privateConstructorUsedError;
  LocationEntity? get location => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserEntityCopyWith<UserEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserEntityCopyWith<$Res> {
  factory $UserEntityCopyWith(
          UserEntity value, $Res Function(UserEntity) then) =
      _$UserEntityCopyWithImpl<$Res, UserEntity>;
  @useResult
  $Res call(
      {String? id,
      List<GroupEntity?>? groups,
      List<BeaconEntity?>? beacons,
      String? authToken,
      String? email,
      bool? isGuest,
      String? name,
      bool? isVerified,
      LocationEntity? location});

  $LocationEntityCopyWith<$Res>? get location;
}

/// @nodoc
class _$UserEntityCopyWithImpl<$Res, $Val extends UserEntity>
    implements $UserEntityCopyWith<$Res> {
  _$UserEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? groups = freezed,
    Object? beacons = freezed,
    Object? authToken = freezed,
    Object? email = freezed,
    Object? isGuest = freezed,
    Object? name = freezed,
    Object? isVerified = freezed,
    Object? location = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      groups: freezed == groups
          ? _value.groups
          : groups // ignore: cast_nullable_to_non_nullable
              as List<GroupEntity?>?,
      beacons: freezed == beacons
          ? _value.beacons
          : beacons // ignore: cast_nullable_to_non_nullable
              as List<BeaconEntity?>?,
      authToken: freezed == authToken
          ? _value.authToken
          : authToken // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      isGuest: freezed == isGuest
          ? _value.isGuest
          : isGuest // ignore: cast_nullable_to_non_nullable
              as bool?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: freezed == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LocationEntity?,
    ) as $Val);
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
abstract class _$$UserEntityImplCopyWith<$Res>
    implements $UserEntityCopyWith<$Res> {
  factory _$$UserEntityImplCopyWith(
          _$UserEntityImpl value, $Res Function(_$UserEntityImpl) then) =
      __$$UserEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      List<GroupEntity?>? groups,
      List<BeaconEntity?>? beacons,
      String? authToken,
      String? email,
      bool? isGuest,
      String? name,
      bool? isVerified,
      LocationEntity? location});

  @override
  $LocationEntityCopyWith<$Res>? get location;
}

/// @nodoc
class __$$UserEntityImplCopyWithImpl<$Res>
    extends _$UserEntityCopyWithImpl<$Res, _$UserEntityImpl>
    implements _$$UserEntityImplCopyWith<$Res> {
  __$$UserEntityImplCopyWithImpl(
      _$UserEntityImpl _value, $Res Function(_$UserEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? groups = freezed,
    Object? beacons = freezed,
    Object? authToken = freezed,
    Object? email = freezed,
    Object? isGuest = freezed,
    Object? name = freezed,
    Object? isVerified = freezed,
    Object? location = freezed,
  }) {
    return _then(_$UserEntityImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      groups: freezed == groups
          ? _value._groups
          : groups // ignore: cast_nullable_to_non_nullable
              as List<GroupEntity?>?,
      beacons: freezed == beacons
          ? _value._beacons
          : beacons // ignore: cast_nullable_to_non_nullable
              as List<BeaconEntity?>?,
      authToken: freezed == authToken
          ? _value.authToken
          : authToken // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      isGuest: freezed == isGuest
          ? _value.isGuest
          : isGuest // ignore: cast_nullable_to_non_nullable
              as bool?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: freezed == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LocationEntity?,
    ));
  }
}

/// @nodoc

class _$UserEntityImpl implements _UserEntity {
  const _$UserEntityImpl(
      {this.id,
      final List<GroupEntity?>? groups,
      final List<BeaconEntity?>? beacons,
      this.authToken,
      this.email,
      this.isGuest,
      this.name,
      this.isVerified,
      this.location})
      : _groups = groups,
        _beacons = beacons;

  @override
  final String? id;
  final List<GroupEntity?>? _groups;
  @override
  List<GroupEntity?>? get groups {
    final value = _groups;
    if (value == null) return null;
    if (_groups is EqualUnmodifiableListView) return _groups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<BeaconEntity?>? _beacons;
  @override
  List<BeaconEntity?>? get beacons {
    final value = _beacons;
    if (value == null) return null;
    if (_beacons is EqualUnmodifiableListView) return _beacons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? authToken;
  @override
  final String? email;
  @override
  final bool? isGuest;
  @override
  final String? name;
  @override
  final bool? isVerified;
  @override
  final LocationEntity? location;

  @override
  String toString() {
    return 'UserEntity(id: $id, groups: $groups, beacons: $beacons, authToken: $authToken, email: $email, isGuest: $isGuest, name: $name, isVerified: $isVerified, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._groups, _groups) &&
            const DeepCollectionEquality().equals(other._beacons, _beacons) &&
            (identical(other.authToken, authToken) ||
                other.authToken == authToken) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.isGuest, isGuest) || other.isGuest == isGuest) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(_groups),
      const DeepCollectionEquality().hash(_beacons),
      authToken,
      email,
      isGuest,
      name,
      isVerified,
      location);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserEntityImplCopyWith<_$UserEntityImpl> get copyWith =>
      __$$UserEntityImplCopyWithImpl<_$UserEntityImpl>(this, _$identity);
}

abstract class _UserEntity implements UserEntity {
  const factory _UserEntity(
      {final String? id,
      final List<GroupEntity?>? groups,
      final List<BeaconEntity?>? beacons,
      final String? authToken,
      final String? email,
      final bool? isGuest,
      final String? name,
      final bool? isVerified,
      final LocationEntity? location}) = _$UserEntityImpl;

  @override
  String? get id;
  @override
  List<GroupEntity?>? get groups;
  @override
  List<BeaconEntity?>? get beacons;
  @override
  String? get authToken;
  @override
  String? get email;
  @override
  bool? get isGuest;
  @override
  String? get name;
  @override
  bool? get isVerified;
  @override
  LocationEntity? get location;
  @override
  @JsonKey(ignore: true)
  _$$UserEntityImplCopyWith<_$UserEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
