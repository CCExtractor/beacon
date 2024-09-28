// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GroupEntity {
  String? get id => throw _privateConstructorUsedError;
  List<BeaconEntity?>? get beacons => throw _privateConstructorUsedError;
  List<UserEntity?>? get members => throw _privateConstructorUsedError;
  UserEntity? get leader => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get shortcode => throw _privateConstructorUsedError;
  bool get hasBeaconActivity => throw _privateConstructorUsedError;
  bool get hasMemberActivity => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GroupEntityCopyWith<GroupEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupEntityCopyWith<$Res> {
  factory $GroupEntityCopyWith(
          GroupEntity value, $Res Function(GroupEntity) then) =
      _$GroupEntityCopyWithImpl<$Res, GroupEntity>;
  @useResult
  $Res call(
      {String? id,
      List<BeaconEntity?>? beacons,
      List<UserEntity?>? members,
      UserEntity? leader,
      String? title,
      String? shortcode,
      bool hasBeaconActivity,
      bool hasMemberActivity});

  $UserEntityCopyWith<$Res>? get leader;
}

/// @nodoc
class _$GroupEntityCopyWithImpl<$Res, $Val extends GroupEntity>
    implements $GroupEntityCopyWith<$Res> {
  _$GroupEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? beacons = freezed,
    Object? members = freezed,
    Object? leader = freezed,
    Object? title = freezed,
    Object? shortcode = freezed,
    Object? hasBeaconActivity = null,
    Object? hasMemberActivity = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      beacons: freezed == beacons
          ? _value.beacons
          : beacons // ignore: cast_nullable_to_non_nullable
              as List<BeaconEntity?>?,
      members: freezed == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<UserEntity?>?,
      leader: freezed == leader
          ? _value.leader
          : leader // ignore: cast_nullable_to_non_nullable
              as UserEntity?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      shortcode: freezed == shortcode
          ? _value.shortcode
          : shortcode // ignore: cast_nullable_to_non_nullable
              as String?,
      hasBeaconActivity: null == hasBeaconActivity
          ? _value.hasBeaconActivity
          : hasBeaconActivity // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMemberActivity: null == hasMemberActivity
          ? _value.hasMemberActivity
          : hasMemberActivity // ignore: cast_nullable_to_non_nullable
              as bool,
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
}

/// @nodoc
abstract class _$$GroupEntityImplCopyWith<$Res>
    implements $GroupEntityCopyWith<$Res> {
  factory _$$GroupEntityImplCopyWith(
          _$GroupEntityImpl value, $Res Function(_$GroupEntityImpl) then) =
      __$$GroupEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      List<BeaconEntity?>? beacons,
      List<UserEntity?>? members,
      UserEntity? leader,
      String? title,
      String? shortcode,
      bool hasBeaconActivity,
      bool hasMemberActivity});

  @override
  $UserEntityCopyWith<$Res>? get leader;
}

/// @nodoc
class __$$GroupEntityImplCopyWithImpl<$Res>
    extends _$GroupEntityCopyWithImpl<$Res, _$GroupEntityImpl>
    implements _$$GroupEntityImplCopyWith<$Res> {
  __$$GroupEntityImplCopyWithImpl(
      _$GroupEntityImpl _value, $Res Function(_$GroupEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? beacons = freezed,
    Object? members = freezed,
    Object? leader = freezed,
    Object? title = freezed,
    Object? shortcode = freezed,
    Object? hasBeaconActivity = null,
    Object? hasMemberActivity = null,
  }) {
    return _then(_$GroupEntityImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      beacons: freezed == beacons
          ? _value._beacons
          : beacons // ignore: cast_nullable_to_non_nullable
              as List<BeaconEntity?>?,
      members: freezed == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<UserEntity?>?,
      leader: freezed == leader
          ? _value.leader
          : leader // ignore: cast_nullable_to_non_nullable
              as UserEntity?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      shortcode: freezed == shortcode
          ? _value.shortcode
          : shortcode // ignore: cast_nullable_to_non_nullable
              as String?,
      hasBeaconActivity: null == hasBeaconActivity
          ? _value.hasBeaconActivity
          : hasBeaconActivity // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMemberActivity: null == hasMemberActivity
          ? _value.hasMemberActivity
          : hasMemberActivity // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$GroupEntityImpl implements _GroupEntity {
  const _$GroupEntityImpl(
      {this.id,
      final List<BeaconEntity?>? beacons,
      final List<UserEntity?>? members,
      this.leader,
      this.title,
      this.shortcode,
      this.hasBeaconActivity = false,
      this.hasMemberActivity = false})
      : _beacons = beacons,
        _members = members;

  @override
  final String? id;
  final List<BeaconEntity?>? _beacons;
  @override
  List<BeaconEntity?>? get beacons {
    final value = _beacons;
    if (value == null) return null;
    if (_beacons is EqualUnmodifiableListView) return _beacons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<UserEntity?>? _members;
  @override
  List<UserEntity?>? get members {
    final value = _members;
    if (value == null) return null;
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final UserEntity? leader;
  @override
  final String? title;
  @override
  final String? shortcode;
  @override
  @JsonKey()
  final bool hasBeaconActivity;
  @override
  @JsonKey()
  final bool hasMemberActivity;

  @override
  String toString() {
    return 'GroupEntity(id: $id, beacons: $beacons, members: $members, leader: $leader, title: $title, shortcode: $shortcode, hasBeaconActivity: $hasBeaconActivity, hasMemberActivity: $hasMemberActivity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._beacons, _beacons) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            (identical(other.leader, leader) || other.leader == leader) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.shortcode, shortcode) ||
                other.shortcode == shortcode) &&
            (identical(other.hasBeaconActivity, hasBeaconActivity) ||
                other.hasBeaconActivity == hasBeaconActivity) &&
            (identical(other.hasMemberActivity, hasMemberActivity) ||
                other.hasMemberActivity == hasMemberActivity));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(_beacons),
      const DeepCollectionEquality().hash(_members),
      leader,
      title,
      shortcode,
      hasBeaconActivity,
      hasMemberActivity);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupEntityImplCopyWith<_$GroupEntityImpl> get copyWith =>
      __$$GroupEntityImplCopyWithImpl<_$GroupEntityImpl>(this, _$identity);
}

abstract class _GroupEntity implements GroupEntity {
  const factory _GroupEntity(
      {final String? id,
      final List<BeaconEntity?>? beacons,
      final List<UserEntity?>? members,
      final UserEntity? leader,
      final String? title,
      final String? shortcode,
      final bool hasBeaconActivity,
      final bool hasMemberActivity}) = _$GroupEntityImpl;

  @override
  String? get id;
  @override
  List<BeaconEntity?>? get beacons;
  @override
  List<UserEntity?>? get members;
  @override
  UserEntity? get leader;
  @override
  String? get title;
  @override
  String? get shortcode;
  @override
  bool get hasBeaconActivity;
  @override
  bool get hasMemberActivity;
  @override
  @JsonKey(ignore: true)
  _$$GroupEntityImplCopyWith<_$GroupEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
