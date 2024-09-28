import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';

abstract class AuthRepository {
  // userinfo function
  Future<DataState<UserEntity>> getUser();

  // Signup function
  Future<DataState<UserEntity>> register(
      String name, String email, String password);

  // Login function
  Future<DataState<UserEntity>> login(String email, String password);

  Future<DataState<UserEntity>> oAuth(String name, String email);

  Future<DataState<String>> sendVerificationCode();

  Future<DataState<UserEntity>> completeVerification();
}
