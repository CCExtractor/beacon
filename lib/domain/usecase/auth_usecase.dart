import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:beacon/domain/repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository authRepository;

  AuthUseCase({required this.authRepository});

  Future<DataState<UserEntity>> registerUseCase(
      String name, String email, String password) async {
    return authRepository.register(name, email, password);
  }

  Future<DataState<UserEntity>> loginUserCase(
      String email, String password) async {
    return authRepository.login(email, password);
  }

  Future<DataState<UserEntity>> oAuthUseCase(String name, String email) async {
    return authRepository.oAuth(name, email);
  }

  Future<DataState<UserEntity>> getUserInfoUseCase() async {
    return authRepository.getUser();
  }

  Future<DataState<String>> sendVerificationCode() {
    return authRepository.sendVerificationCode();
  }

  Future<DataState<UserEntity>> completeVerification() {
    return authRepository.completeVerification();
  }
}
