import 'dart:async';

import 'package:beacon/components/dialog_boxes.dart';
import 'package:beacon/config/environment_config.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/queries/beacon.dart';
import 'package:beacon/services/graphql_config.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animarker/core/ripple_marker.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:beacon/enums/view_state.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/models/location/location.dart' deferred as locModel;
import 'package:beacon/models/user/user_info.dart';
import 'package:beacon/view_model/base_view_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';

class HikeScreenViewModel extends BaseModel {
  bool modelIsReady = false;
  Beacon beacon;
  Set<String> followerId = {};
  bool isGeneratingLink = false, isReferred, isBeaconExpired = false;
  List<User> hikers = [];
  List<LatLng> route = [];
  Duration newDuration = Duration(seconds: 0);
  Completer<GoogleMapController> mapController = Completer();
  String address, prevAddress;
  bool isBusy = false;
  Set<Marker> markers = {};
  Set<Polyline> polylines = Set<Polyline>();
  StreamSubscription _leaderLocation;
  Stream beaconLocationStream, beaconJoinedStream, mergedStream;
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  final GlobalKey<FormState> landmarkFormKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();
  Location loc = new Location();
  GraphQLClient graphQlClient;
  PanelController panelController = PanelController();
  final List<StreamSubscription> mergedStreamSubscriptions = [];
  bool isLeader = false;

  void relayBeacon(User newHolder) {
    Fluttertoast.showToast(msg: 'Beacon handed over to $newHolder');
  }

  Future<bool> onWillPop(context) async {
    return (await showDialog(
          context: context,
          builder: (context) => DialogBoxes.showExitDialog(
              context, isLeader, hikers.length, isBeaconExpired),
        )) ??
        false;
  }

  LatLngBounds calculateMapBoundsFromListOfLatLng(List<LatLng> pointsList,
      {double padding = 0.0005}) {
    double southWestLatitude = 90;
    double southWestLongitude = 90;
    double northEastLatitude = -180;
    double northEastLongitude = -180;
    pointsList.forEach((point) {
      if (point.latitude < southWestLatitude) {
        southWestLatitude = point.latitude;
      }
      if (point.longitude < southWestLongitude) {
        southWestLongitude = point.longitude;
      }
      if (point.latitude > northEastLatitude) {
        northEastLatitude = point.latitude;
      }
      if (point.longitude > northEastLongitude) {
        northEastLongitude = point.longitude;
      }
    });
    southWestLatitude = southWestLatitude - padding;
    southWestLongitude = southWestLongitude - padding;
    northEastLatitude = northEastLatitude + padding;
    northEastLongitude = northEastLongitude + padding;
    LatLngBounds bound = LatLngBounds(
        southwest: LatLng(southWestLatitude, southWestLongitude),
        northeast: LatLng(northEastLatitude, northEastLongitude));
    return bound;
  }

  Future<void> setPolyline() async {
    PolylineResult result = await polylinePoints?.getRouteBetweenCoordinates(
      EnvironmentConfig.googleMapApi, // Google Maps API Key
      PointLatLng(route.first.latitude, route.first.longitude),
      PointLatLng(route.last.latitude, route.last.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    Polyline polyline = Polyline(
      polylineId: PolylineId('poly'),
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines.add(polyline);
  }

  Future<void> updatePinOnMap(LatLng loc) async {
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: loc,
    );
    final GoogleMapController controller = await mapController.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(cPosition))
        .then((v) async {
      CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(
          calculateMapBoundsFromListOfLatLng(route), 50);
      controller.animateCamera(cameraUpdate);
    });

    var pinPosition = loc;
    markers.removeWhere((m) => m.markerId.value == "1");
    markers.add(RippleMarker(
      ripple: true,
      markerId: MarkerId("1"),
      position: pinPosition, // updated position
      infoWindow: InfoWindow(
        title: 'Current Location',
      ),
    ));
  }

  Future<void> updateModel(Beacon value) async {
    Coordinates coordinates = Coordinates(
        double.parse(beacon.location.lat), double.parse(beacon.location.lon));
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    isBeaconExpired = DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt)
        .isBefore(DateTime.now());
    hikers.add(value.leader);
    for (var i in value.followers) {
      if (!followerId.contains(i.id)) {
        hikers.add(i);
        followerId.add(i.id);
      }
    }
    var lat = double.parse(value.location.lat);
    var lon = double.parse(value.location.lon);
    route.add(LatLng(lat, lon));
    address = addresses.first.addressLine;
    markers.add(Marker(
      markerId: MarkerId("0"),
      position: route.first,
      infoWindow: InfoWindow(
        title: 'Initial Location',
      ),
    ));
    markers.add(RippleMarker(
      ripple: true,
      markerId: MarkerId("1"),
      position: route.last,
      infoWindow: InfoWindow(
        title: 'Current Location',
      ),
    ));
    for (var i in value.landmarks) {
      markers.add(Marker(
        markerId: MarkerId((markers.length + 1).toString()),
        position:
            LatLng(double.parse(i.location.lat), double.parse(i.location.lon)),
        infoWindow: InfoWindow(
          title: '${i.title}',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    }
    // for (var i in value.followers) {
    //   markers.add(Marker(
    //     markerId: MarkerId((markers.length + 1).toString()),
    //     position: LatLng(
    //         double.parse(i.location.lat), double.parse(i.location.lon)),
    //     infoWindow: InfoWindow(
    //       title: '${i.name}',
    //     ),
    //     icon: BitmapDescriptor.defaultMarkerWithHue(
    //         BitmapDescriptor.hueYellow),
    //   ));
    // }
    //notifyListeners();
  }

  Future<void> fetchData() async {
    await databaseFunctions.fetchBeaconInfo(beacon.id).then((value) async {
      if (value != null) {
        beacon = value;
        await hiveDb.putBeaconInBeaconBox(beacon.id, beacon);
      } else {
        value = hiveDb.beaconsBox.get(beacon.id);
        beacon = value;
      }
      await updateModel(value);
    });
  }

  Future<void> setupSubscriptions(bool isExpired) async {
    if (isBeaconExpired || isExpired) return;
    if (isLeader) {
      // distanceFilter (in m) can be changed to reduce the backend calls
      await loc.changeSettings(interval: 3000, distanceFilter: 0.0);
      _leaderLocation = loc.onLocationChanged.listen(
        (LocationData currentLocation) async {
          if (DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt)
              .isBefore(DateTime.now())) _leaderLocation.cancel();
          Coordinates coordinates =
              Coordinates(currentLocation.latitude, currentLocation.longitude);
          var addresses =
              await Geocoder.local.findAddressesFromCoordinates(coordinates);

          String _address = addresses.first.addressLine;
          if (address != _address) {
            databaseFunctions.init();
            await databaseFunctions.updateLeaderLoc(beacon.id,
                LatLng(currentLocation.latitude, currentLocation.longitude));
            address = _address;
            route.add(
                LatLng(currentLocation.latitude, currentLocation.longitude));
            updatePinOnMap(
                LatLng(currentLocation.latitude, currentLocation.longitude));
            setPolyline();
            notifyListeners();
          }
        },
      );
    } else {
      beaconLocationStream = graphQlClient.subscribe(
        SubscriptionOptions(
          document: BeaconQueries().beaconLocationSubGql,
          variables: <String, dynamic>{
            'id': beacon.id,
          },
        ),
      );
    }

    beaconJoinedStream = graphQlClient.subscribe(
      SubscriptionOptions(
        document: BeaconQueries().beaconJoinedSubGql,
        variables: <String, dynamic>{
          'id': beacon.id,
        },
      ),
    );
    if (!isLeader) {
      mergedStream = MergeStream([beaconLocationStream, beaconJoinedStream]);
    } else {
      mergedStream = beaconJoinedStream;
    }
    StreamSubscription<dynamic> mergeStreamSubscription;
    mergeStreamSubscription = mergedStream.listen((event) async {
      if (DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt)
          .isBefore(DateTime.now())) {
        mergeStreamSubscription.cancel();
        isBeaconExpired = true;
        notifyListeners();
        return;
      }
      if (event.data != null) {
        print('${event.data}');
        if (event.data.containsKey('beaconJoined')) {
          User newJoinee = User.fromJson(event.data['beaconJoined']);

          showOverlayNotification((context) {
            return Card(
              color: kLightBlue,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: SafeArea(
                child: ListTile(
                  leading: SizedBox.fromSize(
                      size: const Size(40, 40),
                      child: ClipOval(
                          child: Container(
                        child:
                            Image(image: AssetImage('images/male_avatar.png')),
                      ))),
                  title: Text('${newJoinee.name} joined the hike!'),
                  trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        OverlaySupportEntry.of(context).dismiss();
                      }),
                ),
              ),
            );
          }, duration: Duration(milliseconds: 4000));

          if (!followerId.contains(newJoinee.id)) {
            hikers.add(newJoinee);
            followerId.add(newJoinee.id);
            beacon.followers.add(newJoinee);
            await hiveDb.putBeaconInBeaconBox(beacon.id, beacon);
          }
          // markers.add(Marker(
          //   markerId: MarkerId((markers.length + 1).toString()),
          //   position: LatLng(double.parse(newJoinee.location.lat),
          //       double.parse(newJoinee.location.lon)),
          //   infoWindow: InfoWindow(
          //     title: '${newJoinee.name}',
          //   ),
          //   icon: BitmapDescriptor.defaultMarkerWithHue(
          //       BitmapDescriptor.hueYellow),
          // ));
          notifyListeners();
        }
        if (event.data.containsKey('beaconLocation')) {
          LatLng coord = LatLng(
              double.parse(event.data['beaconLocation']['lat']),
              double.parse(event.data['beaconLocation']['lon']));
          var addresses = await Geocoder.local.findAddressesFromCoordinates(
              Coordinates(coord.latitude, coord.longitude));
          beacon.route.add(
            locModel.Location(
              lat: coord.latitude.toString(),
              lon: coord.longitude.toString(),
            ),
          );
          await hiveDb.putBeaconInBeaconBox(beacon.id, beacon);
          String _address = addresses.first.addressLine;
          route.add(coord);
          updatePinOnMap(coord);
          address = _address;
          // setPolyline();
          notifyListeners();
        }
      }
    });

    mergedStreamSubscriptions.add(mergeStreamSubscription);
  }

  Future<void> initialise(Beacon beaconParsed, bool widgetIsLeader) async {
    beacon = hiveDb.beaconsBox.get(beaconParsed.id);
    isLeader = widgetIsLeader;

    if (await connectionChecker.checkForInternetConnection()) {
      await fetchData();
      graphQlClient = GraphQLConfig().graphQlClient();
      await setupSubscriptions(
          DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt)
              .isBefore(DateTime.now()));
    } else {
      await updateModel(beacon);
    }
    modelIsReady = true;
    notifyListeners();
    // print("REBUITL" + modelIsReady.toString());
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

  void dispose() {
    if (_leaderLocation != null) {
      _leaderLocation.cancel();
    }
    if (mergedStreamSubscriptions != null)
      for (var streamSub in mergedStreamSubscriptions) {
        if (streamSub != null) streamSub.cancel();
      }
    connectionChecker.checkForInternetConnection().then(
      (value) async {
        await hiveDb.putBeaconInBeaconBox(beacon.id, beacon,
            fetchFromNetwork: value);
      },
    );
    super.dispose();
  }

  generateUrl(String shortcode) async {
    setState(ViewState.busy);
    Uri url = Uri.parse('https://beacon.aadibajpai.com/?shortcode=$shortcode');
    Share.share('To join beacon follow this link: $url');
    setState(ViewState.idle);
  }

  Future<void> createLandmark(
    var title,
    var loc,
  ) async {
    if (landmarkFormKey.currentState.validate()) {
      navigationService.pop();
      await databaseFunctions.init();
      await databaseFunctions
          .createLandmark(title, loc, beacon.id)
          .then((value) async {
        markers.add(Marker(
          markerId: MarkerId((markers.length + 1).toString()),
          position: loc,
          infoWindow: InfoWindow(
            title: '$title',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ));
        beacon.landmarks.add(value);
        await hiveDb.putBeaconInBeaconBox(beacon.id, beacon);
        print(hiveDb.beaconsBox.get(beacon.id).landmarks.length.toString() +
            'asdasdasd');
        notifyListeners();
      });
    }
  }
}
