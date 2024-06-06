import 'dart:async';
import 'dart:developer';

import 'dart:io';
import 'package:beacon/Bloc/data/models/beacon/beacon_model.dart';
import 'package:beacon/Bloc/data/models/group/group_model.dart';
import 'package:beacon/Bloc/data/models/landmark/landmark_model.dart';
import 'package:beacon/Bloc/data/models/location/location_model.dart';
import 'package:beacon/Bloc/data/models/user/user_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class LocalApi {
  String userModelbox = 'userBox';
  String groupModelBox = 'groupBox';
  String beaconModelBox = 'beaconBox';
  String locationModelBox = 'locationBox';
  String landMarkModelBox = 'landMarkBox';

  late Box<UserModel> userBox;
  late Box<GroupModel> groupBox;
  late Box<BeaconModel> beaconBox;
  late Box<LocationModel> locationBox;
  late Box<LandMarkModel> landMarkbox;

  UserModel _userModel = UserModel(authToken: null);
  UserModel get userModel => _userModel;

  init() async {
    Directory directory =
        await path_provider.getApplicationDocumentsDirectory();

    Hive.init(directory.path);

    !Hive.isAdapterRegistered(10)
        ? Hive.registerAdapter(UserModelAdapter())
        : null;
    // !Hive.isAdapterRegistered(20)
    //     ? Hive.registerAdapter(BeaconModelAdapter())
    //     : null;
    // !Hive.isAdapterRegistered(30)
    //     ? Hive.registerAdapter(GroupModelAdapter())
    //     : null;
    // !Hive.isAdapterRegistered(40)
    //     ? Hive.registerAdapter(LocationModelAdapter())
    //     : null;
    // !Hive.isAdapterRegistered(50)
    //     ? Hive.registerAdapter(LandMarkModelAdapter())
    //     : null;

    try {
      userBox = await Hive.openBox<UserModel>(userModelbox);
      // groupBox = await Hive.openBox<GroupModel>(groupModelBox);
      // beaconBox = await Hive.openBox<BeaconModel>(beaconModelBox);
      // locationBox = await Hive.openBox<LocationModel>(locationModelBox);
      // landMarkbox = await Hive.openBox<LandMarkModel>(landMarkModelBox);
    } catch (e) {
      log('error: ${e.toString()}');
    }
  }

  Future<bool> saveUser(UserModel user) async {
    try {
      _userModel = user;
      await userBox.put('currentUser', user);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteUser() async {
    // clearing the info
    _userModel.copyWithModel(
        authToken: null,
        beacons: null,
        email: null,
        groups: null,
        id: null,
        isGuest: null,
        location: null,
        name: null);
    await userBox.delete('currentUser');
  }

  Future<UserModel?> fetchUser() async {
    userBox = await Hive.openBox<UserModel>(userModelbox);
    final user = await userBox.get('currentUser');
    return user;
  }

  Future<bool?> userloggedIn() async {
    UserModel? user = await userBox.get('currentUser');

    if (user == null) {
      return false;
    }
    _userModel = user;
    return true;
  }
}
