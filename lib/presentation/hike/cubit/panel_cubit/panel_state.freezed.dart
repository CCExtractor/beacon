// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'panel_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SlidingPanelState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(
            bool? isActive,
            String? expiringTime,
            String? leaderAddress,
            UserEntity? leader,
            List<UserEntity?>? followers,
            String? message)
        loaded,
    required TResult Function(String? message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(
            bool? isActive,
            String? expiringTime,
            String? leaderAddress,
            UserEntity? leader,
            List<UserEntity?>? followers,
            String? message)?
        loaded,
    TResult? Function(String? message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(
            bool? isActive,
            String? expiringTime,
            String? leaderAddress,
            UserEntity? leader,
            List<UserEntity?>? followers,
            String? message)?
        loaded,
    TResult Function(String? message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialPanelState value) initial,
    required TResult Function(LoadedPanelState value) loaded,
    required TResult Function(ErrorPanelState value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialPanelState value)? initial,
    TResult? Function(LoadedPanelState value)? loaded,
    TResult? Function(ErrorPanelState value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialPanelState value)? initial,
    TResult Function(LoadedPanelState value)? loaded,
    TResult Function(ErrorPanelState value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SlidingPanelStateCopyWith<$Res> {
  factory $SlidingPanelStateCopyWith(
          SlidingPanelState value, $Res Function(SlidingPanelState) then) =
      _$SlidingPanelStateCopyWithImpl<$Res, SlidingPanelState>;
}

/// @nodoc
class _$SlidingPanelStateCopyWithImpl<$Res, $Val extends SlidingPanelState>
    implements $SlidingPanelStateCopyWith<$Res> {
  _$SlidingPanelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InitialPanelStateImplCopyWith<$Res> {
  factory _$$InitialPanelStateImplCopyWith(_$InitialPanelStateImpl value,
          $Res Function(_$InitialPanelStateImpl) then) =
      __$$InitialPanelStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialPanelStateImplCopyWithImpl<$Res>
    extends _$SlidingPanelStateCopyWithImpl<$Res, _$InitialPanelStateImpl>
    implements _$$InitialPanelStateImplCopyWith<$Res> {
  __$$InitialPanelStateImplCopyWithImpl(_$InitialPanelStateImpl _value,
      $Res Function(_$InitialPanelStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InitialPanelStateImpl implements InitialPanelState {
  _$InitialPanelStateImpl();

  @override
  String toString() {
    return 'SlidingPanelState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialPanelStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(
            bool? isActive,
            String? expiringTime,
            String? leaderAddress,
            UserEntity? leader,
            List<UserEntity?>? followers,
            String? message)
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
            bool? isActive,
            String? expiringTime,
            String? leaderAddress,
            UserEntity? leader,
            List<UserEntity?>? followers,
            String? message)?
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
            bool? isActive,
            String? expiringTime,
            String? leaderAddress,
            UserEntity? leader,
            List<UserEntity?>? followers,
            String? message)?
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
    required TResult Function(InitialPanelState value) initial,
    required TResult Function(LoadedPanelState value) loaded,
    required TResult Function(ErrorPanelState value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialPanelState value)? initial,
    TResult? Function(LoadedPanelState value)? loaded,
    TResult? Function(ErrorPanelState value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialPanelState value)? initial,
    TResult Function(LoadedPanelState value)? loaded,
    TResult Function(ErrorPanelState value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class InitialPanelState implements SlidingPanelState {
  factory InitialPanelState() = _$InitialPanelStateImpl;
}

/// @nodoc
abstract class _$$LoadedPanelStateImplCopyWith<$Res> {
  factory _$$LoadedPanelStateImplCopyWith(_$LoadedPanelStateImpl value,
          $Res Function(_$LoadedPanelStateImpl) then) =
      __$$LoadedPanelStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {bool? isActive,
      String? expiringTime,
      String? leaderAddress,
      UserEntity? leader,
      List<UserEntity?>? followers,
      String? message});

  $UserEntityCopyWith<$Res>? get leader;
}

/// @nodoc
class __$$LoadedPanelStateImplCopyWithImpl<$Res>
    extends _$SlidingPanelStateCopyWithImpl<$Res, _$LoadedPanelStateImpl>
    implements _$$LoadedPanelStateImplCopyWith<$Res> {
  __$$LoadedPanelStateImplCopyWithImpl(_$LoadedPanelStateImpl _value,
      $Res Function(_$LoadedPanelStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isActive = freezed,
    Object? expiringTime = freezed,
    Object? leaderAddress = freezed,
    Object? leader = freezed,
    Object? followers = freezed,
    Object? message = freezed,
  }) {
    return _then(_$LoadedPanelStateImpl(
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      expiringTime: freezed == expiringTime
          ? _value.expiringTime
          : expiringTime // ignore: cast_nullable_to_non_nullable
              as String?,
      leaderAddress: freezed == leaderAddress
          ? _value.leaderAddress
          : leaderAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      leader: freezed == leader
          ? _value.leader
          : leader // ignore: cast_nullable_to_non_nullable
              as UserEntity?,
      followers: freezed == followers
          ? _value._followers
          : followers // ignore: cast_nullable_to_non_nullable
              as List<UserEntity?>?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $UserEntityCopyWith<$Res>? get leader {
    if (_value.leader == null) {
      return null;
    }

    return $UserEntityCopyWith<$Res>(_value.leader!, (value) {
      return _then(_value.copyWith(leader: value));
    });
  }
}

/// @nodoc

class _$LoadedPanelStateImpl implements LoadedPanelState {
  _$LoadedPanelStateImpl(
      {this.isActive,
      this.expiringTime,
      this.leaderAddress,
      this.leader,
      final List<UserEntity?>? followers,
      this.message})
      : _followers = followers;

  @override
  final bool? isActive;
  @override
  final String? expiringTime;
  @override
  final String? leaderAddress;
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

  @override
  final String? message;

  @override
  String toString() {
    return 'SlidingPanelState.loaded(isActive: $isActive, expiringTime: $expiringTime, leaderAddress: $leaderAddress, leader: $leader, followers: $followers, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadedPanelStateImpl &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.expiringTime, expiringTime) ||
                other.expiringTime == expiringTime) &&
            (identical(other.leaderAddress, leaderAddress) ||
                other.leaderAddress == leaderAddress) &&
            (identical(other.leader, leader) || other.leader == leader) &&
            const DeepCollectionEquality()
                .equals(other._followers, _followers) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isActive,
      expiringTime,
      leaderAddress,
      leader,
      const DeepCollectionEquality().hash(_followers),
      message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadedPanelStateImplCopyWith<_$LoadedPanelStateImpl> get copyWith =>
      __$$LoadedPanelStateImplCopyWithImpl<_$LoadedPanelStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(
            bool? isActive,
            String? expiringTime,
            String? leaderAddress,
            UserEntity? leader,
            List<UserEntity?>? followers,
            String? message)
        loaded,
    required TResult Function(String? message) error,
  }) {
    return loaded(
        isActive, expiringTime, leaderAddress, leader, followers, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(
            bool? isActive,
            String? expiringTime,
            String? leaderAddress,
            UserEntity? leader,
            List<UserEntity?>? followers,
            String? message)?
        loaded,
    TResult? Function(String? message)? error,
  }) {
    return loaded?.call(
        isActive, expiringTime, leaderAddress, leader, followers, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(
            bool? isActive,
            String? expiringTime,
            String? leaderAddress,
            UserEntity? leader,
            List<UserEntity?>? followers,
            String? message)?
        loaded,
    TResult Function(String? message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(
          isActive, expiringTime, leaderAddress, leader, followers, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialPanelState value) initial,
    required TResult Function(LoadedPanelState value) loaded,
    required TResult Function(ErrorPanelState value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialPanelState value)? initial,
    TResult? Function(LoadedPanelState value)? loaded,
    TResult? Function(ErrorPanelState value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialPanelState value)? initial,
    TResult Function(LoadedPanelState value)? loaded,
    TResult Function(ErrorPanelState value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class LoadedPanelState implements SlidingPanelState {
  factory LoadedPanelState(
      {final bool? isActive,
      final String? expiringTime,
      final String? leaderAddress,
      final UserEntity? leader,
      final List<UserEntity?>? followers,
      final String? message}) = _$LoadedPanelStateImpl;

  bool? get isActive;
  String? get expiringTime;
  String? get leaderAddress;
  UserEntity? get leader;
  List<UserEntity?>? get followers;
  String? get message;
  @JsonKey(ignore: true)
  _$$LoadedPanelStateImplCopyWith<_$LoadedPanelStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorPanelStateImplCopyWith<$Res> {
  factory _$$ErrorPanelStateImplCopyWith(_$ErrorPanelStateImpl value,
          $Res Function(_$ErrorPanelStateImpl) then) =
      __$$ErrorPanelStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$ErrorPanelStateImplCopyWithImpl<$Res>
    extends _$SlidingPanelStateCopyWithImpl<$Res, _$ErrorPanelStateImpl>
    implements _$$ErrorPanelStateImplCopyWith<$Res> {
  __$$ErrorPanelStateImplCopyWithImpl(
      _$ErrorPanelStateImpl _value, $Res Function(_$ErrorPanelStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$ErrorPanelStateImpl(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ErrorPanelStateImpl implements ErrorPanelState {
  _$ErrorPanelStateImpl({this.message});

  @override
  final String? message;

  @override
  String toString() {
    return 'SlidingPanelState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorPanelStateImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorPanelStateImplCopyWith<_$ErrorPanelStateImpl> get copyWith =>
      __$$ErrorPanelStateImplCopyWithImpl<_$ErrorPanelStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(
            bool? isActive,
            String? expiringTime,
            String? leaderAddress,
            UserEntity? leader,
            List<UserEntity?>? followers,
            String? message)
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
            bool? isActive,
            String? expiringTime,
            String? leaderAddress,
            UserEntity? leader,
            List<UserEntity?>? followers,
            String? message)?
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
            bool? isActive,
            String? expiringTime,
            String? leaderAddress,
            UserEntity? leader,
            List<UserEntity?>? followers,
            String? message)?
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
    required TResult Function(InitialPanelState value) initial,
    required TResult Function(LoadedPanelState value) loaded,
    required TResult Function(ErrorPanelState value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialPanelState value)? initial,
    TResult? Function(LoadedPanelState value)? loaded,
    TResult? Function(ErrorPanelState value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialPanelState value)? initial,
    TResult Function(LoadedPanelState value)? loaded,
    TResult Function(ErrorPanelState value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ErrorPanelState implements SlidingPanelState {
  factory ErrorPanelState({final String? message}) = _$ErrorPanelStateImpl;

  String? get message;
  @JsonKey(ignore: true)
  _$$ErrorPanelStateImplCopyWith<_$ErrorPanelStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
