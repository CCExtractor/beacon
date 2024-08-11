import 'package:beacon/config/router/router.dart';
import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/domain/usecase/auth_usecase.dart';
import 'package:beacon/presentation/auth/auth_cubit/auth_state.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/presentation/auth/verification_cubit/verification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  static AuthCubit? _instance;
  final AuthUseCase authUseCase;
  AuthCubit._internal({required this.authUseCase}) : super(InitialAuthState());

  factory AuthCubit(AuthUseCase authUseCase) {
    return _instance ?? AuthCubit._internal(authUseCase: authUseCase);
  }

  Future<void> register(
    String name,
    String email,
    String password,
  ) async {
    emit(AuthLoadingState());
    final dataState = await authUseCase.registerUseCase(name, email, password);
    if (dataState is DataSuccess && dataState.data != null) {
      if (dataState.data!.isVerified == false) {
        // show verification screen
        emit(AuthVerificationState());
      } else {
        emit(SuccessState(message: "Welcome"));
      }
    } else {
      emit(AuthErrorState(error: dataState.error!));
    }
  }

  Future<void> navigate() async {
    await sp.deleteData('time');
    await sp.deleteData('otp');
    await locator<VerificationCubit>().sendEmailVerification();
    appRouter.replace(VerificationScreenRoute());
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoadingState());
    final dataState = await authUseCase.loginUserCase(email, password);

    if (dataState is DataSuccess && dataState.data != null) {
      if (dataState.data!.isVerified == false) {
        // show verification screen
        emit(AuthVerificationState());
      } else {
        emit(SuccessState());
      }
    } else {
      emit(AuthErrorState(error: dataState.error!));
    }
  }

  void requestFocus(FocusNode focusNode, BuildContext context) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  Future<bool> isGuest() async {
    bool? isguest = await localApi.userModel.isGuest;
    return isguest!;
  }
}
