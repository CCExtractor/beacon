import 'package:beacon/enums/view_state.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:beacon/view_model/base_view_model.dart';
import 'package:beacon/views/hike_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class GroupViewModel extends BaseModel {
  final formKeyCreate = GlobalKey<FormState>();
  final formKeyJoin = GlobalKey<FormState>();
  Duration? resultingDuration = Duration(minutes: 30);
  AutovalidateMode validate = AutovalidateMode.onUserInteraction;
  late DateTime startsAt;
  DateTime? startingdate;
  TimeOfDay? startingTime;
  bool isCreatingHike = false;
  String? title;
  late bool hasStarted;
  String? groupID;
  //commenting out since its value isnt used anywhere.
  //TextEditingController _titleController = new TextEditingController();
  TextEditingController durationController = new TextEditingController();
  TextEditingController startsAtDate = new TextEditingController();
  TextEditingController startsAtTime = new TextEditingController();
  String? enteredPasskey;

  bool showName = false;
  bool loadingUserBeacons = false;
  List<Beacon> userBeacons = [];
  bool loadingNearbyBeacons = false;
  List<Beacon> nearByBeacons = [];

  toogleShowName(bool value) {
    showName = value;
    notifyListeners();
  }

  clearGroupInfo() {
    userBeacons.clear();
    nearByBeacons.clear();
  }

  fetchGroupDetails(String groupId) async {
    // starting loading indicator
    loadingUserBeacons = true;
    loadingNearbyBeacons = true;
    notifyListeners();

    // fetching group beacons
    List<Beacon?> groupBeacons =
        await databaseFunctions!.fetchUserBeacons(groupId);

    for (Beacon? beacon in groupBeacons) {
      if (beacon != null) {
        userBeacons.add(beacon);
      }
    }

    // sorting nearby beacons under 1.5 KM radius from userbeacons
    fetchNearByBeacons(userBeacons);

    loadingUserBeacons = false;
    notifyListeners();
  }

  fetchNearByBeacons(List<Beacon> groupBeacons) async {
    LatLng currentLocation = await AppConstants.getLocation();

    for (Beacon beacon in groupBeacons) {
      double distance = await AppConstants().calculateDistance(
          currentLocation.latitude,
          currentLocation.longitude,
          double.parse(beacon.location!.lat!),
          double.parse(beacon.location!.lon!));
      if (distance < 1.5) {
        nearByBeacons.add(beacon);
      }
    }
    // turning off loading widget
    loadingNearbyBeacons = false;
    notifyListeners();
  }

  checkNearByBeacon(Beacon beacon) async {
    LatLng currentLocation = await AppConstants.getLocation();

    double distance = await AppConstants().calculateDistance(
        currentLocation.latitude,
        currentLocation.longitude,
        double.parse(beacon.location!.lat!),
        double.parse(beacon.location!.lon!));
    if (distance < 1.5) {
      nearByBeacons.add(beacon);
      List<Beacon> beacons = beaconsSorting(nearByBeacons);
      nearByBeacons.clear();
      nearByBeacons.addAll(beacons);
    }
  }

  createHikeRoom(String? groupID) async {
    FocusScope.of(navigationService!.navigatorKey.currentContext!).unfocus();
    validate = AutovalidateMode.always;
    if (formKeyCreate.currentState!.validate()) {
      navigationService!.pop();
      setState(ViewState.busy);
      validate = AutovalidateMode.disabled;
      databaseFunctions!.init();
      final Beacon? beacon = await databaseFunctions!.createBeacon(
          title,
          startsAt.millisecondsSinceEpoch.toInt(),
          startsAt.add(resultingDuration!).millisecondsSinceEpoch.toInt(),
          groupID,
          showName);
      // setState(ViewState.idle);
      if (beacon != null) {
        // adding beacons and then sorting
        userBeacons.add(beacon);
        List<Beacon> beacons = beaconsSorting(userBeacons);
        userBeacons.clear();
        userBeacons.addAll(beacons);
        notifyListeners();

        // checking if new beacon created is nearby or not
        checkNearByBeacon(beacon);
        notifyListeners();

        hasStarted = DateTime.now()
            .isAfter(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt!));
        if (hasStarted) {
          navigationService!.pushScreen('/hikeScreen',
              arguments: HikeScreen(
                beacon,
                isLeader: true,
              ));
        } else {
          localNotif!.scheduleNotification(beacon);
          setState(ViewState.idle);
          navigationService!.showSnackBar(
            'Beacon has not yet started! \nPlease come back at ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt!)).toString()}',
          );
          return;
        }
      } else {
        // navigationService.showSnackBar('Something went wrong');
        setState(ViewState.idle);
      }
    }
  }

  joinHikeRoom() async {
    FocusScope.of(navigationService!.navigatorKey.currentContext!).unfocus();
    validate = AutovalidateMode.always;
    if (formKeyJoin.currentState!.validate()) {
      setState(ViewState.busy);
      validate = AutovalidateMode.disabled;
      databaseFunctions!.init();
      final Beacon? beacon =
          await databaseFunctions!.joinBeacon(enteredPasskey);
      // setState(ViewState.idle);
      if (beacon != null) {
        hasStarted = DateTime.now()
            .isAfter(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt!));
        // adding beacons and then sorting
        userBeacons.add(beacon);
        List<Beacon> beacons = beaconsSorting(userBeacons);
        userBeacons.clear();
        userBeacons.addAll(beacons);
        notifyListeners();

        // checking if new beacon created is nearby or not
        checkNearByBeacon(beacon);
        notifyListeners();
        if (hasStarted) {
          navigationService!.pushScreen('/hikeScreen',
              arguments: HikeScreen(beacon, isLeader: false));
        } else {
          localNotif!.scheduleNotification(beacon);
          setState(ViewState.idle);
          // reloadList();
          navigationService!.showSnackBar(
            'Beacon has not yet started! \nPlease come back at ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt!)).toString()}',
          );
          return;
        }
      } else {
        //there was some error, go back to homescreen.
        setState(ViewState.idle);
      }
      //Snackbar is displayed by joinBeacon itself on any error or trying to join expired beacon.
    } else {
      navigationService!.showSnackBar('Enter Valid Passkey');
    }
  }

  List<Beacon> beaconsSorting(List<Beacon?> beacons) {
    List<Beacon> expiredBeacons = [];
    List<Beacon> workingBeacons = [];

    for (var beacon in beacons) {
      if (beacon != null) {
        if (DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt!)
            .isBefore(DateTime.now())) {
          expiredBeacons.insert(0, beacon);
          expiredBeacons.sort((a, b) => a.expiresAt!.compareTo(b.expiresAt!));
          expiredBeacons = expiredBeacons.reversed.toList();
        } else {
          workingBeacons.add(beacon);
          workingBeacons.sort((a, b) => a.startsAt!.compareTo(b.startsAt!));
        }
      }
    }
    // adding expired beacons at last
    workingBeacons.addAll(expiredBeacons);
    return workingBeacons;
  }

  logout() async {
    setState(ViewState.busy);
    await userConfig!.currentUser!.delete();
    await hiveDb!.beaconsBox.clear();
    // setState(ViewState.idle);
    await localNotif!.deleteNotification();
    navigationService!.removeAllAndPush('/auth', '/');
  }
}
