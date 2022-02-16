import 'package:beacon/view_model/hike_screen_model.dart';
import 'package:beacon/views/base_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:intl/intl.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:beacon/components/hike_screen_widget.dart';
import 'package:beacon/models/beacon/beacon.dart';

import 'package:beacon/utilities/constants.dart';

import 'package:sizer/sizer.dart';
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
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return BaseView<HikeScreenViewModel>(
      onModelReady: (m) {
        m.initialise(widget.beacon, widget.isLeader);
      },
      builder: (ctx, model, child) {
        if (!model.modelIsReady) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return WillPopScope(
          onWillPop: () => model.onWillPop(context),
          child: Scaffold(
            body: SafeArea(
              child: ModalProgressHUD(
                inAsyncCall: model.isGeneratingLink || model.isBusy,
                child: SlidingUpPanel(
                  maxHeight: 60.h,
                  minHeight: 20.h,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                  controller: model.panelController,
                  collapsed: Container(
                    decoration: BoxDecoration(
                      color: kBlue,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 1.5.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 65,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        Container(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: model.isBeaconExpired
                                        ? 'Beacon has been expired\n'
                                        : 'Beacon expiring at ${widget.beacon.expiresAt == null ? '<Fetching data>' : DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(widget.beacon.expiresAt)).toString()}\n',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  TextSpan(
                                    text:
                                        'Beacon holder at: ${model.address}\n',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  TextSpan(
                                    text:
                                        'Total Followers: ${model.hikers.length - 1} (Swipe up to view the list of followers)\n',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  TextSpan(
                                    text: model.isBeaconExpired
                                        ? ''
                                        : 'Share this passkey to add user: ${widget.beacon.shortcode}\n',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          height: 15.h,
                        ),
                      ],
                    ),
                  ),
                  panel: HikeScreenWidget.panel(
                      model.scrollController, model, context, widget.isLeader),
                  body: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Animarker(
                        rippleColor: Colors.redAccent,
                        rippleRadius: 0.01,
                        useRotation: true,
                        mapId: model.mapController.future.then<int>(
                          (value) => value.mapId,
                        ),
                        markers: model.markers.toSet(),
                        child: GoogleMap(
                            compassEnabled: true,
                            mapType: MapType.terrain,
                            polylines: model.polylines,
                            initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  double.parse(widget.beacon.location.lat),
                                  double.parse(widget.beacon.location.lon),
                                ),
                                zoom: CAMERA_ZOOM,
                                tilt: CAMERA_TILT,
                                bearing: CAMERA_BEARING),
                            onMapCreated: (GoogleMapController controller) {
                              setState(() {
                                model.mapController.complete(controller);
                              });
                              // setPolyline();
                            },
                            onTap: (loc) async {
                              if (model.panelController.isPanelOpen)
                                model.panelController.close();
                              else {
                                String title;
                                HikeScreenWidget
                                    .showCreateLandMarkDialogueDialog(
                                  context,
                                  model.landmarkFormKey,
                                  title,
                                  loc,
                                  model.createLandmark,
                                );
                              }
                            }),
                      ),
                      Align(
                          alignment: Alignment(0.9, -0.98),
                          child: model.isBeaconExpired
                              ? Container()
                              : HikeScreenWidget.shareButton(
                                  context, widget.beacon.shortcode)),
                      Align(
                        alignment: Alignment(-0.9, -0.98),
                        child: FloatingActionButton(
                          onPressed: () {
                            model.onWillPop(context);
                          },
                          backgroundColor: kYellow,
                          child: Icon(
                            Icons.arrow_back,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (!model.isBeaconExpired)
                        //show the routeSharebutton only when beacon is active(?) and mapcontroller is ready.
                        Align(
                          alignment: screenHeight > 800
                              ? Alignment(0.9, -0.8)
                              : Alignment(0.9, -0.77),
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 500),
                            opacity:
                                model.mapController.isCompleted ? 1.0 : 0.0,
                            child: HikeScreenWidget.shareRouteButton(context,
                                model.beacon, model.mapController, model.route),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // void relayBeacon(User newHolder) {
  //   Fluttertoast.showToast(msg: 'Beacon handed over to $newHolder');
  // }
}
