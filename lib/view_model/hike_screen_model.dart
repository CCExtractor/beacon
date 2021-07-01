import 'dart:async';

import 'package:beacon/components/dialog_boxes.dart';
import 'package:beacon/enums/view_state.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/models/user/user_info.dart';
import 'package:beacon/view_model/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HikeScreenViewModel extends BaseModel {
  double screenHeight, screenWidth, lat, long;
  Beacon beacon;
  bool isGeneratingLink = false, isReferred, isBeaconExpired = false;
  List<User> hikers = [];
  Duration newDuration = Duration(seconds: 0);
  Completer<GoogleMapController> controller = Completer();

  Future<void> createDynamicLink(bool short) async {
    // setState(() {
    //   _isGeneratingLink = true;
    // });
  }

  void relayBeacon(User newHolder) {
    Fluttertoast.showToast(msg: 'Beacon handed over to $newHolder');
  }

  Future<bool> onWillPop(context) async {
    return (await showDialog(
          context: context,
          builder: (context) => DialogBoxes.showExitDialog(context),
        )) ??
        false;
  }

  void initialise(Beacon beaconParsed) async {
    setState(ViewState.busy);
    beacon = beaconParsed;
    hikers.add(beacon.leader);
    hikers.addAll(beacon.followers);
    lat = double.parse(beacon.route.last.lat);
    long = double.parse(beacon.route.last.lon);
    setState(ViewState.idle);
  }

  void beaconExpired() {
    // TODO
    Fluttertoast.showToast(msg: 'Beacon Expired');
  }

  startCountdown() {
    Future.delayed(
        DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt)
            .difference(DateTime.now()), () {
      beaconExpired();
    });
  }

  fetchHikersData() async {
    setState(ViewState.busy);

    setState(ViewState.idle);
  }
}
