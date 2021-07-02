import 'dart:async';

import 'package:beacon/api/queries.dart';
import 'package:beacon/enums/view_state.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/models/location/location.dart';
import 'package:beacon/services/graphql_config.dart';
import 'package:beacon/view_model/base_view_model.dart';
import 'package:beacon/views/hike_screen.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HomeViewModel extends BaseModel {
  bool isCreatingHike = false;
  String title;
  String expiryAt;
  TextEditingController _titleController = new TextEditingController();
  String enteredPasskey = '';
  StreamSubscription _leaderLocation;

  createHikeRoom() async {
    setState(ViewState.busy);
    databaseFunctions.init();
    final Beacon beacon = await databaseFunctions.createBeacon(
        _titleController.text ?? "Event",
        DateTime.parse(expiryAt).millisecondsSinceEpoch.toInt());
    setState(ViewState.idle);
    if (beacon != null) {
      navigationService.pushScreen('/hikeScreen',
          arguments: HikeScreen(beacon, isReferred: false));
    } else {
      navigationService.showSnackBar('SomeThing went wrong');
    }
  }

  joinHikeRoom() async {
    setState(ViewState.busy);
    databaseFunctions.init();
    final Beacon beacon = await databaseFunctions.joinBeacon(enteredPasskey);
    setState(ViewState.idle);
    if (beacon != null) {
      navigationService.pushScreen('/hikeScreen',
          arguments: HikeScreen(beacon, isReferred: false, isLeader: false));
    } else {
      navigationService.showSnackBar('SomeThing went wrong');
    }
  }
}
