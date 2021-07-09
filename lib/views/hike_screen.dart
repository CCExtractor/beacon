import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as Loc;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:beacon/api/queries.dart';
import 'package:beacon/components/dialog_boxes.dart';
import 'package:beacon/components/hike_screen_widget.dart';
import 'package:beacon/components/shape_painter.dart';
import 'package:beacon/enums/view_state.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/models/location/location.dart';
import 'package:beacon/models/user/user_info.dart';
import 'package:beacon/services/graphql_config.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:rxdart/rxdart.dart';

class HikeScreen extends StatefulWidget {
  final Beacon beacon;
  final bool isLeader;
  HikeScreen(this.beacon, {this.isLeader});
  @override
  _HikeScreenState createState() => _HikeScreenState();
}

//Assuming passkey validation is done previously
class _HikeScreenState extends State<HikeScreen> {
  double screenHeight, screenWidth;
  Beacon beacon;
  bool isGeneratingLink = false, isReferred, isBeaconExpired = false;
  List<User> hikers = [];
  List<LatLng> route = [];
  Duration newDuration = Duration(seconds: 0);
  Completer<GoogleMapController> mapController = Completer();
  String address, prevAddress;
  bool isBusy = false;
  Set<Marker> markers = {};
  StreamSubscription _leaderLocation;
  Stream _streamLocation, _streamFollower, _mixedStream;
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  ScrollController _scrollController;
  Loc.Location loc = new Loc.Location();

  getAddress() async {
    prevAddress = address;
    Coordinates coordinates =
        Coordinates(route.last.latitude, route.last.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      address = addresses.first.addressLine;
    });
  }

  setPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyCXlRxfbr9Y368nLy8o59r0_XZmHdK5-2w', // Google Maps API Key
      PointLatLng(route.first.latitude, route.first.longitude),
      PointLatLng(route.last.latitude, route.last.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }

  _addMarker() {
    markers.add(Marker(
      markerId: MarkerId((markers.length + 1).toString()),
      position: route.last,
    ));
  }

  initLocSubscription() {
    if (widget.isLeader) {
      _leaderLocation =
          loc.onLocationChanged.listen((Loc.LocationData currentLocation) {
        route.add(LatLng(currentLocation.latitude, currentLocation.longitude));
        getAddress();
        if (address != prevAddress) {
          setState(() {
            _addMarker();
            setPolyline();
          });
          databaseFunctions.init();
          databaseFunctions.updateLeaderLoc(widget.beacon.id,
              LatLng(currentLocation.latitude, currentLocation.longitude));
        }
      });
    } else {
      _streamLocation = GraphQLConfig().client.value.subscribe(
          SubscriptionOptions(
              document: gql(Queries().fetchLocationUpdates(widget.beacon.id))));
    }

    //   .listen((event) {
    //   print(event.data['beaconLocation']);
    //   route.add(LatLng(double.parse(event.data['beaconLocation']['lat']),
    //       double.parse(event.data['beaconLocation']['lon'])));
    //   getAddress();
    //   if (address != prevAddress) {
    //     setState(() {
    //       _addMarker();
    //       setPolyline();
    //     });
    //   }
    // });
  }

  fetchData() async {
    setState(() {
      beacon = widget.beacon;
      hikers.add(beacon.leader);
      hikers.addAll(beacon.followers);
      var lat = double.parse(beacon.route.last.lat);
      var long = double.parse(beacon.route.last.lon);
      route.add(LatLng(lat, long));
      markers.add(Marker(
        markerId: MarkerId((markers.length + 1).toString()),
        position: route.last,
      ));
      getAddress();
      isBusy = false;
    });
  }

  @override
  void initState() {
    super.initState();
    isBusy = true;
    fetchData();
    _scrollController = ScrollController();
    initLocSubscription();
    _streamFollower = GraphQLConfig().client.value.subscribe(
        SubscriptionOptions(
            document: gql(Queries().fetchFollowerUpdates(widget.beacon.id))));
    if (!widget.isLeader) {
      _mixedStream = MergeStream([_streamFollower, _streamLocation]);
    } else {
      _mixedStream = _streamFollower;
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.isLeader) {
      _leaderLocation.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return isBusy
        ? CircularProgressIndicator()
        : WillPopScope(
            onWillPop: () => onWillPop(context),
            child: ModalProgressHUD(
              inAsyncCall: isGeneratingLink,
              child: StreamBuilder(
                  stream: _mixedStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data.data);
                    }
                    return Stack(
                      children: <Widget>[
                        Scaffold(
                          body: GoogleMap(
                            mapType: MapType.normal,
                            markers: markers.toSet(),
                            polylines: Set<Polyline>.of(polylines.values),
                            initialCameraPosition:
                                CameraPosition(target: route.first, zoom: 12.0),
                            onMapCreated: (GoogleMapController controller) {
                              mapController.complete(controller);
                            },
                          ),
                        ),
                        CustomPaint(
                          size: Size(screenWidth, screenHeight),
                          painter: ShapePainter(),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10))),
                                  height: 250,
                                  child: Scaffold(
                                    body: Column(children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: RichText(
                                            maxLines: 4,
                                            text: TextSpan(
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                children: [
                                                  TextSpan(
                                                      text: isBeaconExpired
                                                          ? 'Beacon has been expired\n'
                                                          : 'Beacon expiring at ${beacon.expiresAt == null ? '<Fetching data>' : DateFormat("hh:mm a").format(DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt)).toString()}\n',
                                                      style: TextStyle(
                                                          fontSize: 16)),
                                                  TextSpan(
                                                      text:
                                                          'Beacon holder at: $address\n',
                                                      style: TextStyle(
                                                          fontSize: 14)),
                                                  TextSpan(
                                                      text:
                                                          'Long press on any hiker to hand over the beacon\n',
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                  TextSpan(
                                                      text:
                                                          'Double Tap on beacon to change the duration\n',
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                ]),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            color: kBlue,
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                topLeft: Radius.circular(10))),
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        clipBehavior: Clip.antiAlias,
                                        scrollDirection: Axis.vertical,
                                        controller: _scrollController,
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        itemCount: hikers.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ListTile(
                                            onTap: () {
                                              hikers[index].id ==
                                                      userConfig.currentUser.id
                                                  ? Fluttertoast.showToast(
                                                      msg: 'Yeah, that\'s you')
                                                  : beacon.leader.id ==
                                                          userConfig
                                                              .currentUser.id
                                                      ? relayBeacon(
                                                          hikers[index])
                                                      : Fluttertoast.showToast(
                                                          msg:
                                                              'You dont have beacon to relay');
                                            },
                                            leading: CircleAvatar(
                                              backgroundColor: isBeaconExpired
                                                  ? Colors.grey
                                                  : kYellow,
                                              radius: 18,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Icon(
                                                    Icons.person_outline,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                            title: Text(
                                              hikers[index].name,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                            trailing: hikers[index].id ==
                                                    beacon.leader.id
                                                ? GestureDetector(
                                                    onDoubleTap: () {
                                                      !widget.isLeader
                                                          ? Fluttertoast.showToast(
                                                              msg:
                                                                  'Only beacon holder has access to change the duration')
                                                          : DialogBoxes
                                                              .changeDurationDialog(
                                                                  context);
                                                    },
                                                    child: Icon(
                                                      Icons.room,
                                                      color: isBeaconExpired
                                                          ? Colors.grey
                                                          : kYellow,
                                                      size: 40,
                                                    ),
                                                  )
                                                : Container(width: 10),
                                          );
                                        },
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                            alignment: Alignment(1, -0.8),
                            child: HikeScreenWidget.shareButton(
                                context, beacon.shortcode)),
                        Align(
                          alignment: Alignment(-0.8, -0.8),
                          child: GestureDetector(
                            onTap: () {
                              navigationService.pushReplacementScreen('/main');
                            },
                            child: Icon(
                              Icons.arrow_back,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          );
  }

  Future<bool> onWillPop(context) async {
    return (await showDialog(
          context: context,
          builder: (context) => DialogBoxes.showExitDialog(context),
        )) ??
        false;
  }

  void relayBeacon(User newHolder) {
    Fluttertoast.showToast(msg: 'Beacon handed over to $newHolder');
  }
}
