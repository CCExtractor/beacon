// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'beacon_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BeaconEntity {
  String? get id => throw _privateConstructorUsedError;
  String? get shortcode => throw _privateConstructorUsedError;
  int? get startsAt => throw _privateConstructorUsedError;
  int? get expiresAt => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  UserEntity? get leader => throw _privateConstructorUsedError;
  List<UserEntity?>? get followers => throw _privateConstructorUsedError;
  List<LocationEntity?>? get route => throw _privateConstructorUsedError;
  List<LandMarkEntity?>? get landmarks => throw _privateConstructorUsedError;
  LocationEntity? get location => throw _privateConstructorUsedError;
  GroupEntity? get group => throw _privateConstructorUsedError;
  GeofenceEntity? get geofence => throw _privateConstructorUsedError;
  List<UserLocationEntity?>? get membersLocation =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BeaconEntityCopyWith<BeaconEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BeaconEntityCopyWith<$Res> {
  factory $BeaconEntityCopyWith(
          BeaconEntity value, $Res Function(BeaconEntity) then) =
      _$BeaconEntityCopyWithImpl<$Res, BeaconEntity>;
  @useResult
  $Res call(
      {String? id,
      String? shortcode,
      int? startsAt,
      int? expiresAt,
      String? title,
      UserEntity? leader,
      List<UserEntity?>? followers,
      List<LocationEntity?>? route,
      List<LandMarkEntity?>? landmarks,
      LocationEntity? location,
      GroupEntity? group,
      GeofenceEntity? geofence,
      List<UserLocationEntity?>? membersLocation});

  $UserEntityCopyWith<$Res>? get leader;
  $LocationEntityCopyWith<$Res>? get location;
  $GroupEntityCopyWith<$Res>? get group;
  $GeofenceEntityCopyWith<$Res>? get geofence;
}

/// @nodoc
class _$BeaconEntityCopyWithImpl<$Res, $Val extends BeaconEntity>
    implements $BeaconEntityCopyWith<$Res> {
  _$BeaconEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? shortcode = freezed,
    Object? startsAt = freezed,
    Object? expiresAt = freezed,
    Object? title = freezed,
    Object? leader = freezed,
    Object? followers = freezed,
    Object? route = freezed,
    Object? landmarks = freezed,
    Object? location = freezed,
    Object? group = freezed,
    Object? geofence = freezed,
    Object? membersLocation = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      shortcode: freezed == shortcode
          ? _value.shortcode
          : shortcode // ignore: cast_nullable_to_non_nullable
              as String?,
      startsAt: freezed == startsAt
          ? _value.startsAt
          : startsAt // ignore: cast_nullable_to_non_nullable
              as int?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      leader: freezed == leader
          ? _value.leader
          : leader // ignore: cast_nullable_to_non_nullable
              as UserEntity?,
      followers: freezed == followers
          ? _value.followers
          : followers // ignore: cast_nullable_to_non_nullable
              as List<UserEntity?>?,
      route: freezed == route
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as List<LocationEntity?>?,
      landmarks: freezed == landmarks
          ? _value.landmarks
          : landmarks // ignore: cast_nullable_to_non_nullable
              as List<LandMarkEntity?>?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LocationEntity?,
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as GroupEntity?,
      geofence: freezed == geofence
          ? _value.geofence
          : geofence // ignore: cast_nullable_to_non_nullable
              as GeofenceEntity?,
      membersLocation: freezed == membersLocation
          ? _value.membersLocation
          : membersLocation // ignore: cast_nullable_to_non_nullable
              as List<UserLocationEntity?>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserEntityCopyWith<$Res>? get leader {
    if (_value.leader == null) {
      return null;
    }

    return $UserEntityCopyWith<$Res>(_value.leader!, (value) {
      return _then(_value.copyWith(leader: value) as $Val);
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

  @override
  @pragma('vm:prefer-inline')
  $GroupEntityCopyWith<$Res>? get group {
    if (_value.group == null) {
      return null;
    }

    return $GroupEntityCopyWith<$Res>(_value.group!, (value) {
      return _then(_value.copyWith(group: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $GeofenceEntityCopyWith<$Res>? get geofence {
    if (_value.geofence == null) {
      return null;
    }

    return $GeofenceEntityCopyWith<$Res>(_value.geofence!, (value) {
      return _then(_value.copyWith(geofence: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BeaconEntityImplCopyWith<$Res>
    implements $BeaconEntityCopyWith<$Res> {
  factory _$$BeaconEntityImplCopyWith(
          _$BeaconEntityImpl value, $Res Function(_$BeaconEntityImpl) then) =
      __$$BeaconEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? shortcode,
      int? startsAt,
      int? expiresAt,
      String? title,
      UserEntity? leader,
      List<UserEntity?>? followers,
      List<LocationEntity?>? route,
      List<LandMarkEntity?>? landmarks,
      LocationEntity? location,
      GroupEntity? group,
      GeofenceEntity? geofence,
      List<UserLocationEntity?>? membersLocation});

  @override
  $UserEntityCopyWith<$Res>? get leader;
  @override
  $LocationEntityCopyWith<$Res>? get location;
  @override
  $GroupEntityCopyWith<$Res>? get group;
  @override
  $GeofenceEntityCopyWith<$Res>? get geofence;
}

/// @nodoc
class __$$BeaconEntityImplCopyWithImpl<$Res>
    extends _$BeaconEntityCopyWithImpl<$Res, _$BeaconEntityImpl>
    implements _$$BeaconEntityImplCopyWith<$Res> {
  __$$BeaconEntityImplCopyWithImpl(
      _$BeaconEntityImpl _value, $Res Function(_$BeaconEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? shortcode = freezed,
    Object? startsAt = freezed,
    Object? expiresAt = freezed,
    Object? title = freezed,
    Object? leader = freezed,
    Object? followers = freezed,
    Object? route = freezed,
    Object? landmarks = freezed,
    Object? location = freezed,
    Object? group = freezed,
    Object? geofence = freezed,
    Object? membersLocation = freezed,
  }) {
    return _then(_$BeaconEntityImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      shortcode: freezed == shortcode
          ? _value.shortcode
          : shortcode // ignore: cast_nullable_to_non_nullable
              as String?,
      startsAt: freezed == startsAt
          ? _value.startsAt
          : startsAt // ignore: cast_nullable_to_non_nullable
              as int?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      leader: freezed == leader
          ? _value.leader
          : leader // ignore: cast_nullable_to_non_nullable
              as UserEntity?,
      followers: freezed == followers
          ? _value._followers
          : followers // ignore: cast_nullable_to_non_nullable
              as List<UserEntity?>?,
      route: freezed == route
          ? _value._route
          : route // ignore: cast_nullable_to_non_nullable
              as List<LocationEntity?>?,
      landmarks: freezed == landmarks
          ? _value._landmarks
          : landmarks // ignore: cast_nullable_to_non_nullable
              as List<LandMarkEntity?>?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LocationEntity?,
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as GroupEntity?,
      geofence: freezed == geofence
          ? _value.geofence
          : geofence // ignore: cast_nullable_to_non_nullable
              as GeofenceEntity?,
      membersLocation: freezed == membersLocation
          ? _value._membersLocation
          : membersLocation // ignore: cast_nullable_to_non_nullable
              as List<UserLocationEntity?>?,
    ));
  }
}

/// @nodoc

class _$BeaconEntityImpl implements _BeaconEntity {
  const _$BeaconEntityImpl(
      {this.id,
      this.shortcode,
      this.startsAt,
      this.expiresAt,
      this.title,
      this.leader,
      final List<UserEntity?>? followers,
      final List<LocationEntity?>? route,
      final List<LandMarkEntity?>? landmarks,
      this.location,
      this.group,
      this.geofence,
      final List<UserLocationEntity?>? membersLocation})
      : _followers = followers,
        _route = route,
        _landmarks = landmarks,
        _membersLocation = membersLocation;

  @override
  final String? id;
  @override
  final String? shortcode;
  @override
  final int? startsAt;
  @override
  final int? expiresAt;
  @override
  final String? title;
  @override
  final UserEntity? leader;
  final List<UserEntity?>? _followers;
  @override
  List<UserEntity?>? get followers {
    final value = _followers;
    if (value == null) return null;
    if (_followers is EqualUnmodifiableListView) return _followers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<LocationEntity?>? _route;
  @override
  List<LocationEntity?>? get route {
    final value = _route;
    if (value == null) return null;
    if (_route is EqualUnmodifiableListView) return _route;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<LandMarkEntity?>? _landmarks;
  @override
  List<LandMarkEntity?>? get landmarks {
    final value = _landmarks;
    if (value == null) return null;
    if (_landmarks is EqualUnmodifiableListView) return _landmarks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final LocationEntity? location;
  @override
  final GroupEntity? group;
  @override
  final GeofenceEntity? geofence;
  final List<UserLocationEntity?>? _membersLocation;
  @override
  List<UserLocationEntity?>? get membersLocation {
    final value = _membersLocation;
    if (value == null) return null;
    if (_membersLocation is EqualUnmodifiableListView) return _membersLocation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'BeaconEntity(id: $id, shortcode: $shortcode, startsAt: $startsAt, expiresAt: $expiresAt, title: $title, leader: $leader, followers: $followers, route: $route, landmarks: $landmarks, location: $location, group: $group, geofence: $geofence, membersLocation: $membersLocation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BeaconEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.shortcode, shortcode) ||
                other.shortcode == shortcode) &&
            (identical(other.startsAt, startsAt) ||
                other.startsAt == startsAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.leader, leader) || other.leader == leader) &&
            const DeepCollectionEquality()
                .equals(other._followers, _followers) &&
            const DeepCollectionEquality().equals(other._route, _route) &&
            const DeepCollectionEquality()
                .equals(other._landmarks, _landmarks) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.group, group) || other.group == group) &&
            (identical(other.geofence, geofence) ||
                other.geofence == geofence) &&
            const DeepCollectionEquality()
                .equals(other._membersLocation, _membersLocation));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      shortcode,
      startsAt,
      expiresAt,
      title,
      leader,
      const DeepCollectionEquality().hash(_followers),
      const DeepCollectionEquality().hash(_route),
      const DeepCollectionEquality().hash(_landmarks),
      location,
      group,
      geofence,
      const DeepCollectionEquality().hash(_membersLocation));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BeaconEntityImplCopyWith<_$BeaconEntityImpl> get copyWith =>
      __$$BeaconEntityImplCopyWithImpl<_$BeaconEntityImpl>(this, _$identity);
}

abstract class _BeaconEntity implements BeaconEntity {
  const factory _BeaconEntity(
      {final String? id,
      final String? shortcode,
      final int? startsAt,
      final int? expiresAt,
      final String? title,
      final UserEntity? leader,
      final List<UserEntity?>? followers,
      final List<LocationEntity?>? route,
      final List<LandMarkEntity?>? landmarks,
      final LocationEntity? location,
      final GroupEntity? group,
      final GeofenceEntity? geofence,
      final List<UserLocationEntity?>? membersLocation}) = _$BeaconEntityImpl;

  @override
  String? get id;
  @override
  String? get shortcode;
  @override
  int? get startsAt;
  @override
  int? get expiresAt;
  @override
  String? get title;
  @override
  UserEntity? get leader;
  @override
  List<UserEntity?>? get followers;
  @override
  List<LocationEntity?>? get route;
  @override
  List<LandMarkEntity?>? get landmarks;
  @override
  LocationEntity? get location;
  @override
  GroupEntity? get group;
  @override
  GeofenceEntity? get geofence;
  @override
  List<UserLocationEntity?>? get membersLocation;
  @override
  @JsonKey(ignore: true)
  _$$BeaconEntityImplCopyWith<_$BeaconEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
