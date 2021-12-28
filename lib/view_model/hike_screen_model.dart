import 'dart:async';

import 'package:beacon/models/location/location.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:beacon/enums/view_state.dart';
import 'package:share/share.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/models/user/user_info.dart';
import 'package:beacon/view_model/base_view_model.dart';

class HikeScreenViewModel extends BaseModel {
  double screenHeight, screenWidth, lat, long;
  Beacon beacon;
  bool isGeneratingLink = false, isReferred, isBeaconExpired = false;
  List<User> hikers = [];
  List<Location> route = [];
  Duration newDuration = Duration(seconds: 0);
  Completer<GoogleMapController> mapController = Completer();
  String address;

  Future<void> createDynamicLink(bool short) async {
    // setState(() {
    //   _isGeneratingLink = true;
    // });
  }

  void relayBeacon(User newHolder) {
    Fluttertoast.showToast(msg: 'Beacon handed over to $newHolder');
  }

  Future<bool> onWillPop(context) async {
    // return (await showDialog(
    //       context: context,
    //       // builder: (context) => DialogBoxes.showExitDialog(context),
    //     )) ??
    //     false;
    return false;
  }

  void initialise(Beacon beaconParsed) async {
    setState(ViewState.busy);
    beacon = beaconParsed;
    hikers.add(beacon.leader);
    hikers.addAll(beacon.followers);
    lat = double.parse(beacon.route.last.lat);
    long = double.parse(beacon.route.last.lon);
    route.add(Location(lat: beacon.route.last.lat, lon: beacon.route.last.lon));
    Coordinates coordinates = Coordinates(lat, long);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    address = addresses.first.addressLine;
    setState(ViewState.idle);
  }

  void beaconExpired() {
    // TODO
    Fluttertoast.showToast(msg: 'Beacon Expired');
  }

  // startCountdown() {
  //   Future.delayed(
  //       DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt)
  //           .difference(DateTime.now()), () {
  //     beaconExpired();
  //   });
  // }

  generateUrl(String shortcode) async {
    setState(ViewState.busy);
    Uri url = Uri.parse('https://beacon.aadibajpai.com/?shortcode=$shortcode');
    Share.share('To join beacon follow this link: $url');
    setState(ViewState.idle);
  }
}
