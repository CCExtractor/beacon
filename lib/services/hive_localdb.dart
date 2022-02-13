import 'package:beacon/locator.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/models/landmarks/landmark.dart';
import 'package:beacon/models/location/location.dart';
import 'package:beacon/models/user/user_info.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class HiveLocalDb {
  Box<User> currentUserBox;
  Box<Beacon> beaconsBox;

  Future<void> init() async {
    final appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive
      ..init(appDocumentDirectory.path)
      ..registerAdapter(UserAdapter())
      ..registerAdapter(BeaconAdapter())
      ..registerAdapter(LocationAdapter())
      ..registerAdapter(LandmarkAdapter());
    currentUserBox = await Hive.openBox<User>('currentUser');
    beaconsBox = await Hive.openBox<Beacon>('beacons');
  }

  Future<void> saveUserInHive(User currentUser) async {
    final box = currentUserBox;
    if (currentUserBox.containsKey('user')) {
      currentUserBox.delete('user');
    }
    return await box.put('user', currentUser);
  }

  Future<void> putBeaconInBeaconBox(String id, Beacon beacon,
      {bool fetchFromNetwork = false}) async {
    if (beaconsBox.containsKey(id)) {
      await beaconsBox.delete(id);
    }
    if (fetchFromNetwork) {
      databaseFunctions.init();
      beacon = await databaseFunctions.fetchBeaconInfo(id);
    }
    await beaconsBox.put(id, beacon);
  }

  List<Beacon> getAllUserBeacons() {
    final user = currentUserBox.get('user');
    print("asd" + user.id);
    if (user == null) {
      navigationService
          .showSnackBar('Please connect to internet to fetch your beacons');
      return null;
    }
    final userBeacons = beaconsBox.values.toList();
    if (userBeacons == null) {
      return user.beacon;
    }
    return userBeacons;
  }
}
