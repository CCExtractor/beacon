import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/domain/usecase/auth_usecase.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/presentation/auth/verification_cubit/verification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerificationCubit extends Cubit<OTPVerificationState> {
  AuthUseCase _authUseCase;
  VerificationCubit(this._authUseCase) : super(InitialOTPState());

  emitVerificationSentstate(String otp) {
    emit(OTPSentState(otp: otp));
  }

  _clear() async {
    await sp.deleteData('time');
    await sp.deleteData('otp');
  }

  Future<void> sendEmailVerification() async {
    emit(OTPSendingState());
    final dataState = await _authUseCase.sendVerificationCode();

    if (dataState is DataSuccess && dataState.data != null) {
      await sp.init();
      await sp.saveData('time', DateTime.now().toIso8601String());
      await sp.saveData('otp', dataState.data!);
      emit(OTPSentState(otp: dataState.data));
    } else {
      emit(OTPFailureState());
    }
  }

  Future<void> completeVerification() async {
    emit(OTPVerifyingState());

    final dataState = await _authUseCase.completeVerification();

    if (dataState is DataSuccess && dataState.data != null) {
      _clear();
      appRouter.replaceNamed('/home');
    } else if (dataState is DataFailed) {
      emit(OTPFailureState());
    }
  }
}
