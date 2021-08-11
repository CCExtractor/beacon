import 'dart:async';

import 'package:beacon/queries/beacon.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:beacon/components/dialog_boxes.dart';
import 'package:beacon/components/hike_screen_widget.dart';
import 'package:beacon/components/shape_painter.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/models/user/user_info.dart';
import 'package:beacon/services/graphql_config.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HikeScreen extends StatefulWidget {
  final Beacon beacon;
  final bool isLeader;
  HikeScreen(this.beacon, {this.isLeader});
  @override
  _HikeScreenState createState() => _HikeScreenState();
}

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

  ScrollController _scrollController = ScrollController();
  Location loc = new Location();
  PanelController _panelController = PanelController();

  // getAddress() async {
  //   prevAddress = address;
  //   Coordinates coordinates = Coordinates(
  //       double.parse(beacon.location.lat), double.parse(beacon.location.lat));
  //   var addresses =
  //       await Geocoder.local.findAddressesFromCoordinates(coordinates);

  //   setState(() {
  //     print('$address');
  //     address = addresses.first.addressLine;
  //   });
  // }

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

  initSubscriptions() {
    if (widget.isLeader) {
      _leaderLocation =
          loc.onLocationChanged.listen((LocationData currentLocation) async {
        Coordinates coordinates =
            Coordinates(currentLocation.latitude, currentLocation.longitude);
        var addresses =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);

        String _address = addresses.first.addressLine;
        if (address != _address) {
          databaseFunctions.init();
          await databaseFunctions.updateLeaderLoc(widget.beacon.id,
              LatLng(currentLocation.latitude, currentLocation.longitude));
          setState(() {
            address = _address;
            _addMarker();
            setPolyline();
          });
        }
      });
    } else {
      _streamLocation = GraphQLConfig().client.value.subscribe(
          SubscriptionOptions(
              document:
                  gql(BeaconQueries().fetchLocationUpdates(widget.beacon.id))));
    }

    _streamFollower = GraphQLConfig().client.value.subscribe(
        SubscriptionOptions(
            document:
                gql(BeaconQueries().fetchFollowerUpdates(widget.beacon.id))));
    if (!widget.isLeader) {
      _mixedStream = MergeStream([_streamFollower, _streamLocation]);
    } else {
      _mixedStream = _streamFollower;
    }
    setState(() {
      isBusy = false;
    });
  }

  fetchData() async {
    Coordinates coordinates = Coordinates(
        double.parse(widget.beacon.location.lat),
        double.parse(widget.beacon.location.lon));
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      beacon = widget.beacon;
      hikers.add(beacon.leader);
      hikers.addAll(beacon.followers);
      var lat = double.parse(beacon.location.lat);
      var lon = double.parse(beacon.location.lon);
      route.add(LatLng(lat, lon));
      address = addresses.first.addressLine;
      markers.add(Marker(
        markerId: MarkerId((markers.length + 1).toString()),
        position: route.last,
      ));
    });
  }

  @override
  void initState() {
    super.initState();
    isBusy = true;
    fetchData();
    initSubscriptions();
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
                  stream: _streamFollower,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data);
                    }
                    return SlidingUpPanel(
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                      minHeight: 154,
                      controller: _panelController,
                      collapsed: Container(
                        decoration: BoxDecoration(
                            color: kBlue,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10))),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 12.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 60,
                                  height: 5,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0))),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.infinity,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      children: [
                                        TextSpan(
                                            text: isBeaconExpired
                                                ? 'Beacon has been expired\n'
                                                : 'Beacon expiring at ${beacon.expiresAt == null ? '<Fetching data>' : DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt)).toString()}\n',
                                            style: TextStyle(fontSize: 16)),
                                        TextSpan(
                                            text:
                                                'Beacon holder at: $address\n',
                                            style: TextStyle(fontSize: 14)),
                                        TextSpan(
                                            text:
                                                'Total Followers: ${hikers.length - 1} (Swipe to view the list of followers)\n',
                                            style: TextStyle(fontSize: 12)),
                                        TextSpan(
                                            text:
                                                'Share this passkey to add user: ${beacon.shortcode}\n',
                                            style: TextStyle(fontSize: 12)),
                                      ]),
                                ),
                              ),
                              height: 120,
                            ),
                          ],
                        ),
                      ),
                      panel: _panel(_scrollController),
                      body: Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          Scaffold(
                            body: GoogleMap(
                              mapType: MapType.normal,
                              markers: markers.toSet(),
                              polylines: Set<Polyline>.of(polylines.values),
                              initialCameraPosition: CameraPosition(
                                  target: route.first, zoom: 12.0),
                              onMapCreated: (GoogleMapController controller) {
                                mapController.complete(controller);
                              },
                            ),
                          ),
                          CustomPaint(
                            size: Size(screenWidth, screenHeight),
                            painter: ShapePainter(),
                          ),
                          Align(
                              alignment: Alignment(0.9, -0.8),
                              child: HikeScreenWidget.shareButton(
                                  context, beacon.shortcode)),
                          Align(
                            alignment: Alignment(-0.8, -0.8),
                            child: GestureDetector(
                              onTap: () {
                                onWillPop(context);
                              },
                              child: Icon(
                                Icons.arrow_back,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          );
  }

  Column _panel(ScrollController sc) {
    return Column(children: [
      SizedBox(
        height: 15.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 60,
            height: 5,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
          ),
        ],
      ),
      SizedBox(
        height: 12,
      ),
      Container(
        height: MediaQuery.of(context).size.height * 0.6 - 32,
        child: ListView(
            controller: sc,
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              widget.isLeader
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: kBlack),
                            children: [
                              TextSpan(
                                  text:
                                      'Long Press on any hiker to hand over the beacon\n',
                                  style: TextStyle(fontSize: 16)),
                              TextSpan(
                                  text:
                                      'Double tap on beacon to change the duration\n',
                                  style: TextStyle(fontSize: 14)),
                            ]),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 6,
              ),
              Material(
                child: ListView.builder(
                  shrinkWrap: true,
                  clipBehavior: Clip.antiAlias,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: hikers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        hikers[index].id == userConfig.currentUser.id
                            ? Fluttertoast.showToast(msg: 'Yeah, that\'s you')
                            : beacon.leader.id == userConfig.currentUser.id
                                ? relayBeacon(hikers[index])
                                : Fluttertoast.showToast(
                                    msg: 'You dont have beacon to relay');
                      },
                      leading: CircleAvatar(
                        backgroundColor:
                            isBeaconExpired ? Colors.grey : kYellow,
                        radius: 18,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Icon(
                              Icons.person_outline,
                              color: Colors.white,
                            )),
                      ),
                      title: Text(
                        hikers[index].name,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      trailing: hikers[index].id == beacon.leader.id
                          ? GestureDetector(
                              onDoubleTap: () {
                                !widget.isLeader
                                    ? Fluttertoast.showToast(
                                        msg:
                                            'Only beacon holder has access to change the duration')
                                    : DialogBoxes.changeDurationDialog(context);
                              },
                              child: Icon(
                                Icons.room,
                                color: isBeaconExpired ? Colors.grey : kYellow,
                                size: 40,
                              ),
                            )
                          : Container(width: 10),
                    );
                  },
                ),
              ),
            ]),
      ),
    ]);
  }

  Future<bool> onWillPop(context) async {
    return (await showDialog(
          context: context,
          builder: (context) => DialogBoxes.showExitDialog(
              context, widget.isLeader, hikers.length),
        )) ??
        false;
  }

  void relayBeacon(User newHolder) {
    Fluttertoast.showToast(msg: 'Beacon handed over to $newHolder');
  }
}
