import 'dart:async';
import 'package:beacon/components/hike_button.dart';
import 'package:beacon/queries/beacon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
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
import 'package:overlay_support/overlay_support.dart';
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
  Set<String> followerId = {};
  bool isGeneratingLink = false, isReferred, isBeaconExpired = false;
  List<User> hikers = [];
  List<LatLng> route = [];
  Duration newDuration = Duration(seconds: 0);
  Completer<GoogleMapController> mapController = Completer();
  String address, prevAddress;
  bool isBusy = false;
  Set<Marker> markers = {};
  Set<Polyline> _polylines = Set<Polyline>();
  StreamSubscription _leaderLocation;
  Stream beaconLocationStream, beaconJoinedStream, mergedStream;
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  final GlobalKey<FormState> _landmarkFormKey = GlobalKey<FormState>();
  ScrollController _scrollController = ScrollController();
  Location loc = new Location();
  GraphQLClient graphQlClient;
  PanelController _panelController = PanelController();
  final List<StreamSubscription> mergedStreamSubscriptions = [];

  void updatePinOnMap(LatLng loc) async {
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: loc,
    );
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    setState(() {
      var pinPosition = loc;
      markers.removeWhere((m) => m.markerId.value == "1");
      markers.add(Marker(
        markerId: MarkerId("1"),
        position: pinPosition, // updated position
        infoWindow: InfoWindow(
          title: 'Current Location',
        ),
      ));
    });
  }

  Future<void> setupSubscriptions() async {
    if (widget.isLeader) {
      // distanceFilter (in m) can be changed to reduce the backend calls
      await loc.changeSettings(interval: 3000, distanceFilter: 0.0);
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
            updatePinOnMap(
                LatLng(currentLocation.latitude, currentLocation.longitude));
            setPolyline();
          });
        }
      });
    } else {
      beaconLocationStream = graphQlClient.subscribe(
        SubscriptionOptions(
          document: BeaconQueries().beaconLocationSubGql,
          variables: <String, dynamic>{
            'id': widget.beacon.id,
          },
        ),
      );
    }

    beaconJoinedStream = graphQlClient.subscribe(
      SubscriptionOptions(
        document: BeaconQueries().beaconJoinedSubGql,
        variables: <String, dynamic>{
          'id': widget.beacon.id,
        },
      ),
    );
    if (!widget.isLeader) {
      mergedStream = MergeStream([beaconLocationStream, beaconJoinedStream]);
    } else {
      mergedStream = beaconJoinedStream;
    }
    final mergeStreamSubscription = mergedStream.listen((event) async {
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
          setState(() {
            if (!followerId.contains(newJoinee.id)) {
              hikers.add(newJoinee);
              followerId.add(newJoinee.id);
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
          });
        }
        if (event.data.containsKey('beaconLocation')) {
          LatLng coord = LatLng(
              double.parse(event.data['beaconLocation']['lat']),
              double.parse(event.data['beaconLocation']['lon']));
          var addresses = await Geocoder.local.findAddressesFromCoordinates(
              Coordinates(coord.latitude, coord.longitude));

          String _address = addresses.first.addressLine;
          route.add(coord);
          setState(() {
            updatePinOnMap(coord);
            address = _address;
            // setPolyline();
          });
        }
      }
    });

    mergedStreamSubscriptions.add(mergeStreamSubscription);
  }

  @override
  void dispose() {
    if (widget.isLeader) {
      _leaderLocation.cancel();
    }
    for (var streamSub in mergedStreamSubscriptions) {
      streamSub.cancel();
    }
    super.dispose();
  }

  setPolyline() async {
    PolylineResult result = await polylinePoints?.getRouteBetweenCoordinates(
      '${FlutterConfig.get('MAPS_API_KEY')}', // Google Maps API Key
      PointLatLng(route.first.latitude, route.first.longitude),
      PointLatLng(route.last.latitude, route.last.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId('poly'),
        color: Colors.red,
        points: polylineCoordinates,
        width: 3,
      );
      _polylines.add(polyline);
    });
  }

  fetchData() async {
    Coordinates coordinates = Coordinates(
        double.parse(widget.beacon.location.lat),
        double.parse(widget.beacon.location.lon));
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    await databaseFunctions.fetchBeaconInfo(widget.beacon.id).then((value) {
      beacon = value;
      setState(() {
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
        markers.add(Marker(
          markerId: MarkerId("1"),
          position: route.last,
          infoWindow: InfoWindow(
            title: 'Current Location',
          ),
        ));
        for (var i in value.landmarks) {
          markers.add(Marker(
            markerId: MarkerId((markers.length + 1).toString()),
            position: LatLng(
                double.parse(i.location.lat), double.parse(i.location.lon)),
            infoWindow: InfoWindow(
              title: '${i.title}',
            ),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
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
      });
    });
  }

  @override
  void initState() {
    super.initState();
    isBusy = true;
    beacon = widget.beacon;
    fetchData();
    graphQlClient = GraphQLConfig().graphQlClient();
    setupSubscriptions();
    isBusy = false;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return isBusy
        ? CircularProgressIndicator()
        : WillPopScope(
            onWillPop: () => onWillPop(context),
            child: Scaffold(
              body: SafeArea(
                child: ModalProgressHUD(
                    inAsyncCall: isGeneratingLink || isBusy,
                    child: SlidingUpPanel(
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
                                                : 'Beacon expiring at ${widget.beacon.expiresAt == null ? '<Fetching data>' : DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(widget.beacon.expiresAt)).toString()}\n',
                                            style: TextStyle(fontSize: 16)),
                                        TextSpan(
                                            text:
                                                'Beacon holder at: $address\n',
                                            style: TextStyle(fontSize: 14)),
                                        TextSpan(
                                            text:
                                                'Total Followers: ${hikers.length - 1} (Swipe up to view the list of followers)\n',
                                            style: TextStyle(fontSize: 12)),
                                        TextSpan(
                                            text:
                                                'Share this passkey to add user: ${widget.beacon.shortcode}\n',
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
                          GoogleMap(
                            compassEnabled: true,
                            mapType: MapType.terrain,
                            markers: markers.toSet(),
                            polylines: _polylines,
                            initialCameraPosition: CameraPosition(
                                target: LatLng(
                                    double.parse(widget.beacon.location.lat),
                                    double.parse(widget.beacon.location.lon)),
                                zoom: CAMERA_ZOOM,
                                tilt: CAMERA_TILT,
                                bearing: CAMERA_BEARING),
                            onMapCreated: (GoogleMapController controller) {
                              mapController.complete(controller);
                              // setPolyline();
                            },
                            onTap: (loc) async {
                              String title;
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: Container(
                                    height: 250,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32, vertical: 16),
                                      child: Form(
                                        key: _landmarkFormKey,
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              height: 100,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: TextFormField(
                                                  onChanged: (key) {
                                                    title = key;
                                                  },
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "Please enter title for landmark";
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    alignLabelWithHint: true,
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .always,
                                                    hintText:
                                                        'Add title for the landmark',
                                                    hintStyle: TextStyle(
                                                        fontSize: 15,
                                                        color: kBlack),
                                                    labelText: 'Title',
                                                    labelStyle: TextStyle(
                                                        fontSize: 20,
                                                        color: kYellow),
                                                  ),
                                                ),
                                              ),
                                              color: kLightBlue,
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Flexible(
                                              child: HikeButton(
                                                  buttonWidth: 25,
                                                  text: 'Create Landmark',
                                                  textColor: Colors.white,
                                                  buttonColor: kYellow,
                                                  onTap: () async {
                                                    if (_landmarkFormKey
                                                        .currentState
                                                        .validate()) {
                                                      navigationService.pop();
                                                      await databaseFunctions
                                                          .init();
                                                      await databaseFunctions
                                                          .createLandmark(title,
                                                              loc, beacon.id)
                                                          .then((value) {
                                                        setState(() {
                                                          markers.add(Marker(
                                                            markerId: MarkerId(
                                                                (markers.length +
                                                                        1)
                                                                    .toString()),
                                                            position: loc,
                                                            infoWindow:
                                                                InfoWindow(
                                                              title: '$title',
                                                            ),
                                                            icon: BitmapDescriptor
                                                                .defaultMarkerWithHue(
                                                                    BitmapDescriptor
                                                                        .hueBlue),
                                                          ));
                                                        });
                                                      });
                                                    }
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          CustomPaint(
                            size: Size(screenWidth, screenHeight - 200),
                            foregroundPainter: ShapePainter(),
                          ),
                          Align(
                              alignment: Alignment(0.87, -0.85),
                              child: HikeScreenWidget.shareButton(
                                  context, widget.beacon.shortcode)),
                          Align(
                            alignment: Alignment(-0.8, -0.9),
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
                    )
                    // }),
                    ),
              ),
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
                              //TODO: enable this once backend has updated.
                              //Commented, since we dont have the neccessary mutation atm on backend to change the duration.
                              // TextSpan(
                              //     text:
                              //         'Double tap on beacon to change the duration\n',
                              //     style: TextStyle(fontSize: 14)),
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
                                    //TODO: enable this once backend has updated.
                                    //Commented, since we dont have the neccessary mutation atm on backend to change the duration.
                                    // : DialogBoxes.changeDurationDialog(context);
                                    : Container();
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
