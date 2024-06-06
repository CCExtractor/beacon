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
  String? get title => throw _privateConstructorUsedError;
  LocationEntity? get location => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LandMarkEntityCopyWith<LandMarkEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LandMarkEntityCopyWith<$Res> {
  factory $LandMarkEntityCopyWith(
          LandMarkEntity value, $Res Function(LandMarkEntity) then) =
      _$LandMarkEntityCopyWithImpl<$Res, LandMarkEntity>;
  @useResult
  $Res call({String? title, LocationEntity? location});

  $LocationEntityCopyWith<$Res>? get location;
}

/// @nodoc
class _$LandMarkEntityCopyWithImpl<$Res, $Val extends LandMarkEntity>
    implements $LandMarkEntityCopyWith<$Res> {
  _$LandMarkEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? location = freezed,
  }) {
    return _then(_value.copyWith(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$LandMarkEntityImplCopyWith<$Res>
    implements $LandMarkEntityCopyWith<$Res> {
  factory _$$LandMarkEntityImplCopyWith(_$LandMarkEntityImpl value,
          $Res Function(_$LandMarkEntityImpl) then) =
      __$$LandMarkEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? title, LocationEntity? location});

  @override
  $LocationEntityCopyWith<$Res>? get location;
}

/// @nodoc
class __$$LandMarkEntityImplCopyWithImpl<$Res>
    extends _$LandMarkEntityCopyWithImpl<$Res, _$LandMarkEntityImpl>
    implements _$$LandMarkEntityImplCopyWith<$Res> {
  __$$LandMarkEntityImplCopyWithImpl(
      _$LandMarkEntityImpl _value, $Res Function(_$LandMarkEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? location = freezed,
  }) {
    return _then(_$LandMarkEntityImpl(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LocationEntity?,
    ));
  }
}

/// @nodoc

class _$LandMarkEntityImpl implements _LandMarkEntity {
  const _$LandMarkEntityImpl({this.title, this.location});

  @override
  final String? title;
  @override
  final LocationEntity? location;

  @override
  String toString() {
    return 'LandMarkEntity(title: $title, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LandMarkEntityImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, location);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LandMarkEntityImplCopyWith<_$LandMarkEntityImpl> get copyWith =>
      __$$LandMarkEntityImplCopyWithImpl<_$LandMarkEntityImpl>(
          this, _$identity);
}

abstract class _LandMarkEntity implements LandMarkEntity {
  const factory _LandMarkEntity(
      {final String? title,
      final LocationEntity? location}) = _$LandMarkEntityImpl;

  @override
  String? get title;
  @override
  LocationEntity? get location;
  @override
  @JsonKey(ignore: true)
  _$$LandMarkEntityImplCopyWith<_$LandMarkEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
