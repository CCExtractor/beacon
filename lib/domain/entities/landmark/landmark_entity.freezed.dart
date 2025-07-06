// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'landmark_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LandMarkEntity {
  String? get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  LocationEntity? get location => throw _privateConstructorUsedError;
  UserEntity? get createdBy => throw _privateConstructorUsedError;

  /// Create a copy of LandMarkEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LandMarkEntityCopyWith<LandMarkEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LandMarkEntityCopyWith<$Res> {
  factory $LandMarkEntityCopyWith(
          LandMarkEntity value, $Res Function(LandMarkEntity) then) =
      _$LandMarkEntityCopyWithImpl<$Res, LandMarkEntity>;
  @useResult
  $Res call(
      {String? id,
      String? title,
      String? icon,
      LocationEntity? location,
      UserEntity? createdBy});

  $LocationEntityCopyWith<$Res>? get location;
  $UserEntityCopyWith<$Res>? get createdBy;
}

/// @nodoc
class _$LandMarkEntityCopyWithImpl<$Res, $Val extends LandMarkEntity>
    implements $LandMarkEntityCopyWith<$Res> {
  _$LandMarkEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LandMarkEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? icon = freezed,
    Object? location = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LocationEntity?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as UserEntity?,
    ) as $Val);
  }

  /// Create a copy of LandMarkEntity
  /// with the given fields replaced by the non-null parameter values.
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

  /// Create a copy of LandMarkEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserEntityCopyWith<$Res>? get createdBy {
    if (_value.createdBy == null) {
      return null;
    }

    return $UserEntityCopyWith<$Res>(_value.createdBy!, (value) {
      return _then(_value.copyWith(createdBy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LandMarkEntityImplCopyWith<$Res>
    implements $LandMarkEntityCopyWith<$Res> {
  factory _$$LandMarkEntityImplCopyWith(_$LandMarkEntityImpl value,
          $Res Function(_$LandMarkEntityImpl) then) =
      __$$LandMarkEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? title,
      String? icon,
      LocationEntity? location,
      UserEntity? createdBy});

  @override
  $LocationEntityCopyWith<$Res>? get location;
  @override
  $UserEntityCopyWith<$Res>? get createdBy;
}

/// @nodoc
class __$$LandMarkEntityImplCopyWithImpl<$Res>
    extends _$LandMarkEntityCopyWithImpl<$Res, _$LandMarkEntityImpl>
    implements _$$LandMarkEntityImplCopyWith<$Res> {
  __$$LandMarkEntityImplCopyWithImpl(
      _$LandMarkEntityImpl _value, $Res Function(_$LandMarkEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of LandMarkEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? icon = freezed,
    Object? location = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_$LandMarkEntityImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LocationEntity?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as UserEntity?,
    ));
  }
}

/// @nodoc

class _$LandMarkEntityImpl implements _LandMarkEntity {
  const _$LandMarkEntityImpl(
      {this.id, this.title, this.icon, this.location, this.createdBy});

  @override
  final String? id;
  @override
  final String? title;
  @override
  final String? icon;
  @override
  final LocationEntity? location;
  @override
  final UserEntity? createdBy;

  @override
  String toString() {
    return 'LandMarkEntity(id: $id, title: $title, icon: $icon, location: $location, createdBy: $createdBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LandMarkEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, icon, location, createdBy);

  /// Create a copy of LandMarkEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LandMarkEntityImplCopyWith<_$LandMarkEntityImpl> get copyWith =>
      __$$LandMarkEntityImplCopyWithImpl<_$LandMarkEntityImpl>(
          this, _$identity);
}

abstract class _LandMarkEntity implements LandMarkEntity {
  const factory _LandMarkEntity(
      {final String? id,
      final String? title,
      final String? icon,
      final LocationEntity? location,
      final UserEntity? createdBy}) = _$LandMarkEntityImpl;

  @override
  String? get id;
  @override
  String? get title;
  @override
  String? get icon;
  @override
  LocationEntity? get location;
  @override
  UserEntity? get createdBy;

  /// Create a copy of LandMarkEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LandMarkEntityImplCopyWith<_$LandMarkEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
