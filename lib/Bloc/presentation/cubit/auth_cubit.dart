import 'package:beacon/Bloc/core/resources/data_state.dart';
import 'package:beacon/Bloc/domain/entities/user/user_entity.dart';
import 'package:beacon/Bloc/domain/usecase/auth_usecase.dart';
import 'package:beacon/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AuthState {
  final UserEntity? user;
  final String? message;
  final String? error;

  AuthState({this.error, this.message, this.user});
}

class IconToggled extends AuthState {
  final bool isIconChecked;

  IconToggled(this.isIconChecked);
}

class InitialAuthState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthErrorState extends AuthState {
  final String? error;
  AuthErrorState({required this.error});
}

class SuccessState extends AuthState {
  final String? message;
  final UserEntity? user;
  SuccessState({this.message, this.user});
}

class AuthCubit extends Cubit<AuthState> {
  final AuthUseCase authUseCase;
  AuthCubit({required this.authUseCase}) : super(InitialAuthState());

  Future<void> register(
    String name,
    String email,
    String password,
  ) async {
    emit(AuthLoadingState());
    final state = await authUseCase.registerUseCase(name, email, password);
    if (state is DataFailed) {
      emit(AuthErrorState(error: state.error));
    } else {
      emit(SuccessState(user: state.data));
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoadingState());
    final state = await authUseCase.loginUserCase(email, password);
    if (state is DataFailed) {
      emit(AuthErrorState(error: state.error));
    } else {
      emit(SuccessState(user: state.data));
    }
  }

  Future<void> fetchUserInfo() async {
    final userInfo = await authUseCase.getUserInfoUseCase();

    if (userInfo is DataFailed) {
      emit(AuthErrorState(error: userInfo.error!));
    } else {
      emit(SuccessState(user: userInfo.data));
    }
  }

  requestFocus(FocusNode focusNode, BuildContext context) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  Future<bool> isGuest() async {
    bool? isguest = await localApi.userModel.isGuest;

    return isguest!;
  }
}
