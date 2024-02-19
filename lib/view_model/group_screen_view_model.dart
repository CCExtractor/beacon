import 'dart:developer';

import 'package:beacon/enums/view_state.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/models/group/group.dart';
import 'package:beacon/models/user/user_info.dart';
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
  bool loadingGroupMembers = false;
  List<User> groupMembers = [];
  bool loadingNearbyBeacons = false;
  List<Beacon> nearByBeacons = [];

  toogleShowName(bool value) {
    showName = value;
    notifyListeners();
  }

  clearGroupInfo() {
    userBeacons.clear();
    groupMembers.clear();
    nearByBeacons.clear();
  }

  fetchGroupDetails(String groupId) async {
    // starting loading indicator
    loadingUserBeacons = true;
    loadingGroupMembers = true;
    loadingNearbyBeacons = true;
    notifyListeners();

    // fetching group details
    Group? group = await databaseFunctions!.fetchGroup(groupId);

    if (group != null) {
      // adding beacons
      if (group.beacons != null) {
        for (Beacon beacon in group.beacons!) {
          userBeacons.add(beacon);
        }
      }
      // adding group leader
      if (group.leader != null) {
        groupMembers.add(group.leader!);
        log('added leader');
      }
      // adding group members
      if (group.members != null) {
        for (User member in group.members!) {
          groupMembers.add(member);
        }
      }
    }

    // sorting nearby beacons from userbeacons
    fetchNearByBeacons(userBeacons);

    // turning off the loading widget
    loadingUserBeacons = false;
    loadingGroupMembers = false;
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
        userBeacons.add(beacon);
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

  joinHikeRoom(Function reloadList) async {
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
        userBeacons.add(beacon);
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

  logout() async {
    setState(ViewState.busy);
    await userConfig!.currentUser!.delete();
    await hiveDb!.beaconsBox.clear();
    // setState(ViewState.idle);
    await localNotif!.deleteNotification();
    navigationService!.removeAllAndPush('/auth', '/');
  }
}
