import 'package:beacon/Bloc/core/resources/data_state.dart';
import 'package:beacon/Bloc/domain/entities/user/user_entity.dart';
import 'package:beacon/Bloc/domain/repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository authRepository;

  AuthUseCase({required this.authRepository});

  Future<DataState<UserEntity>> registerUseCase(
      String name, String email, String password) async {
    return await authRepository.register(name, email, password);
  }

  Future<DataState<UserEntity>> loginUserCase(
      String email, String password) async {
    return await authRepository.login(email, password);
  }

  Future<DataState<UserEntity>> getUserInfoUseCase() async {
    return await authRepository.getUser();
  }
}
