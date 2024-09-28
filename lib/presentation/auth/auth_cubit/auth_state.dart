import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.initial() = InitialAuthState;

  const factory AuthState.loading() = AuthLoadingState;

  const factory AuthState.error({String? error}) = AuthErrorState;

  const factory AuthState.success({String? message}) = SuccessState;

  const factory AuthState.verify() = AuthVerificationState;
}
