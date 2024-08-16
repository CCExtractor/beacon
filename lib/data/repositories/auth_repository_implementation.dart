import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/data/datasource/remote/remote_auth_api.dart';
import 'package:beacon/data/models/user/user_model.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:beacon/domain/repositories/auth_repository.dart';

class AuthRepositoryImplementation implements AuthRepository {
  final RemoteAuthApi remoteAuthApi;

  AuthRepositoryImplementation({required this.remoteAuthApi});

  @override
  Future<DataState<UserModel>> getUser() {
    return remoteAuthApi.fetchUserInfo();
  }

  @override
  Future<DataState<UserEntity>> login(String email, String password) {
    return remoteAuthApi.login(email, password);
  }

  @override
  Future<DataState<UserEntity>> oAuth(String name, String email) {
    return remoteAuthApi.gAuth(name, email);
  }

  @override
  Future<DataState<UserEntity>> register(
      String name, String email, String password) {
    return remoteAuthApi.register(name, email, password);
  }

  Future<DataState<String>> sendVerificationCode() {
    return remoteAuthApi.sendVerificationCode();
  }

  @override
  Future<DataState<UserEntity>> completeVerification() {
    return remoteAuthApi.completeVerification();
  }
}
