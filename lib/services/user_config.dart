import 'dart:async';
import 'package:beacon/models/user/user_info.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../locator.dart';

class UserConfig {
  User _currentUser = User(id: 'null', authToken: 'null');
  User get currentUser => _currentUser;

  Future<bool> userLoggedIn() async {
    final boxUser = Hive.box<User>('currentUser');
    _currentUser = boxUser.get('user');
    if (_currentUser == null) {
      _currentUser = User(id: 'null', authToken: 'null');
      return false;
    }
    bool userUpdated = true;
    await graphqlConfig.getToken().then((value) async {
      print('${userConfig._currentUser.authToken}');
      await databaseFunctions.init();
      await databaseFunctions.fetchCurrentUserInfo().then((value) {
        if (value) {
          saveUserInHive();
          userUpdated = true;
        } else {
          navigationService.showSnackBar("Couldn't update User details");
          userUpdated = false;
        }
      });
    });
    print('user updated: $userUpdated');
    return userUpdated;
  }

  Future<bool> updateUser(User updatedUserDetails) async {
    try {
      _currentUser = updatedUserDetails;
      print("User is guest or not: ${updatedUserDetails.isGuest}");
      saveUserInHive();
      return true;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  saveUserInHive() {
    final box = Hive.box<User>('currentUser');
    if (box.get('user') == null) {
      box.put('user', _currentUser);
    } else {
      box.put('user', _currentUser);
    }
  }
}
