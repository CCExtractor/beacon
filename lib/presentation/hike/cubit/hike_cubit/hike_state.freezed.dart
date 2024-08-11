// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hike_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HikeState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(BeaconEntity? beacon, String? message) loaded,
    required TResult Function(String? errmessage) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(BeaconEntity? beacon, String? message)? loaded,
    TResult? Function(String? errmessage)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(BeaconEntity? beacon, String? message)? loaded,
    TResult Function(String? errmessage)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialHikeState value) initial,
    required TResult Function(LoadedHikeState value) loaded,
    required TResult Function(ErrorHikeState value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialHikeState value)? initial,
    TResult? Function(LoadedHikeState value)? loaded,
    TResult? Function(ErrorHikeState value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialHikeState value)? initial,
    TResult Function(LoadedHikeState value)? loaded,
    TResult Function(ErrorHikeState value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HikeStateCopyWith<$Res> {
  factory $HikeStateCopyWith(HikeState value, $Res Function(HikeState) then) =
      _$HikeStateCopyWithImpl<$Res, HikeState>;
}

/// @nodoc
class _$HikeStateCopyWithImpl<$Res, $Val extends HikeState>
    implements $HikeStateCopyWith<$Res> {
  _$HikeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InitialHikeStateImplCopyWith<$Res> {
  factory _$$InitialHikeStateImplCopyWith(_$InitialHikeStateImpl value,
          $Res Function(_$InitialHikeStateImpl) then) =
      __$$InitialHikeStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialHikeStateImplCopyWithImpl<$Res>
    extends _$HikeStateCopyWithImpl<$Res, _$InitialHikeStateImpl>
    implements _$$InitialHikeStateImplCopyWith<$Res> {
  __$$InitialHikeStateImplCopyWithImpl(_$InitialHikeStateImpl _value,
      $Res Function(_$InitialHikeStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InitialHikeStateImpl implements InitialHikeState {
  _$InitialHikeStateImpl();

  @override
  String toString() {
    return 'HikeState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialHikeStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(BeaconEntity? beacon, String? message) loaded,
    required TResult Function(String? errmessage) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(BeaconEntity? beacon, String? message)? loaded,
    TResult? Function(String? errmessage)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(BeaconEntity? beacon, String? message)? loaded,
    TResult Function(String? errmessage)? error,
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
    required TResult Function(InitialHikeState value) initial,
    required TResult Function(LoadedHikeState value) loaded,
    required TResult Function(ErrorHikeState value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialHikeState value)? initial,
    TResult? Function(LoadedHikeState value)? loaded,
    TResult? Function(ErrorHikeState value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialHikeState value)? initial,
    TResult Function(LoadedHikeState value)? loaded,
    TResult Function(ErrorHikeState value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class InitialHikeState implements HikeState {
  factory InitialHikeState() = _$InitialHikeStateImpl;
}

/// @nodoc
abstract class _$$LoadedHikeStateImplCopyWith<$Res> {
  factory _$$LoadedHikeStateImplCopyWith(_$LoadedHikeStateImpl value,
          $Res Function(_$LoadedHikeStateImpl) then) =
      __$$LoadedHikeStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({BeaconEntity? beacon, String? message});

  $BeaconEntityCopyWith<$Res>? get beacon;
}

/// @nodoc
class __$$LoadedHikeStateImplCopyWithImpl<$Res>
    extends _$HikeStateCopyWithImpl<$Res, _$LoadedHikeStateImpl>
    implements _$$LoadedHikeStateImplCopyWith<$Res> {
  __$$LoadedHikeStateImplCopyWithImpl(
      _$LoadedHikeStateImpl _value, $Res Function(_$LoadedHikeStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? beacon = freezed,
    Object? message = freezed,
  }) {
    return _then(_$LoadedHikeStateImpl(
      beacon: freezed == beacon
          ? _value.beacon
          : beacon // ignore: cast_nullable_to_non_nullable
              as BeaconEntity?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $BeaconEntityCopyWith<$Res>? get beacon {
    if (_value.beacon == null) {
      return null;
    }

    return $BeaconEntityCopyWith<$Res>(_value.beacon!, (value) {
      return _then(_value.copyWith(beacon: value));
    });
  }
}

/// @nodoc

class _$LoadedHikeStateImpl implements LoadedHikeState {
  _$LoadedHikeStateImpl({this.beacon, this.message});

  @override
  final BeaconEntity? beacon;
  @override
  final String? message;

  @override
  String toString() {
    return 'HikeState.loaded(beacon: $beacon, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadedHikeStateImpl &&
            (identical(other.beacon, beacon) || other.beacon == beacon) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, beacon, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadedHikeStateImplCopyWith<_$LoadedHikeStateImpl> get copyWith =>
      __$$LoadedHikeStateImplCopyWithImpl<_$LoadedHikeStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(BeaconEntity? beacon, String? message) loaded,
    required TResult Function(String? errmessage) error,
  }) {
    return loaded(beacon, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(BeaconEntity? beacon, String? message)? loaded,
    TResult? Function(String? errmessage)? error,
  }) {
    return loaded?.call(beacon, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(BeaconEntity? beacon, String? message)? loaded,
    TResult Function(String? errmessage)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(beacon, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialHikeState value) initial,
    required TResult Function(LoadedHikeState value) loaded,
    required TResult Function(ErrorHikeState value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialHikeState value)? initial,
    TResult? Function(LoadedHikeState value)? loaded,
    TResult? Function(ErrorHikeState value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialHikeState value)? initial,
    TResult Function(LoadedHikeState value)? loaded,
    TResult Function(ErrorHikeState value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class LoadedHikeState implements HikeState {
  factory LoadedHikeState({final BeaconEntity? beacon, final String? message}) =
      _$LoadedHikeStateImpl;

  BeaconEntity? get beacon;
  String? get message;
  @JsonKey(ignore: true)
  _$$LoadedHikeStateImplCopyWith<_$LoadedHikeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorHikeStateImplCopyWith<$Res> {
  factory _$$ErrorHikeStateImplCopyWith(_$ErrorHikeStateImpl value,
          $Res Function(_$ErrorHikeStateImpl) then) =
      __$$ErrorHikeStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? errmessage});
}

/// @nodoc
class __$$ErrorHikeStateImplCopyWithImpl<$Res>
    extends _$HikeStateCopyWithImpl<$Res, _$ErrorHikeStateImpl>
    implements _$$ErrorHikeStateImplCopyWith<$Res> {
  __$$ErrorHikeStateImplCopyWithImpl(
      _$ErrorHikeStateImpl _value, $Res Function(_$ErrorHikeStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errmessage = freezed,
  }) {
    return _then(_$ErrorHikeStateImpl(
      errmessage: freezed == errmessage
          ? _value.errmessage
          : errmessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ErrorHikeStateImpl implements ErrorHikeState {
  _$ErrorHikeStateImpl({this.errmessage});

  @override
  final String? errmessage;

  @override
  String toString() {
    return 'HikeState.error(errmessage: $errmessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorHikeStateImpl &&
            (identical(other.errmessage, errmessage) ||
                other.errmessage == errmessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errmessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorHikeStateImplCopyWith<_$ErrorHikeStateImpl> get copyWith =>
      __$$ErrorHikeStateImplCopyWithImpl<_$ErrorHikeStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(BeaconEntity? beacon, String? message) loaded,
    required TResult Function(String? errmessage) error,
  }) {
    return error(errmessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(BeaconEntity? beacon, String? message)? loaded,
    TResult? Function(String? errmessage)? error,
  }) {
    return error?.call(errmessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(BeaconEntity? beacon, String? message)? loaded,
    TResult Function(String? errmessage)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(errmessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialHikeState value) initial,
    required TResult Function(LoadedHikeState value) loaded,
    required TResult Function(ErrorHikeState value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialHikeState value)? initial,
    TResult? Function(LoadedHikeState value)? loaded,
    TResult? Function(ErrorHikeState value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialHikeState value)? initial,
    TResult Function(LoadedHikeState value)? loaded,
    TResult Function(ErrorHikeState value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ErrorHikeState implements HikeState {
  factory ErrorHikeState({final String? errmessage}) = _$ErrorHikeStateImpl;

  String? get errmessage;
  @JsonKey(ignore: true)
  _$$ErrorHikeStateImplCopyWith<_$ErrorHikeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
