import 'package:beacon/Bloc/core/resources/data_state.dart';
import 'package:beacon/Bloc/domain/entities/user/user_entity.dart';

abstract class AuthRepository {
  // userinfo function
  Future<DataState<UserEntity>> getUser();

  // Signup function
  Future<DataState<UserEntity>> register(
      String name, String email, String password);

  // Login function
  Future<DataState<UserEntity>> login(String email, String password);
}
