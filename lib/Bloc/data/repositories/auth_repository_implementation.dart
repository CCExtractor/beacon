import 'package:beacon/Bloc/core/resources/data_state.dart';
import 'package:beacon/Bloc/data/datasource/remote/remote_auth_api.dart';
import 'package:beacon/Bloc/data/models/user/user_model.dart';
import 'package:beacon/Bloc/domain/repositories/auth_repository.dart';

class AuthRepositoryImplementation extends AuthRepository {
  final RemoteAuthApi remoteAuthApi;

  AuthRepositoryImplementation({required this.remoteAuthApi});

  @override
  Future<DataState<UserModel>> getUser() {
    return remoteAuthApi.fetchUserInfo();
  }

  @override
  Future<DataState<UserModel>> login(String email, String password) {
    return remoteAuthApi.login(email, password);
  }

  @override
  Future<DataState<UserModel>> register(
      String name, String email, String password) {
    return remoteAuthApi.register(name, email, password);
  }
}
