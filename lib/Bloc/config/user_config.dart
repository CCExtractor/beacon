import 'package:beacon/Bloc/data/models/user/user_model.dart';
import 'package:beacon/locator.dart';

class UserModelConfig {
  UserModel _userModel = UserModel(authToken: 'null');
  UserModel get userModel => _userModel;

  Future<bool> updateUser(UserModel updateUserDetails) async {
    _userModel = updateUserDetails;
    return localApi.saveUser(updateUserDetails);
  }
}
