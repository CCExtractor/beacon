import 'package:freezed_annotation/freezed_annotation.dart';

part 'verification_state.freezed.dart';

@freezed
class OTPVerificationState with _$OTPVerificationState {
  factory OTPVerificationState.initial() = InitialOTPState;
  factory OTPVerificationState.otpSending() = OTPSendingState;
  factory OTPVerificationState.otpSent({String? otp}) = OTPSentState;
  factory OTPVerificationState.otpVerifying() = OTPVerifyingState;
  factory OTPVerificationState.otpVerified() = OTPVerifiedState;
  factory OTPVerificationState.failure() = OTPFailureState;
}
