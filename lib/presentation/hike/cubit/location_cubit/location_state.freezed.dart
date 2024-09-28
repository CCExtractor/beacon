// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LocationState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(
            MapType mapType,
            Set<Circle> geofence,
            Set<Marker> locationMarkers,
            Set<Polyline> polyline,
            String? message,
            int version)
        loaded,
    required TResult Function(String? message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(
            MapType mapType,
            Set<Circle> geofence,
            Set<Marker> locationMarkers,
            Set<Polyline> polyline,
            String? message,
            int version)?
        loaded,
    TResult? Function(String? message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(
            MapType mapType,
            Set<Circle> geofence,
            Set<Marker> locationMarkers,
            Set<Polyline> polyline,
            String? message,
            int version)?
        loaded,
    TResult Function(String? message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialLocationState value) initial,
    required TResult Function(LoadedLocationState value) loaded,
    required TResult Function(LocationErrorState value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialLocationState value)? initial,
    TResult? Function(LoadedLocationState value)? loaded,
    TResult? Function(LocationErrorState value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialLocationState value)? initial,
    TResult Function(LoadedLocationState value)? loaded,
    TResult Function(LocationErrorState value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationStateCopyWith<$Res> {
  factory $LocationStateCopyWith(
          LocationState value, $Res Function(LocationState) then) =
      _$LocationStateCopyWithImpl<$Res, LocationState>;
}

/// @nodoc
class _$LocationStateCopyWithImpl<$Res, $Val extends LocationState>
    implements $LocationStateCopyWith<$Res> {
  _$LocationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InitialLocationStateImplCopyWith<$Res> {
  factory _$$InitialLocationStateImplCopyWith(_$InitialLocationStateImpl value,
          $Res Function(_$InitialLocationStateImpl) then) =
      __$$InitialLocationStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialLocationStateImplCopyWithImpl<$Res>
    extends _$LocationStateCopyWithImpl<$Res, _$InitialLocationStateImpl>
    implements _$$InitialLocationStateImplCopyWith<$Res> {
  __$$InitialLocationStateImplCopyWithImpl(_$InitialLocationStateImpl _value,
      $Res Function(_$InitialLocationStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InitialLocationStateImpl implements InitialLocationState {
  _$InitialLocationStateImpl();

  @override
  String toString() {
    return 'LocationState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InitialLocationStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(
            MapType mapType,
            Set<Circle> geofence,
            Set<Marker> locationMarkers,
            Set<Polyline> polyline,
            String? message,
            int version)
        loaded,
    required TResult Function(String? message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(
            MapType mapType,
            Set<Circle> geofence,
            Set<Marker> locationMarkers,
            Set<Polyline> polyline,
            String? message,
            int version)?
        loaded,
    TResult? Function(String? message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(
            MapType mapType,
            Set<Circle> geofence,
            Set<Marker> locationMarkers,
            Set<Polyline> polyline,
            String? message,
            int version)?
        loaded,
    TResult Function(String? message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialLocationState value) initial,
    required TResult Function(LoadedLocationState value) loaded,
    required TResult Function(LocationErrorState value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialLocationState value)? initial,
    TResult? Function(LoadedLocationState value)? loaded,
    TResult? Function(LocationErrorState value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialLocationState value)? initial,
    TResult Function(LoadedLocationState value)? loaded,
    TResult Function(LocationErrorState value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class InitialLocationState implements LocationState {
  factory InitialLocationState() = _$InitialLocationStateImpl;
}

/// @nodoc
abstract class _$$LoadedLocationStateImplCopyWith<$Res> {
  factory _$$LoadedLocationStateImplCopyWith(_$LoadedLocationStateImpl value,
          $Res Function(_$LoadedLocationStateImpl) then) =
      __$$LoadedLocationStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {MapType mapType,
      Set<Circle> geofence,
      Set<Marker> locationMarkers,
      Set<Polyline> polyline,
      String? message,
      int version});
}

/// @nodoc
class __$$LoadedLocationStateImplCopyWithImpl<$Res>
    extends _$LocationStateCopyWithImpl<$Res, _$LoadedLocationStateImpl>
    implements _$$LoadedLocationStateImplCopyWith<$Res> {
  __$$LoadedLocationStateImplCopyWithImpl(_$LoadedLocationStateImpl _value,
      $Res Function(_$LoadedLocationStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mapType = null,
    Object? geofence = null,
    Object? locationMarkers = null,
    Object? polyline = null,
    Object? message = freezed,
    Object? version = null,
  }) {
    return _then(_$LoadedLocationStateImpl(
      mapType: null == mapType
          ? _value.mapType
          : mapType // ignore: cast_nullable_to_non_nullable
              as MapType,
      geofence: null == geofence
          ? _value._geofence
          : geofence // ignore: cast_nullable_to_non_nullable
              as Set<Circle>,
      locationMarkers: null == locationMarkers
          ? _value._locationMarkers
          : locationMarkers // ignore: cast_nullable_to_non_nullable
              as Set<Marker>,
      polyline: null == polyline
          ? _value._polyline
          : polyline // ignore: cast_nullable_to_non_nullable
              as Set<Polyline>,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$LoadedLocationStateImpl implements LoadedLocationState {
  _$LoadedLocationStateImpl(
      {this.mapType = MapType.normal,
      final Set<Circle> geofence = const {},
      final Set<Marker> locationMarkers = const {},
      final Set<Polyline> polyline = const {},
      this.message,
      this.version = 0})
      : _geofence = geofence,
        _locationMarkers = locationMarkers,
        _polyline = polyline;

  @override
  @JsonKey()
  final MapType mapType;
  final Set<Circle> _geofence;
  @override
  @JsonKey()
  Set<Circle> get geofence {
    if (_geofence is EqualUnmodifiableSetView) return _geofence;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_geofence);
  }

  final Set<Marker> _locationMarkers;
  @override
  @JsonKey()
  Set<Marker> get locationMarkers {
    if (_locationMarkers is EqualUnmodifiableSetView) return _locationMarkers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_locationMarkers);
  }

  final Set<Polyline> _polyline;
  @override
  @JsonKey()
  Set<Polyline> get polyline {
    if (_polyline is EqualUnmodifiableSetView) return _polyline;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_polyline);
  }

  @override
  final String? message;
  @override
  @JsonKey()
  final int version;

  @override
  String toString() {
    return 'LocationState.loaded(mapType: $mapType, geofence: $geofence, locationMarkers: $locationMarkers, polyline: $polyline, message: $message, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadedLocationStateImpl &&
            (identical(other.mapType, mapType) || other.mapType == mapType) &&
            const DeepCollectionEquality().equals(other._geofence, _geofence) &&
            const DeepCollectionEquality()
                .equals(other._locationMarkers, _locationMarkers) &&
            const DeepCollectionEquality().equals(other._polyline, _polyline) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.version, version) || other.version == version));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      mapType,
      const DeepCollectionEquality().hash(_geofence),
      const DeepCollectionEquality().hash(_locationMarkers),
      const DeepCollectionEquality().hash(_polyline),
      message,
      version);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadedLocationStateImplCopyWith<_$LoadedLocationStateImpl> get copyWith =>
      __$$LoadedLocationStateImplCopyWithImpl<_$LoadedLocationStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(
            MapType mapType,
            Set<Circle> geofence,
            Set<Marker> locationMarkers,
            Set<Polyline> polyline,
            String? message,
            int version)
        loaded,
    required TResult Function(String? message) error,
  }) {
    return loaded(
        mapType, geofence, locationMarkers, polyline, message, version);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(
            MapType mapType,
            Set<Circle> geofence,
            Set<Marker> locationMarkers,
            Set<Polyline> polyline,
            String? message,
            int version)?
        loaded,
    TResult? Function(String? message)? error,
  }) {
    return loaded?.call(
        mapType, geofence, locationMarkers, polyline, message, version);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(
            MapType mapType,
            Set<Circle> geofence,
            Set<Marker> locationMarkers,
            Set<Polyline> polyline,
            String? message,
            int version)?
        loaded,
    TResult Function(String? message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(
          mapType, geofence, locationMarkers, polyline, message, version);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialLocationState value) initial,
    required TResult Function(LoadedLocationState value) loaded,
    required TResult Function(LocationErrorState value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialLocationState value)? initial,
    TResult? Function(LoadedLocationState value)? loaded,
    TResult? Function(LocationErrorState value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialLocationState value)? initial,
    TResult Function(LoadedLocationState value)? loaded,
    TResult Function(LocationErrorState value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class LoadedLocationState implements LocationState {
  factory LoadedLocationState(
      {final MapType mapType,
      final Set<Circle> geofence,
      final Set<Marker> locationMarkers,
      final Set<Polyline> polyline,
      final String? message,
      final int version}) = _$LoadedLocationStateImpl;

  MapType get mapType;
  Set<Circle> get geofence;
  Set<Marker> get locationMarkers;
  Set<Polyline> get polyline;
  String? get message;
  int get version;
  @JsonKey(ignore: true)
  _$$LoadedLocationStateImplCopyWith<_$LoadedLocationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LocationErrorStateImplCopyWith<$Res> {
  factory _$$LocationErrorStateImplCopyWith(_$LocationErrorStateImpl value,
          $Res Function(_$LocationErrorStateImpl) then) =
      __$$LocationErrorStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$LocationErrorStateImplCopyWithImpl<$Res>
    extends _$LocationStateCopyWithImpl<$Res, _$LocationErrorStateImpl>
    implements _$$LocationErrorStateImplCopyWith<$Res> {
  __$$LocationErrorStateImplCopyWithImpl(_$LocationErrorStateImpl _value,
      $Res Function(_$LocationErrorStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$LocationErrorStateImpl(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$LocationErrorStateImpl implements LocationErrorState {
  _$LocationErrorStateImpl({this.message});

  @override
  final String? message;

  @override
  String toString() {
    return 'LocationState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationErrorStateImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationErrorStateImplCopyWith<_$LocationErrorStateImpl> get copyWith =>
      __$$LocationErrorStateImplCopyWithImpl<_$LocationErrorStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(
            MapType mapType,
            Set<Circle> geofence,
            Set<Marker> locationMarkers,
            Set<Polyline> polyline,
            String? message,
            int version)
        loaded,
    required TResult Function(String? message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(
            MapType mapType,
            Set<Circle> geofence,
            Set<Marker> locationMarkers,
            Set<Polyline> polyline,
            String? message,
            int version)?
        loaded,
    TResult? Function(String? message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(
            MapType mapType,
            Set<Circle> geofence,
            Set<Marker> locationMarkers,
            Set<Polyline> polyline,
            String? message,
            int version)?
        loaded,
    TResult Function(String? message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialLocationState value) initial,
    required TResult Function(LoadedLocationState value) loaded,
    required TResult Function(LocationErrorState value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialLocationState value)? initial,
    TResult? Function(LoadedLocationState value)? loaded,
    TResult? Function(LocationErrorState value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialLocationState value)? initial,
    TResult Function(LoadedLocationState value)? loaded,
    TResult Function(LocationErrorState value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class LocationErrorState implements LocationState {
  factory LocationErrorState({final String? message}) =
      _$LocationErrorStateImpl;

  String? get message;
  @JsonKey(ignore: true)
  _$$LocationErrorStateImplCopyWith<_$LocationErrorStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
