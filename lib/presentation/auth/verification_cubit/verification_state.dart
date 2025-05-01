import 'package:freezed_annotation/freezed_annotation.dart';

part 'verification_state.freezed.dart';

@freezed
class OTPVerificationState with _$OTPVerificationState {
  const factory OTPVerificationState.initial() = InitialOTPState;
  const factory OTPVerificationState.otpSending() = OTPSendingState;
  const factory OTPVerificationState.otpSent({String? otp}) = OTPSentState;
  const factory OTPVerificationState.otpVerifying() = OTPVerifyingState;
  const factory OTPVerificationState.otpVerified() = OTPVerifiedState;
  const factory OTPVerificationState.failure({String? errorMessage}) = OTPFailureState;
}
