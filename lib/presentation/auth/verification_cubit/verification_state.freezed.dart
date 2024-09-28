// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verification_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$OTPVerificationState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() otpSending,
    required TResult Function(String? otp) otpSent,
    required TResult Function() otpVerifying,
    required TResult Function() otpVerified,
    required TResult Function() failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? otpSending,
    TResult? Function(String? otp)? otpSent,
    TResult? Function()? otpVerifying,
    TResult? Function()? otpVerified,
    TResult? Function()? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? otpSending,
    TResult Function(String? otp)? otpSent,
    TResult Function()? otpVerifying,
    TResult Function()? otpVerified,
    TResult Function()? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialOTPState value) initial,
    required TResult Function(OTPSendingState value) otpSending,
    required TResult Function(OTPSentState value) otpSent,
    required TResult Function(OTPVerifyingState value) otpVerifying,
    required TResult Function(OTPVerifiedState value) otpVerified,
    required TResult Function(OTPFailureState value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialOTPState value)? initial,
    TResult? Function(OTPSendingState value)? otpSending,
    TResult? Function(OTPSentState value)? otpSent,
    TResult? Function(OTPVerifyingState value)? otpVerifying,
    TResult? Function(OTPVerifiedState value)? otpVerified,
    TResult? Function(OTPFailureState value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialOTPState value)? initial,
    TResult Function(OTPSendingState value)? otpSending,
    TResult Function(OTPSentState value)? otpSent,
    TResult Function(OTPVerifyingState value)? otpVerifying,
    TResult Function(OTPVerifiedState value)? otpVerified,
    TResult Function(OTPFailureState value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OTPVerificationStateCopyWith<$Res> {
  factory $OTPVerificationStateCopyWith(OTPVerificationState value,
          $Res Function(OTPVerificationState) then) =
      _$OTPVerificationStateCopyWithImpl<$Res, OTPVerificationState>;
}

/// @nodoc
class _$OTPVerificationStateCopyWithImpl<$Res,
        $Val extends OTPVerificationState>
    implements $OTPVerificationStateCopyWith<$Res> {
  _$OTPVerificationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InitialOTPStateImplCopyWith<$Res> {
  factory _$$InitialOTPStateImplCopyWith(_$InitialOTPStateImpl value,
          $Res Function(_$InitialOTPStateImpl) then) =
      __$$InitialOTPStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialOTPStateImplCopyWithImpl<$Res>
    extends _$OTPVerificationStateCopyWithImpl<$Res, _$InitialOTPStateImpl>
    implements _$$InitialOTPStateImplCopyWith<$Res> {
  __$$InitialOTPStateImplCopyWithImpl(
      _$InitialOTPStateImpl _value, $Res Function(_$InitialOTPStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InitialOTPStateImpl implements InitialOTPState {
  _$InitialOTPStateImpl();

  @override
  String toString() {
    return 'OTPVerificationState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialOTPStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() otpSending,
    required TResult Function(String? otp) otpSent,
    required TResult Function() otpVerifying,
    required TResult Function() otpVerified,
    required TResult Function() failure,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? otpSending,
    TResult? Function(String? otp)? otpSent,
    TResult? Function()? otpVerifying,
    TResult? Function()? otpVerified,
    TResult? Function()? failure,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? otpSending,
    TResult Function(String? otp)? otpSent,
    TResult Function()? otpVerifying,
    TResult Function()? otpVerified,
    TResult Function()? failure,
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
    required TResult Function(InitialOTPState value) initial,
    required TResult Function(OTPSendingState value) otpSending,
    required TResult Function(OTPSentState value) otpSent,
    required TResult Function(OTPVerifyingState value) otpVerifying,
    required TResult Function(OTPVerifiedState value) otpVerified,
    required TResult Function(OTPFailureState value) failure,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialOTPState value)? initial,
    TResult? Function(OTPSendingState value)? otpSending,
    TResult? Function(OTPSentState value)? otpSent,
    TResult? Function(OTPVerifyingState value)? otpVerifying,
    TResult? Function(OTPVerifiedState value)? otpVerified,
    TResult? Function(OTPFailureState value)? failure,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialOTPState value)? initial,
    TResult Function(OTPSendingState value)? otpSending,
    TResult Function(OTPSentState value)? otpSent,
    TResult Function(OTPVerifyingState value)? otpVerifying,
    TResult Function(OTPVerifiedState value)? otpVerified,
    TResult Function(OTPFailureState value)? failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class InitialOTPState implements OTPVerificationState {
  factory InitialOTPState() = _$InitialOTPStateImpl;
}

/// @nodoc
abstract class _$$OTPSendingStateImplCopyWith<$Res> {
  factory _$$OTPSendingStateImplCopyWith(_$OTPSendingStateImpl value,
          $Res Function(_$OTPSendingStateImpl) then) =
      __$$OTPSendingStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OTPSendingStateImplCopyWithImpl<$Res>
    extends _$OTPVerificationStateCopyWithImpl<$Res, _$OTPSendingStateImpl>
    implements _$$OTPSendingStateImplCopyWith<$Res> {
  __$$OTPSendingStateImplCopyWithImpl(
      _$OTPSendingStateImpl _value, $Res Function(_$OTPSendingStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$OTPSendingStateImpl implements OTPSendingState {
  _$OTPSendingStateImpl();

  @override
  String toString() {
    return 'OTPVerificationState.otpSending()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OTPSendingStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() otpSending,
    required TResult Function(String? otp) otpSent,
    required TResult Function() otpVerifying,
    required TResult Function() otpVerified,
    required TResult Function() failure,
  }) {
    return otpSending();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? otpSending,
    TResult? Function(String? otp)? otpSent,
    TResult? Function()? otpVerifying,
    TResult? Function()? otpVerified,
    TResult? Function()? failure,
  }) {
    return otpSending?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? otpSending,
    TResult Function(String? otp)? otpSent,
    TResult Function()? otpVerifying,
    TResult Function()? otpVerified,
    TResult Function()? failure,
    required TResult orElse(),
  }) {
    if (otpSending != null) {
      return otpSending();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialOTPState value) initial,
    required TResult Function(OTPSendingState value) otpSending,
    required TResult Function(OTPSentState value) otpSent,
    required TResult Function(OTPVerifyingState value) otpVerifying,
    required TResult Function(OTPVerifiedState value) otpVerified,
    required TResult Function(OTPFailureState value) failure,
  }) {
    return otpSending(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialOTPState value)? initial,
    TResult? Function(OTPSendingState value)? otpSending,
    TResult? Function(OTPSentState value)? otpSent,
    TResult? Function(OTPVerifyingState value)? otpVerifying,
    TResult? Function(OTPVerifiedState value)? otpVerified,
    TResult? Function(OTPFailureState value)? failure,
  }) {
    return otpSending?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialOTPState value)? initial,
    TResult Function(OTPSendingState value)? otpSending,
    TResult Function(OTPSentState value)? otpSent,
    TResult Function(OTPVerifyingState value)? otpVerifying,
    TResult Function(OTPVerifiedState value)? otpVerified,
    TResult Function(OTPFailureState value)? failure,
    required TResult orElse(),
  }) {
    if (otpSending != null) {
      return otpSending(this);
    }
    return orElse();
  }
}

abstract class OTPSendingState implements OTPVerificationState {
  factory OTPSendingState() = _$OTPSendingStateImpl;
}

/// @nodoc
abstract class _$$OTPSentStateImplCopyWith<$Res> {
  factory _$$OTPSentStateImplCopyWith(
          _$OTPSentStateImpl value, $Res Function(_$OTPSentStateImpl) then) =
      __$$OTPSentStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? otp});
}

/// @nodoc
class __$$OTPSentStateImplCopyWithImpl<$Res>
    extends _$OTPVerificationStateCopyWithImpl<$Res, _$OTPSentStateImpl>
    implements _$$OTPSentStateImplCopyWith<$Res> {
  __$$OTPSentStateImplCopyWithImpl(
      _$OTPSentStateImpl _value, $Res Function(_$OTPSentStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? otp = freezed,
  }) {
    return _then(_$OTPSentStateImpl(
      otp: freezed == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$OTPSentStateImpl implements OTPSentState {
  _$OTPSentStateImpl({this.otp});

  @override
  final String? otp;

  @override
  String toString() {
    return 'OTPVerificationState.otpSent(otp: $otp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OTPSentStateImpl &&
            (identical(other.otp, otp) || other.otp == otp));
  }

  @override
  int get hashCode => Object.hash(runtimeType, otp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OTPSentStateImplCopyWith<_$OTPSentStateImpl> get copyWith =>
      __$$OTPSentStateImplCopyWithImpl<_$OTPSentStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() otpSending,
    required TResult Function(String? otp) otpSent,
    required TResult Function() otpVerifying,
    required TResult Function() otpVerified,
    required TResult Function() failure,
  }) {
    return otpSent(otp);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? otpSending,
    TResult? Function(String? otp)? otpSent,
    TResult? Function()? otpVerifying,
    TResult? Function()? otpVerified,
    TResult? Function()? failure,
  }) {
    return otpSent?.call(otp);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? otpSending,
    TResult Function(String? otp)? otpSent,
    TResult Function()? otpVerifying,
    TResult Function()? otpVerified,
    TResult Function()? failure,
    required TResult orElse(),
  }) {
    if (otpSent != null) {
      return otpSent(otp);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialOTPState value) initial,
    required TResult Function(OTPSendingState value) otpSending,
    required TResult Function(OTPSentState value) otpSent,
    required TResult Function(OTPVerifyingState value) otpVerifying,
    required TResult Function(OTPVerifiedState value) otpVerified,
    required TResult Function(OTPFailureState value) failure,
  }) {
    return otpSent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialOTPState value)? initial,
    TResult? Function(OTPSendingState value)? otpSending,
    TResult? Function(OTPSentState value)? otpSent,
    TResult? Function(OTPVerifyingState value)? otpVerifying,
    TResult? Function(OTPVerifiedState value)? otpVerified,
    TResult? Function(OTPFailureState value)? failure,
  }) {
    return otpSent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialOTPState value)? initial,
    TResult Function(OTPSendingState value)? otpSending,
    TResult Function(OTPSentState value)? otpSent,
    TResult Function(OTPVerifyingState value)? otpVerifying,
    TResult Function(OTPVerifiedState value)? otpVerified,
    TResult Function(OTPFailureState value)? failure,
    required TResult orElse(),
  }) {
    if (otpSent != null) {
      return otpSent(this);
    }
    return orElse();
  }
}

abstract class OTPSentState implements OTPVerificationState {
  factory OTPSentState({final String? otp}) = _$OTPSentStateImpl;

  String? get otp;
  @JsonKey(ignore: true)
  _$$OTPSentStateImplCopyWith<_$OTPSentStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OTPVerifyingStateImplCopyWith<$Res> {
  factory _$$OTPVerifyingStateImplCopyWith(_$OTPVerifyingStateImpl value,
          $Res Function(_$OTPVerifyingStateImpl) then) =
      __$$OTPVerifyingStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OTPVerifyingStateImplCopyWithImpl<$Res>
    extends _$OTPVerificationStateCopyWithImpl<$Res, _$OTPVerifyingStateImpl>
    implements _$$OTPVerifyingStateImplCopyWith<$Res> {
  __$$OTPVerifyingStateImplCopyWithImpl(_$OTPVerifyingStateImpl _value,
      $Res Function(_$OTPVerifyingStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$OTPVerifyingStateImpl implements OTPVerifyingState {
  _$OTPVerifyingStateImpl();

  @override
  String toString() {
    return 'OTPVerificationState.otpVerifying()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OTPVerifyingStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() otpSending,
    required TResult Function(String? otp) otpSent,
    required TResult Function() otpVerifying,
    required TResult Function() otpVerified,
    required TResult Function() failure,
  }) {
    return otpVerifying();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? otpSending,
    TResult? Function(String? otp)? otpSent,
    TResult? Function()? otpVerifying,
    TResult? Function()? otpVerified,
    TResult? Function()? failure,
  }) {
    return otpVerifying?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? otpSending,
    TResult Function(String? otp)? otpSent,
    TResult Function()? otpVerifying,
    TResult Function()? otpVerified,
    TResult Function()? failure,
    required TResult orElse(),
  }) {
    if (otpVerifying != null) {
      return otpVerifying();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialOTPState value) initial,
    required TResult Function(OTPSendingState value) otpSending,
    required TResult Function(OTPSentState value) otpSent,
    required TResult Function(OTPVerifyingState value) otpVerifying,
    required TResult Function(OTPVerifiedState value) otpVerified,
    required TResult Function(OTPFailureState value) failure,
  }) {
    return otpVerifying(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialOTPState value)? initial,
    TResult? Function(OTPSendingState value)? otpSending,
    TResult? Function(OTPSentState value)? otpSent,
    TResult? Function(OTPVerifyingState value)? otpVerifying,
    TResult? Function(OTPVerifiedState value)? otpVerified,
    TResult? Function(OTPFailureState value)? failure,
  }) {
    return otpVerifying?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialOTPState value)? initial,
    TResult Function(OTPSendingState value)? otpSending,
    TResult Function(OTPSentState value)? otpSent,
    TResult Function(OTPVerifyingState value)? otpVerifying,
    TResult Function(OTPVerifiedState value)? otpVerified,
    TResult Function(OTPFailureState value)? failure,
    required TResult orElse(),
  }) {
    if (otpVerifying != null) {
      return otpVerifying(this);
    }
    return orElse();
  }
}

abstract class OTPVerifyingState implements OTPVerificationState {
  factory OTPVerifyingState() = _$OTPVerifyingStateImpl;
}

/// @nodoc
abstract class _$$OTPVerifiedStateImplCopyWith<$Res> {
  factory _$$OTPVerifiedStateImplCopyWith(_$OTPVerifiedStateImpl value,
          $Res Function(_$OTPVerifiedStateImpl) then) =
      __$$OTPVerifiedStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OTPVerifiedStateImplCopyWithImpl<$Res>
    extends _$OTPVerificationStateCopyWithImpl<$Res, _$OTPVerifiedStateImpl>
    implements _$$OTPVerifiedStateImplCopyWith<$Res> {
  __$$OTPVerifiedStateImplCopyWithImpl(_$OTPVerifiedStateImpl _value,
      $Res Function(_$OTPVerifiedStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$OTPVerifiedStateImpl implements OTPVerifiedState {
  _$OTPVerifiedStateImpl();

  @override
  String toString() {
    return 'OTPVerificationState.otpVerified()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OTPVerifiedStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() otpSending,
    required TResult Function(String? otp) otpSent,
    required TResult Function() otpVerifying,
    required TResult Function() otpVerified,
    required TResult Function() failure,
  }) {
    return otpVerified();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? otpSending,
    TResult? Function(String? otp)? otpSent,
    TResult? Function()? otpVerifying,
    TResult? Function()? otpVerified,
    TResult? Function()? failure,
  }) {
    return otpVerified?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? otpSending,
    TResult Function(String? otp)? otpSent,
    TResult Function()? otpVerifying,
    TResult Function()? otpVerified,
    TResult Function()? failure,
    required TResult orElse(),
  }) {
    if (otpVerified != null) {
      return otpVerified();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialOTPState value) initial,
    required TResult Function(OTPSendingState value) otpSending,
    required TResult Function(OTPSentState value) otpSent,
    required TResult Function(OTPVerifyingState value) otpVerifying,
    required TResult Function(OTPVerifiedState value) otpVerified,
    required TResult Function(OTPFailureState value) failure,
  }) {
    return otpVerified(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialOTPState value)? initial,
    TResult? Function(OTPSendingState value)? otpSending,
    TResult? Function(OTPSentState value)? otpSent,
    TResult? Function(OTPVerifyingState value)? otpVerifying,
    TResult? Function(OTPVerifiedState value)? otpVerified,
    TResult? Function(OTPFailureState value)? failure,
  }) {
    return otpVerified?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialOTPState value)? initial,
    TResult Function(OTPSendingState value)? otpSending,
    TResult Function(OTPSentState value)? otpSent,
    TResult Function(OTPVerifyingState value)? otpVerifying,
    TResult Function(OTPVerifiedState value)? otpVerified,
    TResult Function(OTPFailureState value)? failure,
    required TResult orElse(),
  }) {
    if (otpVerified != null) {
      return otpVerified(this);
    }
    return orElse();
  }
}

abstract class OTPVerifiedState implements OTPVerificationState {
  factory OTPVerifiedState() = _$OTPVerifiedStateImpl;
}

/// @nodoc
abstract class _$$OTPFailureStateImplCopyWith<$Res> {
  factory _$$OTPFailureStateImplCopyWith(_$OTPFailureStateImpl value,
          $Res Function(_$OTPFailureStateImpl) then) =
      __$$OTPFailureStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OTPFailureStateImplCopyWithImpl<$Res>
    extends _$OTPVerificationStateCopyWithImpl<$Res, _$OTPFailureStateImpl>
    implements _$$OTPFailureStateImplCopyWith<$Res> {
  __$$OTPFailureStateImplCopyWithImpl(
      _$OTPFailureStateImpl _value, $Res Function(_$OTPFailureStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$OTPFailureStateImpl implements OTPFailureState {
  _$OTPFailureStateImpl();

  @override
  String toString() {
    return 'OTPVerificationState.failure()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OTPFailureStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() otpSending,
    required TResult Function(String? otp) otpSent,
    required TResult Function() otpVerifying,
    required TResult Function() otpVerified,
    required TResult Function() failure,
  }) {
    return failure();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? otpSending,
    TResult? Function(String? otp)? otpSent,
    TResult? Function()? otpVerifying,
    TResult? Function()? otpVerified,
    TResult? Function()? failure,
  }) {
    return failure?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? otpSending,
    TResult Function(String? otp)? otpSent,
    TResult Function()? otpVerifying,
    TResult Function()? otpVerified,
    TResult Function()? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InitialOTPState value) initial,
    required TResult Function(OTPSendingState value) otpSending,
    required TResult Function(OTPSentState value) otpSent,
    required TResult Function(OTPVerifyingState value) otpVerifying,
    required TResult Function(OTPVerifiedState value) otpVerified,
    required TResult Function(OTPFailureState value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InitialOTPState value)? initial,
    TResult? Function(OTPSendingState value)? otpSending,
    TResult? Function(OTPSentState value)? otpSent,
    TResult? Function(OTPVerifyingState value)? otpVerifying,
    TResult? Function(OTPVerifiedState value)? otpVerified,
    TResult? Function(OTPFailureState value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InitialOTPState value)? initial,
    TResult Function(OTPSendingState value)? otpSending,
    TResult Function(OTPSentState value)? otpSent,
    TResult Function(OTPVerifyingState value)? otpVerifying,
    TResult Function(OTPVerifiedState value)? otpVerified,
    TResult Function(OTPFailureState value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class OTPFailureState implements OTPVerificationState {
  factory OTPFailureState() = _$OTPFailureStateImpl;
}
