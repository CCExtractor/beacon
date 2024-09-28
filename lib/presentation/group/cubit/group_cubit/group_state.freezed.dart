// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GroupState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() shrimmer,
    required TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters type,
            List<BeaconEntity> beacons,
            int version)
        allBeacon,
    required TResult Function(String? message, filters type,
            List<BeaconEntity> beacons, double radius, int version)
        nearbyBeacon,
    required TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters? type,
            List<BeaconEntity> beacons,
            int version)
        statusFilterBeacon,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? shrimmer,
    TResult? Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters type,
            List<BeaconEntity> beacons,
            int version)?
        allBeacon,
    TResult? Function(String? message, filters type, List<BeaconEntity> beacons,
            double radius, int version)?
        nearbyBeacon,
    TResult? Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters? type,
            List<BeaconEntity> beacons,
            int version)?
        statusFilterBeacon,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? shrimmer,
    TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters type,
            List<BeaconEntity> beacons,
            int version)?
        allBeacon,
    TResult Function(String? message, filters type, List<BeaconEntity> beacons,
            double radius, int version)?
        nearbyBeacon,
    TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters? type,
            List<BeaconEntity> beacons,
            int version)?
        statusFilterBeacon,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialGroupState value) initial,
    required TResult Function(LoadingGroupState value) loading,
    required TResult Function(ShrimmerGroupState value) shrimmer,
    required TResult Function(AllBeaconGroupState value) allBeacon,
    required TResult Function(NearbyBeaconGroupState value) nearbyBeacon,
    required TResult Function(StatusFilterBeaconGroupState value)
        statusFilterBeacon,
    required TResult Function(ErrorGroupState value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialGroupState value)? initial,
    TResult? Function(LoadingGroupState value)? loading,
    TResult? Function(ShrimmerGroupState value)? shrimmer,
    TResult? Function(AllBeaconGroupState value)? allBeacon,
    TResult? Function(NearbyBeaconGroupState value)? nearbyBeacon,
    TResult? Function(StatusFilterBeaconGroupState value)? statusFilterBeacon,
    TResult? Function(ErrorGroupState value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialGroupState value)? initial,
    TResult Function(LoadingGroupState value)? loading,
    TResult Function(ShrimmerGroupState value)? shrimmer,
    TResult Function(AllBeaconGroupState value)? allBeacon,
    TResult Function(NearbyBeaconGroupState value)? nearbyBeacon,
    TResult Function(StatusFilterBeaconGroupState value)? statusFilterBeacon,
    TResult Function(ErrorGroupState value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupStateCopyWith<$Res> {
  factory $GroupStateCopyWith(
          GroupState value, $Res Function(GroupState) then) =
      _$GroupStateCopyWithImpl<$Res, GroupState>;
}

/// @nodoc
class _$GroupStateCopyWithImpl<$Res, $Val extends GroupState>
    implements $GroupStateCopyWith<$Res> {
  _$GroupStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InitialGroupStateImplCopyWith<$Res> {
  factory _$$InitialGroupStateImplCopyWith(_$InitialGroupStateImpl value,
          $Res Function(_$InitialGroupStateImpl) then) =
      __$$InitialGroupStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialGroupStateImplCopyWithImpl<$Res>
    extends _$GroupStateCopyWithImpl<$Res, _$InitialGroupStateImpl>
    implements _$$InitialGroupStateImplCopyWith<$Res> {
  __$$InitialGroupStateImplCopyWithImpl(_$InitialGroupStateImpl _value,
      $Res Function(_$InitialGroupStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InitialGroupStateImpl implements InitialGroupState {
  const _$InitialGroupStateImpl();

  @override
  String toString() {
    return 'GroupState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialGroupStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() shrimmer,
    required TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters type,
            List<BeaconEntity> beacons,
            int version)
        allBeacon,
    required TResult Function(String? message, filters type,
            List<BeaconEntity> beacons, double radius, int version)
        nearbyBeacon,
    required TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters? type,
            List<BeaconEntity> beacons,
            int version)
        statusFilterBeacon,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? shrimmer,
    TResult? Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters type,
            List<BeaconEntity> beacons,
            int version)?
        allBeacon,
    TResult? Function(String? message, filters type, List<BeaconEntity> beacons,
            double radius, int version)?
        nearbyBeacon,
    TResult? Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters? type,
            List<BeaconEntity> beacons,
            int version)?
        statusFilterBeacon,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? shrimmer,
    TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters type,
            List<BeaconEntity> beacons,
            int version)?
        allBeacon,
    TResult Function(String? message, filters type, List<BeaconEntity> beacons,
            double radius, int version)?
        nearbyBeacon,
    TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters? type,
            List<BeaconEntity> beacons,
            int version)?
        statusFilterBeacon,
    TResult Function(String message)? error,
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
    required TResult Function(InitialGroupState value) initial,
    required TResult Function(LoadingGroupState value) loading,
    required TResult Function(ShrimmerGroupState value) shrimmer,
    required TResult Function(AllBeaconGroupState value) allBeacon,
    required TResult Function(NearbyBeaconGroupState value) nearbyBeacon,
    required TResult Function(StatusFilterBeaconGroupState value)
        statusFilterBeacon,
    required TResult Function(ErrorGroupState value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialGroupState value)? initial,
    TResult? Function(LoadingGroupState value)? loading,
    TResult? Function(ShrimmerGroupState value)? shrimmer,
    TResult? Function(AllBeaconGroupState value)? allBeacon,
    TResult? Function(NearbyBeaconGroupState value)? nearbyBeacon,
    TResult? Function(StatusFilterBeaconGroupState value)? statusFilterBeacon,
    TResult? Function(ErrorGroupState value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialGroupState value)? initial,
    TResult Function(LoadingGroupState value)? loading,
    TResult Function(ShrimmerGroupState value)? shrimmer,
    TResult Function(AllBeaconGroupState value)? allBeacon,
    TResult Function(NearbyBeaconGroupState value)? nearbyBeacon,
    TResult Function(StatusFilterBeaconGroupState value)? statusFilterBeacon,
    TResult Function(ErrorGroupState value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class InitialGroupState implements GroupState {
  const factory InitialGroupState() = _$InitialGroupStateImpl;
}

/// @nodoc
abstract class _$$LoadingGroupStateImplCopyWith<$Res> {
  factory _$$LoadingGroupStateImplCopyWith(_$LoadingGroupStateImpl value,
          $Res Function(_$LoadingGroupStateImpl) then) =
      __$$LoadingGroupStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingGroupStateImplCopyWithImpl<$Res>
    extends _$GroupStateCopyWithImpl<$Res, _$LoadingGroupStateImpl>
    implements _$$LoadingGroupStateImplCopyWith<$Res> {
  __$$LoadingGroupStateImplCopyWithImpl(_$LoadingGroupStateImpl _value,
      $Res Function(_$LoadingGroupStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadingGroupStateImpl implements LoadingGroupState {
  const _$LoadingGroupStateImpl();

  @override
  String toString() {
    return 'GroupState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingGroupStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() shrimmer,
    required TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters type,
            List<BeaconEntity> beacons,
            int version)
        allBeacon,
    required TResult Function(String? message, filters type,
            List<BeaconEntity> beacons, double radius, int version)
        nearbyBeacon,
    required TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters? type,
            List<BeaconEntity> beacons,
            int version)
        statusFilterBeacon,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? shrimmer,
    TResult? Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters type,
            List<BeaconEntity> beacons,
            int version)?
        allBeacon,
    TResult? Function(String? message, filters type, List<BeaconEntity> beacons,
            double radius, int version)?
        nearbyBeacon,
    TResult? Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters? type,
            List<BeaconEntity> beacons,
            int version)?
        statusFilterBeacon,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? shrimmer,
    TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters type,
            List<BeaconEntity> beacons,
            int version)?
        allBeacon,
    TResult Function(String? message, filters type, List<BeaconEntity> beacons,
            double radius, int version)?
        nearbyBeacon,
    TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters? type,
            List<BeaconEntity> beacons,
            int version)?
        statusFilterBeacon,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialGroupState value) initial,
    required TResult Function(LoadingGroupState value) loading,
    required TResult Function(ShrimmerGroupState value) shrimmer,
    required TResult Function(AllBeaconGroupState value) allBeacon,
    required TResult Function(NearbyBeaconGroupState value) nearbyBeacon,
    required TResult Function(StatusFilterBeaconGroupState value)
        statusFilterBeacon,
    required TResult Function(ErrorGroupState value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialGroupState value)? initial,
    TResult? Function(LoadingGroupState value)? loading,
    TResult? Function(ShrimmerGroupState value)? shrimmer,
    TResult? Function(AllBeaconGroupState value)? allBeacon,
    TResult? Function(NearbyBeaconGroupState value)? nearbyBeacon,
    TResult? Function(StatusFilterBeaconGroupState value)? statusFilterBeacon,
    TResult? Function(ErrorGroupState value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialGroupState value)? initial,
    TResult Function(LoadingGroupState value)? loading,
    TResult Function(ShrimmerGroupState value)? shrimmer,
    TResult Function(AllBeaconGroupState value)? allBeacon,
    TResult Function(NearbyBeaconGroupState value)? nearbyBeacon,
    TResult Function(StatusFilterBeaconGroupState value)? statusFilterBeacon,
    TResult Function(ErrorGroupState value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class LoadingGroupState implements GroupState {
  const factory LoadingGroupState() = _$LoadingGroupStateImpl;
}

/// @nodoc
abstract class _$$ShrimmerGroupStateImplCopyWith<$Res> {
  factory _$$ShrimmerGroupStateImplCopyWith(_$ShrimmerGroupStateImpl value,
          $Res Function(_$ShrimmerGroupStateImpl) then) =
      __$$ShrimmerGroupStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ShrimmerGroupStateImplCopyWithImpl<$Res>
    extends _$GroupStateCopyWithImpl<$Res, _$ShrimmerGroupStateImpl>
    implements _$$ShrimmerGroupStateImplCopyWith<$Res> {
  __$$ShrimmerGroupStateImplCopyWithImpl(_$ShrimmerGroupStateImpl _value,
      $Res Function(_$ShrimmerGroupStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ShrimmerGroupStateImpl implements ShrimmerGroupState {
  const _$ShrimmerGroupStateImpl();

  @override
  String toString() {
    return 'GroupState.shrimmer()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ShrimmerGroupStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() shrimmer,
    required TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters type,
            List<BeaconEntity> beacons,
            int version)
        allBeacon,
    required TResult Function(String? message, filters type,
            List<BeaconEntity> beacons, double radius, int version)
        nearbyBeacon,
    required TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters? type,
            List<BeaconEntity> beacons,
            int version)
        statusFilterBeacon,
    required TResult Function(String message) error,
  }) {
    return shrimmer();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? shrimmer,
    TResult? Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters type,
            List<BeaconEntity> beacons,
            int version)?
        allBeacon,
    TResult? Function(String? message, filters type, List<BeaconEntity> beacons,
            double radius, int version)?
        nearbyBeacon,
    TResult? Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters? type,
            List<BeaconEntity> beacons,
            int version)?
        statusFilterBeacon,
    TResult? Function(String message)? error,
  }) {
    return shrimmer?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? shrimmer,
    TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters type,
            List<BeaconEntity> beacons,
            int version)?
        allBeacon,
    TResult Function(String? message, filters type, List<BeaconEntity> beacons,
            double radius, int version)?
        nearbyBeacon,
    TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters? type,
            List<BeaconEntity> beacons,
            int version)?
        statusFilterBeacon,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (shrimmer != null) {
      return shrimmer();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialGroupState value) initial,
    required TResult Function(LoadingGroupState value) loading,
    required TResult Function(ShrimmerGroupState value) shrimmer,
    required TResult Function(AllBeaconGroupState value) allBeacon,
    required TResult Function(NearbyBeaconGroupState value) nearbyBeacon,
    required TResult Function(StatusFilterBeaconGroupState value)
        statusFilterBeacon,
    required TResult Function(ErrorGroupState value) error,
  }) {
    return shrimmer(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialGroupState value)? initial,
    TResult? Function(LoadingGroupState value)? loading,
    TResult? Function(ShrimmerGroupState value)? shrimmer,
    TResult? Function(AllBeaconGroupState value)? allBeacon,
    TResult? Function(NearbyBeaconGroupState value)? nearbyBeacon,
    TResult? Function(StatusFilterBeaconGroupState value)? statusFilterBeacon,
    TResult? Function(ErrorGroupState value)? error,
  }) {
    return shrimmer?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialGroupState value)? initial,
    TResult Function(LoadingGroupState value)? loading,
    TResult Function(ShrimmerGroupState value)? shrimmer,
    TResult Function(AllBeaconGroupState value)? allBeacon,
    TResult Function(NearbyBeaconGroupState value)? nearbyBeacon,
    TResult Function(StatusFilterBeaconGroupState value)? statusFilterBeacon,
    TResult Function(ErrorGroupState value)? error,
    required TResult orElse(),
  }) {
    if (shrimmer != null) {
      return shrimmer(this);
    }
    return orElse();
  }
}

abstract class ShrimmerGroupState implements GroupState {
  const factory ShrimmerGroupState() = _$ShrimmerGroupStateImpl;
}

/// @nodoc
abstract class _$$AllBeaconGroupStateImplCopyWith<$Res> {
  factory _$$AllBeaconGroupStateImplCopyWith(_$AllBeaconGroupStateImpl value,
          $Res Function(_$AllBeaconGroupStateImpl) then) =
      __$$AllBeaconGroupStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {bool isLoadingMore,
      bool isCompletelyFetched,
      String? message,
      filters type,
      List<BeaconEntity> beacons,
      int version});
}

/// @nodoc
class __$$AllBeaconGroupStateImplCopyWithImpl<$Res>
    extends _$GroupStateCopyWithImpl<$Res, _$AllBeaconGroupStateImpl>
    implements _$$AllBeaconGroupStateImplCopyWith<$Res> {
  __$$AllBeaconGroupStateImplCopyWithImpl(_$AllBeaconGroupStateImpl _value,
      $Res Function(_$AllBeaconGroupStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoadingMore = null,
    Object? isCompletelyFetched = null,
    Object? message = freezed,
    Object? type = null,
    Object? beacons = null,
    Object? version = null,
  }) {
    return _then(_$AllBeaconGroupStateImpl(
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      isCompletelyFetched: null == isCompletelyFetched
          ? _value.isCompletelyFetched
          : isCompletelyFetched // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as filters,
      beacons: null == beacons
          ? _value._beacons
          : beacons // ignore: cast_nullable_to_non_nullable
              as List<BeaconEntity>,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$AllBeaconGroupStateImpl implements AllBeaconGroupState {
  const _$AllBeaconGroupStateImpl(
      {this.isLoadingMore = false,
      this.isCompletelyFetched = false,
      this.message,
      this.type = filters.ALL,
      required final List<BeaconEntity> beacons,
      this.version = 0})
      : _beacons = beacons;

  @override
  @JsonKey()
  final bool isLoadingMore;
  @override
  @JsonKey()
  final bool isCompletelyFetched;
  @override
  final String? message;
  @override
  @JsonKey()
  final filters type;
  final List<BeaconEntity> _beacons;
  @override
  List<BeaconEntity> get beacons {
    if (_beacons is EqualUnmodifiableListView) return _beacons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_beacons);
  }

  @override
  @JsonKey()
  final int version;

  @override
  String toString() {
    return 'GroupState.allBeacon(isLoadingMore: $isLoadingMore, isCompletelyFetched: $isCompletelyFetched, message: $message, type: $type, beacons: $beacons, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AllBeaconGroupStateImpl &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.isCompletelyFetched, isCompletelyFetched) ||
                other.isCompletelyFetched == isCompletelyFetched) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._beacons, _beacons) &&
            (identical(other.version, version) || other.version == version));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoadingMore,
      isCompletelyFetched,
      message,
      type,
      const DeepCollectionEquality().hash(_beacons),
      version);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AllBeaconGroupStateImplCopyWith<_$AllBeaconGroupStateImpl> get copyWith =>
      __$$AllBeaconGroupStateImplCopyWithImpl<_$AllBeaconGroupStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() shrimmer,
    required TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters type,
            List<BeaconEntity> beacons,
            int version)
        allBeacon,
    required TResult Function(String? message, filters type,
            List<BeaconEntity> beacons, double radius, int version)
        nearbyBeacon,
    required TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters? type,
            List<BeaconEntity> beacons,
            int version)
        statusFilterBeacon,
    required TResult Function(String message) error,
  }) {
    return allBeacon(
        isLoadingMore, isCompletelyFetched, message, type, beacons, version);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? shrimmer,
    TResult? Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters type,
            List<BeaconEntity> beacons,
            int version)?
        allBeacon,
    TResult? Function(String? message, filters type, List<BeaconEntity> beacons,
            double radius, int version)?
        nearbyBeacon,
    TResult? Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters? type,
            List<BeaconEntity> beacons,
            int version)?
        statusFilterBeacon,
    TResult? Function(String message)? error,
  }) {
    return allBeacon?.call(
        isLoadingMore, isCompletelyFetched, message, type, beacons, version);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? shrimmer,
    TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters type,
            List<BeaconEntity> beacons,
            int version)?
        allBeacon,
    TResult Function(String? message, filters type, List<BeaconEntity> beacons,
            double radius, int version)?
        nearbyBeacon,
    TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters? type,
            List<BeaconEntity> beacons,
            int version)?
        statusFilterBeacon,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (allBeacon != null) {
      return allBeacon(
          isLoadingMore, isCompletelyFetched, message, type, beacons, version);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialGroupState value) initial,
    required TResult Function(LoadingGroupState value) loading,
    required TResult Function(ShrimmerGroupState value) shrimmer,
    required TResult Function(AllBeaconGroupState value) allBeacon,
    required TResult Function(NearbyBeaconGroupState value) nearbyBeacon,
    required TResult Function(StatusFilterBeaconGroupState value)
        statusFilterBeacon,
    required TResult Function(ErrorGroupState value) error,
  }) {
    return allBeacon(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialGroupState value)? initial,
    TResult? Function(LoadingGroupState value)? loading,
    TResult? Function(ShrimmerGroupState value)? shrimmer,
    TResult? Function(AllBeaconGroupState value)? allBeacon,
    TResult? Function(NearbyBeaconGroupState value)? nearbyBeacon,
    TResult? Function(StatusFilterBeaconGroupState value)? statusFilterBeacon,
    TResult? Function(ErrorGroupState value)? error,
  }) {
    return allBeacon?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialGroupState value)? initial,
    TResult Function(LoadingGroupState value)? loading,
    TResult Function(ShrimmerGroupState value)? shrimmer,
    TResult Function(AllBeaconGroupState value)? allBeacon,
    TResult Function(NearbyBeaconGroupState value)? nearbyBeacon,
    TResult Function(StatusFilterBeaconGroupState value)? statusFilterBeacon,
    TResult Function(ErrorGroupState value)? error,
    required TResult orElse(),
  }) {
    if (allBeacon != null) {
      return allBeacon(this);
    }
    return orElse();
  }
}

abstract class AllBeaconGroupState implements GroupState {
  const factory AllBeaconGroupState(
      {final bool isLoadingMore,
      final bool isCompletelyFetched,
      final String? message,
      final filters type,
      required final List<BeaconEntity> beacons,
      final int version}) = _$AllBeaconGroupStateImpl;

  bool get isLoadingMore;
  bool get isCompletelyFetched;
  String? get message;
  filters get type;
  List<BeaconEntity> get beacons;
  int get version;
  @JsonKey(ignore: true)
  _$$AllBeaconGroupStateImplCopyWith<_$AllBeaconGroupStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NearbyBeaconGroupStateImplCopyWith<$Res> {
  factory _$$NearbyBeaconGroupStateImplCopyWith(
          _$NearbyBeaconGroupStateImpl value,
          $Res Function(_$NearbyBeaconGroupStateImpl) then) =
      __$$NearbyBeaconGroupStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {String? message,
      filters type,
      List<BeaconEntity> beacons,
      double radius,
      int version});
}

/// @nodoc
class __$$NearbyBeaconGroupStateImplCopyWithImpl<$Res>
    extends _$GroupStateCopyWithImpl<$Res, _$NearbyBeaconGroupStateImpl>
    implements _$$NearbyBeaconGroupStateImplCopyWith<$Res> {
  __$$NearbyBeaconGroupStateImplCopyWithImpl(
      _$NearbyBeaconGroupStateImpl _value,
      $Res Function(_$NearbyBeaconGroupStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
    Object? type = null,
    Object? beacons = null,
    Object? radius = null,
    Object? version = null,
  }) {
    return _then(_$NearbyBeaconGroupStateImpl(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as filters,
      beacons: null == beacons
          ? _value._beacons
          : beacons // ignore: cast_nullable_to_non_nullable
              as List<BeaconEntity>,
      radius: null == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as double,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$NearbyBeaconGroupStateImpl implements NearbyBeaconGroupState {
  const _$NearbyBeaconGroupStateImpl(
      {this.message,
      this.type = filters.NEARBY,
      required final List<BeaconEntity> beacons,
      this.radius = 1000.0,
      this.version = 0})
      : _beacons = beacons;

  @override
  final String? message;
  @override
  @JsonKey()
  final filters type;
  final List<BeaconEntity> _beacons;
  @override
  List<BeaconEntity> get beacons {
    if (_beacons is EqualUnmodifiableListView) return _beacons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_beacons);
  }

  @override
  @JsonKey()
  final double radius;
  @override
  @JsonKey()
  final int version;

  @override
  String toString() {
    return 'GroupState.nearbyBeacon(message: $message, type: $type, beacons: $beacons, radius: $radius, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NearbyBeaconGroupStateImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._beacons, _beacons) &&
            (identical(other.radius, radius) || other.radius == radius) &&
            (identical(other.version, version) || other.version == version));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, type,
      const DeepCollectionEquality().hash(_beacons), radius, version);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NearbyBeaconGroupStateImplCopyWith<_$NearbyBeaconGroupStateImpl>
      get copyWith => __$$NearbyBeaconGroupStateImplCopyWithImpl<
          _$NearbyBeaconGroupStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() shrimmer,
    required TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters type,
            List<BeaconEntity> beacons,
            int version)
        allBeacon,
    required TResult Function(String? message, filters type,
            List<BeaconEntity> beacons, double radius, int version)
        nearbyBeacon,
    required TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters? type,
            List<BeaconEntity> beacons,
            int version)
        statusFilterBeacon,
    required TResult Function(String message) error,
  }) {
    return nearbyBeacon(message, type, beacons, radius, version);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? shrimmer,
    TResult? Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters type,
            List<BeaconEntity> beacons,
            int version)?
        allBeacon,
    TResult? Function(String? message, filters type, List<BeaconEntity> beacons,
            double radius, int version)?
        nearbyBeacon,
    TResult? Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters? type,
            List<BeaconEntity> beacons,
            int version)?
        statusFilterBeacon,
    TResult? Function(String message)? error,
  }) {
    return nearbyBeacon?.call(message, type, beacons, radius, version);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? shrimmer,
    TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters type,
            List<BeaconEntity> beacons,
            int version)?
        allBeacon,
    TResult Function(String? message, filters type, List<BeaconEntity> beacons,
            double radius, int version)?
        nearbyBeacon,
    TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters? type,
            List<BeaconEntity> beacons,
            int version)?
        statusFilterBeacon,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (nearbyBeacon != null) {
      return nearbyBeacon(message, type, beacons, radius, version);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialGroupState value) initial,
    required TResult Function(LoadingGroupState value) loading,
    required TResult Function(ShrimmerGroupState value) shrimmer,
    required TResult Function(AllBeaconGroupState value) allBeacon,
    required TResult Function(NearbyBeaconGroupState value) nearbyBeacon,
    required TResult Function(StatusFilterBeaconGroupState value)
        statusFilterBeacon,
    required TResult Function(ErrorGroupState value) error,
  }) {
    return nearbyBeacon(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialGroupState value)? initial,
    TResult? Function(LoadingGroupState value)? loading,
    TResult? Function(ShrimmerGroupState value)? shrimmer,
    TResult? Function(AllBeaconGroupState value)? allBeacon,
    TResult? Function(NearbyBeaconGroupState value)? nearbyBeacon,
    TResult? Function(StatusFilterBeaconGroupState value)? statusFilterBeacon,
    TResult? Function(ErrorGroupState value)? error,
  }) {
    return nearbyBeacon?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialGroupState value)? initial,
    TResult Function(LoadingGroupState value)? loading,
    TResult Function(ShrimmerGroupState value)? shrimmer,
    TResult Function(AllBeaconGroupState value)? allBeacon,
    TResult Function(NearbyBeaconGroupState value)? nearbyBeacon,
    TResult Function(StatusFilterBeaconGroupState value)? statusFilterBeacon,
    TResult Function(ErrorGroupState value)? error,
    required TResult orElse(),
  }) {
    if (nearbyBeacon != null) {
      return nearbyBeacon(this);
    }
    return orElse();
  }
}

abstract class NearbyBeaconGroupState implements GroupState {
  const factory NearbyBeaconGroupState(
      {final String? message,
      final filters type,
      required final List<BeaconEntity> beacons,
      final double radius,
      final int version}) = _$NearbyBeaconGroupStateImpl;

  String? get message;
  filters get type;
  List<BeaconEntity> get beacons;
  double get radius;
  int get version;
  @JsonKey(ignore: true)
  _$$NearbyBeaconGroupStateImplCopyWith<_$NearbyBeaconGroupStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StatusFilterBeaconGroupStateImplCopyWith<$Res> {
  factory _$$StatusFilterBeaconGroupStateImplCopyWith(
          _$StatusFilterBeaconGroupStateImpl value,
          $Res Function(_$StatusFilterBeaconGroupStateImpl) then) =
      __$$StatusFilterBeaconGroupStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {bool isLoadingMore,
      bool isCompletelyFetched,
      String? message,
      filters? type,
      List<BeaconEntity> beacons,
      int version});
}

/// @nodoc
class __$$StatusFilterBeaconGroupStateImplCopyWithImpl<$Res>
    extends _$GroupStateCopyWithImpl<$Res, _$StatusFilterBeaconGroupStateImpl>
    implements _$$StatusFilterBeaconGroupStateImplCopyWith<$Res> {
  __$$StatusFilterBeaconGroupStateImplCopyWithImpl(
      _$StatusFilterBeaconGroupStateImpl _value,
      $Res Function(_$StatusFilterBeaconGroupStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoadingMore = null,
    Object? isCompletelyFetched = null,
    Object? message = freezed,
    Object? type = freezed,
    Object? beacons = null,
    Object? version = null,
  }) {
    return _then(_$StatusFilterBeaconGroupStateImpl(
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      isCompletelyFetched: null == isCompletelyFetched
          ? _value.isCompletelyFetched
          : isCompletelyFetched // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as filters?,
      beacons: null == beacons
          ? _value._beacons
          : beacons // ignore: cast_nullable_to_non_nullable
              as List<BeaconEntity>,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$StatusFilterBeaconGroupStateImpl
    implements StatusFilterBeaconGroupState {
  const _$StatusFilterBeaconGroupStateImpl(
      {this.isLoadingMore = false,
      this.isCompletelyFetched = false,
      this.message,
      this.type,
      required final List<BeaconEntity> beacons,
      this.version = 0})
      : _beacons = beacons;

  @override
  @JsonKey()
  final bool isLoadingMore;
  @override
  @JsonKey()
  final bool isCompletelyFetched;
  @override
  final String? message;
  @override
  final filters? type;
  final List<BeaconEntity> _beacons;
  @override
  List<BeaconEntity> get beacons {
    if (_beacons is EqualUnmodifiableListView) return _beacons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_beacons);
  }

  @override
  @JsonKey()
  final int version;

  @override
  String toString() {
    return 'GroupState.statusFilterBeacon(isLoadingMore: $isLoadingMore, isCompletelyFetched: $isCompletelyFetched, message: $message, type: $type, beacons: $beacons, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatusFilterBeaconGroupStateImpl &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.isCompletelyFetched, isCompletelyFetched) ||
                other.isCompletelyFetched == isCompletelyFetched) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._beacons, _beacons) &&
            (identical(other.version, version) || other.version == version));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoadingMore,
      isCompletelyFetched,
      message,
      type,
      const DeepCollectionEquality().hash(_beacons),
      version);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StatusFilterBeaconGroupStateImplCopyWith<
          _$StatusFilterBeaconGroupStateImpl>
      get copyWith => __$$StatusFilterBeaconGroupStateImplCopyWithImpl<
          _$StatusFilterBeaconGroupStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() shrimmer,
    required TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters type,
            List<BeaconEntity> beacons,
            int version)
        allBeacon,
    required TResult Function(String? message, filters type,
            List<BeaconEntity> beacons, double radius, int version)
        nearbyBeacon,
    required TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters? type,
            List<BeaconEntity> beacons,
            int version)
        statusFilterBeacon,
    required TResult Function(String message) error,
  }) {
    return statusFilterBeacon(
        isLoadingMore, isCompletelyFetched, message, type, beacons, version);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? shrimmer,
    TResult? Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters type,
            List<BeaconEntity> beacons,
            int version)?
        allBeacon,
    TResult? Function(String? message, filters type, List<BeaconEntity> beacons,
            double radius, int version)?
        nearbyBeacon,
    TResult? Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters? type,
            List<BeaconEntity> beacons,
            int version)?
        statusFilterBeacon,
    TResult? Function(String message)? error,
  }) {
    return statusFilterBeacon?.call(
        isLoadingMore, isCompletelyFetched, message, type, beacons, version);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? shrimmer,
    TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters type,
            List<BeaconEntity> beacons,
            int version)?
        allBeacon,
    TResult Function(String? message, filters type, List<BeaconEntity> beacons,
            double radius, int version)?
        nearbyBeacon,
    TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters? type,
            List<BeaconEntity> beacons,
            int version)?
        statusFilterBeacon,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (statusFilterBeacon != null) {
      return statusFilterBeacon(
          isLoadingMore, isCompletelyFetched, message, type, beacons, version);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialGroupState value) initial,
    required TResult Function(LoadingGroupState value) loading,
    required TResult Function(ShrimmerGroupState value) shrimmer,
    required TResult Function(AllBeaconGroupState value) allBeacon,
    required TResult Function(NearbyBeaconGroupState value) nearbyBeacon,
    required TResult Function(StatusFilterBeaconGroupState value)
        statusFilterBeacon,
    required TResult Function(ErrorGroupState value) error,
  }) {
    return statusFilterBeacon(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialGroupState value)? initial,
    TResult? Function(LoadingGroupState value)? loading,
    TResult? Function(ShrimmerGroupState value)? shrimmer,
    TResult? Function(AllBeaconGroupState value)? allBeacon,
    TResult? Function(NearbyBeaconGroupState value)? nearbyBeacon,
    TResult? Function(StatusFilterBeaconGroupState value)? statusFilterBeacon,
    TResult? Function(ErrorGroupState value)? error,
  }) {
    return statusFilterBeacon?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialGroupState value)? initial,
    TResult Function(LoadingGroupState value)? loading,
    TResult Function(ShrimmerGroupState value)? shrimmer,
    TResult Function(AllBeaconGroupState value)? allBeacon,
    TResult Function(NearbyBeaconGroupState value)? nearbyBeacon,
    TResult Function(StatusFilterBeaconGroupState value)? statusFilterBeacon,
    TResult Function(ErrorGroupState value)? error,
    required TResult orElse(),
  }) {
    if (statusFilterBeacon != null) {
      return statusFilterBeacon(this);
    }
    return orElse();
  }
}

abstract class StatusFilterBeaconGroupState implements GroupState {
  const factory StatusFilterBeaconGroupState(
      {final bool isLoadingMore,
      final bool isCompletelyFetched,
      final String? message,
      final filters? type,
      required final List<BeaconEntity> beacons,
      final int version}) = _$StatusFilterBeaconGroupStateImpl;

  bool get isLoadingMore;
  bool get isCompletelyFetched;
  String? get message;
  filters? get type;
  List<BeaconEntity> get beacons;
  int get version;
  @JsonKey(ignore: true)
  _$$StatusFilterBeaconGroupStateImplCopyWith<
          _$StatusFilterBeaconGroupStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorGroupStateImplCopyWith<$Res> {
  factory _$$ErrorGroupStateImplCopyWith(_$ErrorGroupStateImpl value,
          $Res Function(_$ErrorGroupStateImpl) then) =
      __$$ErrorGroupStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorGroupStateImplCopyWithImpl<$Res>
    extends _$GroupStateCopyWithImpl<$Res, _$ErrorGroupStateImpl>
    implements _$$ErrorGroupStateImplCopyWith<$Res> {
  __$$ErrorGroupStateImplCopyWithImpl(
      _$ErrorGroupStateImpl _value, $Res Function(_$ErrorGroupStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ErrorGroupStateImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorGroupStateImpl implements ErrorGroupState {
  const _$ErrorGroupStateImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'GroupState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorGroupStateImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorGroupStateImplCopyWith<_$ErrorGroupStateImpl> get copyWith =>
      __$$ErrorGroupStateImplCopyWithImpl<_$ErrorGroupStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() shrimmer,
    required TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters type,
            List<BeaconEntity> beacons,
            int version)
        allBeacon,
    required TResult Function(String? message, filters type,
            List<BeaconEntity> beacons, double radius, int version)
        nearbyBeacon,
    required TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters? type,
            List<BeaconEntity> beacons,
            int version)
        statusFilterBeacon,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? shrimmer,
    TResult? Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters type,
            List<BeaconEntity> beacons,
            int version)?
        allBeacon,
    TResult? Function(String? message, filters type, List<BeaconEntity> beacons,
            double radius, int version)?
        nearbyBeacon,
    TResult? Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters? type,
            List<BeaconEntity> beacons,
            int version)?
        statusFilterBeacon,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? shrimmer,
    TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters type,
            List<BeaconEntity> beacons,
            int version)?
        allBeacon,
    TResult Function(String? message, filters type, List<BeaconEntity> beacons,
            double radius, int version)?
        nearbyBeacon,
    TResult Function(
            bool isLoadingMore,
            bool isCompletelyFetched,
            String? message,
            filters? type,
            List<BeaconEntity> beacons,
            int version)?
        statusFilterBeacon,
    TResult Function(String message)? error,
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
    required TResult Function(InitialGroupState value) initial,
    required TResult Function(LoadingGroupState value) loading,
    required TResult Function(ShrimmerGroupState value) shrimmer,
    required TResult Function(AllBeaconGroupState value) allBeacon,
    required TResult Function(NearbyBeaconGroupState value) nearbyBeacon,
    required TResult Function(StatusFilterBeaconGroupState value)
        statusFilterBeacon,
    required TResult Function(ErrorGroupState value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialGroupState value)? initial,
    TResult? Function(LoadingGroupState value)? loading,
    TResult? Function(ShrimmerGroupState value)? shrimmer,
    TResult? Function(AllBeaconGroupState value)? allBeacon,
    TResult? Function(NearbyBeaconGroupState value)? nearbyBeacon,
    TResult? Function(StatusFilterBeaconGroupState value)? statusFilterBeacon,
    TResult? Function(ErrorGroupState value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialGroupState value)? initial,
    TResult Function(LoadingGroupState value)? loading,
    TResult Function(ShrimmerGroupState value)? shrimmer,
    TResult Function(AllBeaconGroupState value)? allBeacon,
    TResult Function(NearbyBeaconGroupState value)? nearbyBeacon,
    TResult Function(StatusFilterBeaconGroupState value)? statusFilterBeacon,
    TResult Function(ErrorGroupState value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ErrorGroupState implements GroupState {
  const factory ErrorGroupState({required final String message}) =
      _$ErrorGroupStateImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$ErrorGroupStateImplCopyWith<_$ErrorGroupStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
