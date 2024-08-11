// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geofence_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GeofenceEntity {
  LocationEntity? get center => throw _privateConstructorUsedError;
  double? get radius => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GeofenceEntityCopyWith<GeofenceEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeofenceEntityCopyWith<$Res> {
  factory $GeofenceEntityCopyWith(
          GeofenceEntity value, $Res Function(GeofenceEntity) then) =
      _$GeofenceEntityCopyWithImpl<$Res, GeofenceEntity>;
  @useResult
  $Res call({LocationEntity? center, double? radius});

  $LocationEntityCopyWith<$Res>? get center;
}

/// @nodoc
class _$GeofenceEntityCopyWithImpl<$Res, $Val extends GeofenceEntity>
    implements $GeofenceEntityCopyWith<$Res> {
  _$GeofenceEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? center = freezed,
    Object? radius = freezed,
  }) {
    return _then(_value.copyWith(
      center: freezed == center
          ? _value.center
          : center // ignore: cast_nullable_to_non_nullable
              as LocationEntity?,
      radius: freezed == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LocationEntityCopyWith<$Res>? get center {
    if (_value.center == null) {
      return null;
    }

    return $LocationEntityCopyWith<$Res>(_value.center!, (value) {
      return _then(_value.copyWith(center: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GeofenceEntityImplCopyWith<$Res>
    implements $GeofenceEntityCopyWith<$Res> {
  factory _$$GeofenceEntityImplCopyWith(_$GeofenceEntityImpl value,
          $Res Function(_$GeofenceEntityImpl) then) =
      __$$GeofenceEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LocationEntity? center, double? radius});

  @override
  $LocationEntityCopyWith<$Res>? get center;
}

/// @nodoc
class __$$GeofenceEntityImplCopyWithImpl<$Res>
    extends _$GeofenceEntityCopyWithImpl<$Res, _$GeofenceEntityImpl>
    implements _$$GeofenceEntityImplCopyWith<$Res> {
  __$$GeofenceEntityImplCopyWithImpl(
      _$GeofenceEntityImpl _value, $Res Function(_$GeofenceEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? center = freezed,
    Object? radius = freezed,
  }) {
    return _then(_$GeofenceEntityImpl(
      center: freezed == center
          ? _value.center
          : center // ignore: cast_nullable_to_non_nullable
              as LocationEntity?,
      radius: freezed == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc

class _$GeofenceEntityImpl implements _GeofenceEntity {
  _$GeofenceEntityImpl({this.center, this.radius});

  @override
  final LocationEntity? center;
  @override
  final double? radius;

  @override
  String toString() {
    return 'GeofenceEntity(center: $center, radius: $radius)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeofenceEntityImpl &&
            (identical(other.center, center) || other.center == center) &&
            (identical(other.radius, radius) || other.radius == radius));
  }

  @override
  int get hashCode => Object.hash(runtimeType, center, radius);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GeofenceEntityImplCopyWith<_$GeofenceEntityImpl> get copyWith =>
      __$$GeofenceEntityImplCopyWithImpl<_$GeofenceEntityImpl>(
          this, _$identity);
}

abstract class _GeofenceEntity implements GeofenceEntity {
  factory _GeofenceEntity(
      {final LocationEntity? center,
      final double? radius}) = _$GeofenceEntityImpl;

  @override
  LocationEntity? get center;
  @override
  double? get radius;
  @override
  @JsonKey(ignore: true)
  _$$GeofenceEntityImplCopyWith<_$GeofenceEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
