// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'members_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MembersState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<UserEntity>? members, String? message)
        reload,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<UserEntity>? members, String? message)? reload,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<UserEntity>? members, String? message)? reload,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialMemberState value) initial,
    required TResult Function(LoadingMemberState value) loading,
    required TResult Function(LoadedMemberState value) reload,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialMemberState value)? initial,
    TResult? Function(LoadingMemberState value)? loading,
    TResult? Function(LoadedMemberState value)? reload,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialMemberState value)? initial,
    TResult Function(LoadingMemberState value)? loading,
    TResult Function(LoadedMemberState value)? reload,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MembersStateCopyWith<$Res> {
  factory $MembersStateCopyWith(
          MembersState value, $Res Function(MembersState) then) =
      _$MembersStateCopyWithImpl<$Res, MembersState>;
}

/// @nodoc
class _$MembersStateCopyWithImpl<$Res, $Val extends MembersState>
    implements $MembersStateCopyWith<$Res> {
  _$MembersStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InitialMemberStateImplCopyWith<$Res> {
  factory _$$InitialMemberStateImplCopyWith(_$InitialMemberStateImpl value,
          $Res Function(_$InitialMemberStateImpl) then) =
      __$$InitialMemberStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialMemberStateImplCopyWithImpl<$Res>
    extends _$MembersStateCopyWithImpl<$Res, _$InitialMemberStateImpl>
    implements _$$InitialMemberStateImplCopyWith<$Res> {
  __$$InitialMemberStateImplCopyWithImpl(_$InitialMemberStateImpl _value,
      $Res Function(_$InitialMemberStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InitialMemberStateImpl implements InitialMemberState {
  _$InitialMemberStateImpl();

  @override
  String toString() {
    return 'MembersState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialMemberStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<UserEntity>? members, String? message)
        reload,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<UserEntity>? members, String? message)? reload,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<UserEntity>? members, String? message)? reload,
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
    required TResult Function(InitialMemberState value) initial,
    required TResult Function(LoadingMemberState value) loading,
    required TResult Function(LoadedMemberState value) reload,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialMemberState value)? initial,
    TResult? Function(LoadingMemberState value)? loading,
    TResult? Function(LoadedMemberState value)? reload,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialMemberState value)? initial,
    TResult Function(LoadingMemberState value)? loading,
    TResult Function(LoadedMemberState value)? reload,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class InitialMemberState implements MembersState {
  factory InitialMemberState() = _$InitialMemberStateImpl;
}

/// @nodoc
abstract class _$$LoadingMemberStateImplCopyWith<$Res> {
  factory _$$LoadingMemberStateImplCopyWith(_$LoadingMemberStateImpl value,
          $Res Function(_$LoadingMemberStateImpl) then) =
      __$$LoadingMemberStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingMemberStateImplCopyWithImpl<$Res>
    extends _$MembersStateCopyWithImpl<$Res, _$LoadingMemberStateImpl>
    implements _$$LoadingMemberStateImplCopyWith<$Res> {
  __$$LoadingMemberStateImplCopyWithImpl(_$LoadingMemberStateImpl _value,
      $Res Function(_$LoadingMemberStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadingMemberStateImpl implements LoadingMemberState {
  _$LoadingMemberStateImpl();

  @override
  String toString() {
    return 'MembersState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingMemberStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<UserEntity>? members, String? message)
        reload,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<UserEntity>? members, String? message)? reload,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<UserEntity>? members, String? message)? reload,
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
    required TResult Function(InitialMemberState value) initial,
    required TResult Function(LoadingMemberState value) loading,
    required TResult Function(LoadedMemberState value) reload,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialMemberState value)? initial,
    TResult? Function(LoadingMemberState value)? loading,
    TResult? Function(LoadedMemberState value)? reload,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialMemberState value)? initial,
    TResult Function(LoadingMemberState value)? loading,
    TResult Function(LoadedMemberState value)? reload,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class LoadingMemberState implements MembersState {
  factory LoadingMemberState() = _$LoadingMemberStateImpl;
}

/// @nodoc
abstract class _$$LoadedMemberStateImplCopyWith<$Res> {
  factory _$$LoadedMemberStateImplCopyWith(_$LoadedMemberStateImpl value,
          $Res Function(_$LoadedMemberStateImpl) then) =
      __$$LoadedMemberStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<UserEntity>? members, String? message});
}

/// @nodoc
class __$$LoadedMemberStateImplCopyWithImpl<$Res>
    extends _$MembersStateCopyWithImpl<$Res, _$LoadedMemberStateImpl>
    implements _$$LoadedMemberStateImplCopyWith<$Res> {
  __$$LoadedMemberStateImplCopyWithImpl(_$LoadedMemberStateImpl _value,
      $Res Function(_$LoadedMemberStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? members = freezed,
    Object? message = freezed,
  }) {
    return _then(_$LoadedMemberStateImpl(
      members: freezed == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<UserEntity>?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$LoadedMemberStateImpl implements LoadedMemberState {
  _$LoadedMemberStateImpl({final List<UserEntity>? members, this.message})
      : _members = members;

  final List<UserEntity>? _members;
  @override
  List<UserEntity>? get members {
    final value = _members;
    if (value == null) return null;
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? message;

  @override
  String toString() {
    return 'MembersState.reload(members: $members, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadedMemberStateImpl &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_members), message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadedMemberStateImplCopyWith<_$LoadedMemberStateImpl> get copyWith =>
      __$$LoadedMemberStateImplCopyWithImpl<_$LoadedMemberStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<UserEntity>? members, String? message)
        reload,
  }) {
    return reload(members, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<UserEntity>? members, String? message)? reload,
  }) {
    return reload?.call(members, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<UserEntity>? members, String? message)? reload,
    required TResult orElse(),
  }) {
    if (reload != null) {
      return reload(members, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialMemberState value) initial,
    required TResult Function(LoadingMemberState value) loading,
    required TResult Function(LoadedMemberState value) reload,
  }) {
    return reload(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialMemberState value)? initial,
    TResult? Function(LoadingMemberState value)? loading,
    TResult? Function(LoadedMemberState value)? reload,
  }) {
    return reload?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialMemberState value)? initial,
    TResult Function(LoadingMemberState value)? loading,
    TResult Function(LoadedMemberState value)? reload,
    required TResult orElse(),
  }) {
    if (reload != null) {
      return reload(this);
    }
    return orElse();
  }
}

abstract class LoadedMemberState implements MembersState {
  factory LoadedMemberState(
      {final List<UserEntity>? members,
      final String? message}) = _$LoadedMemberStateImpl;

  List<UserEntity>? get members;
  String? get message;
  @JsonKey(ignore: true)
  _$$LoadedMemberStateImplCopyWith<_$LoadedMemberStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
