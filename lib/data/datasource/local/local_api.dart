import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:beacon/data/models/beacon/beacon_model.dart';
import 'package:beacon/data/models/group/group_model.dart';
import 'package:beacon/data/models/landmark/landmark_model.dart';
import 'package:beacon/data/models/location/location_model.dart';
import 'package:beacon/data/models/user/user_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class LocalApi {
  String userModelbox = 'userBox';
  String groupModelBox = 'groupBox';
  String beaconModelBox = 'beaconBox';
  String locationModelBox = 'locationBox';
  String landMarkModelBox = 'landMarkBox';
  String nearbyBeaconModelBox = 'nearbybeaconBox';

  late Box<UserModel> userBox;
  late Box<GroupModel> groupBox;
  late Box<BeaconModel> beaconBox;
  late Box<BeaconModel> nearbyBeaconBox;
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
    !Hive.isAdapterRegistered(20)
        ? Hive.registerAdapter(BeaconModelAdapter())
        : null;
    !Hive.isAdapterRegistered(30)
        ? Hive.registerAdapter(GroupModelAdapter())
        : null;

    !Hive.isAdapterRegistered(40)
        ? Hive.registerAdapter(LocationModelAdapter())
        : null;
    !Hive.isAdapterRegistered(50)
        ? Hive.registerAdapter(LandMarkModelAdapter())
        : null;

    try {
      userBox = await Hive.openBox<UserModel>(userModelbox);
      groupBox = await Hive.openBox<GroupModel>(groupModelBox);
      beaconBox = await Hive.openBox<BeaconModel>(beaconModelBox);
      nearbyBeaconBox = await Hive.openBox<BeaconModel>(nearbyBeaconModelBox);
      locationBox = await Hive.openBox<LocationModel>(locationModelBox);
      landMarkbox = await Hive.openBox<LandMarkModel>(landMarkModelBox);
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
      log(e.toString());
      return false;
    }
  }

  Future<void> deleteUser() async {
    // clearing the info

    try {
      _userModel.copyWithModel(
          authToken: null,
          beacons: null,
          email: null,
          groups: null,
          id: null,
          isGuest: null,
          location: null,
          name: null);
      await userBox.clear();
      await groupBox.clear();
      await beaconBox.clear();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<UserModel?> fetchUser() async {
    try {
      final user = await userBox.get('currentUser');
      return user;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<bool?> userloggedIn() async {
    try {
      UserModel? user = await userBox.get('currentUser');

      if (user == null) {
        return false;
      }
      _userModel = user;
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool?> saveGroup(GroupModel group) async {
    await deleteGroup(group.id);
    try {
      await groupBox.put(group.id, group);
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool?> deleteGroup(String? groupId) async {
    try {
      bool doesExist = await groupBox.containsKey(groupId);
      doesExist ? await groupBox.delete(groupId) : null;
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<GroupModel?> getGroup(String? groupId) async {
    try {
      final group = await groupBox.get(groupId);
      return group;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<bool?> saveBeacon(BeaconModel beacon) async {
    try {
      await deleteBeacon(beacon.id);
      await beaconBox.put(beacon.id, beacon);
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> savenearbyBeacons(BeaconModel beacon) async {
    try {
      await deleteBeacon(beacon.id);
      await nearbyBeaconBox.put(beacon.id, beacon);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool?> deleteBeacon(String? beaconId) async {
    try {
      bool doesExist = await beaconBox.containsKey(beaconId);
      doesExist ? await beaconBox.delete(beaconId) : null;
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<BeaconModel?> getBeacon(String? beaconId) async {
    try {
      final beacon = await beaconBox.get(beaconId);
      return beacon;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
