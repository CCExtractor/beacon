import 'dart:async';

import 'package:beacon/components/dialog_boxes.dart';
import 'package:beacon/components/hike_screen_widget.dart';
import 'package:beacon/components/shape_painter.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:beacon/view_model/hike_screen_model.dart';
import 'package:beacon/views/base_view.dart';
import 'package:beacon/views/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../components/hike_button.dart';

class HikeScreen extends StatefulWidget {
  final Beacon beacon;
  final bool isReferred, isLeader;
  HikeScreen(this.beacon, {this.isReferred, this.isLeader});
  @override
  _HikeScreenState createState() => _HikeScreenState();
}

//Assuming passkey validation is done previously
class _HikeScreenState extends State<HikeScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseView<HikeScreenViewModel>(
        onModelReady: (model) => model.initialise(widget.beacon),
        builder: (context, model, child) {
          model.screenHeight = MediaQuery.of(context).size.height;
          model.screenWidth = MediaQuery.of(context).size.width;
          return WillPopScope(
            onWillPop: () => model.onWillPop(context),
            child: ModalProgressHUD(
              inAsyncCall: model.isGeneratingLink,
              child: Stack(
                children: <Widget>[
                  Scaffold(
                    body: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(
                              double.parse(widget.beacon.route.last.lat),
                              double.parse(widget.beacon.route.last.lon)),
                          zoom: 12.0),
                      onMapCreated: (GoogleMapController controller) {
                        model.controller.complete(controller);
                      },
                    ),
                  ),
                  CustomPaint(
                    size: Size(model.screenWidth, model.screenHeight),
                    painter: ShapePainter(),
                  ),
                  widget.isReferred
                      ? Container(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: HikeButton(
                                buttonHeight: 25,
                                buttonColor: kYellow,
                                buttonWidth: 64,
                                text: 'Add Me',
                                onTap: () async {
                                  final bool userLoggedIn =
                                      await userConfig.userLoggedIn();
                                  if (userLoggedIn) {
                                    navigationService
                                        .pushReplacementScreen('/auth');
                                    navigationService.showSnackBar(
                                        "User must be authenticated");
                                  }
                                },
                              ),
                            ),
                          ),
                        )
                      : Container(
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
                                    body: Column(
                                      children: <Widget>[
                                        Container(
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: RichText(
                                              text: TextSpan(
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  children: [
                                                    TextSpan(
                                                        text: model
                                                                .isBeaconExpired
                                                            ? 'Beacon Expired - Please Exit\n'
                                                            : 'Beacon expiring at ${model.beacon.expiresAt == null ? '<Fetching data>' : DateFormat("hh:mm a").format(DateTime.fromMillisecondsSinceEpoch(model.beacon.expiresAt)).toString()}\n',
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                    TextSpan(
                                                        text:
                                                            'Beacon holder at: ${model.lat.toStringAsFixed(4)}, ${model.long.toStringAsFixed(4)}\n',
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
                                                  topLeft:
                                                      Radius.circular(10))),
                                          height: 80,
                                        ),
                                        Container(
                                          height: 170,
                                          child: ListView.builder(
                                            physics:
                                                AlwaysScrollableScrollPhysics(),
                                            itemCount: model.hikers.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Container(
                                                child: GestureDetector(
                                                  onLongPress: () {
                                                    model.hikers[index].id ==
                                                            userConfig
                                                                .currentUser.id
                                                        ? Fluttertoast.showToast(
                                                            msg:
                                                                'Yeah, that\'s you')
                                                        : model.beacon.leader
                                                                    .id ==
                                                                userConfig
                                                                    .currentUser
                                                                    .id
                                                            ? model.relayBeacon(
                                                                model.hikers[
                                                                    index])
                                                            : Fluttertoast
                                                                .showToast(
                                                                    msg:
                                                                        'You dont have beacon to relay');
                                                  },
                                                  child: ListTile(
                                                    leading: CircleAvatar(
                                                      backgroundColor:
                                                          model.isBeaconExpired
                                                              ? Colors.grey
                                                              : kYellow,
                                                      radius: 18,
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          child: Icon(
                                                            Icons
                                                                .person_outline,
                                                            color: Colors.white,
                                                          )),
                                                    ),
                                                    title: Text(
                                                      model.hikers[index].name,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18),
                                                    ),
                                                    trailing: index == 0
                                                        ? GestureDetector(
                                                            onDoubleTap: () {
                                                              model.beacon.leader !=
                                                                      userConfig
                                                                          .currentUser
                                                                  ? Fluttertoast
                                                                      .showToast(
                                                                          msg:
                                                                              'Only beacon holder has access to change the duration')
                                                                  : showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) =>
                                                                              Dialog(
                                                                                child: Container(
                                                                                  height: 500,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                                                                    child: Column(
                                                                                      children: <Widget>[
                                                                                        Flexible(
                                                                                          child: Container(
                                                                                            color: kLightBlue,
                                                                                            child: Column(
                                                                                              children: <Widget>[
                                                                                                Text(
                                                                                                  'Change Beacon Duration',
                                                                                                  style: TextStyle(color: kYellow, fontSize: 12),
                                                                                                ),
                                                                                                Expanded(
                                                                                                  flex: 8,
                                                                                                  // Use it from the context of a stateful widget, passing in
                                                                                                  // and saving the duration as a state variable.
                                                                                                  // child: DurationPicker(
                                                                                                  //   height: 100,
                                                                                                  //   width: double.infinity,
                                                                                                  //   duration: _newDuration,
                                                                                                  //   onChange: (val) {
                                                                                                  //     setState(() {
                                                                                                  //       _newDuration = val;
                                                                                                  //       print(_newDuration);
                                                                                                  //     });
                                                                                                  //   },
                                                                                                  //   snapToMins: 5.0,
                                                                                                  // )
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 30,
                                                                                        ),
                                                                                        Flexible(
                                                                                          child: HikeButton(
                                                                                              buttonWidth: 48,
                                                                                              text: 'Done',
                                                                                              textColor: Colors.white,
                                                                                              buttonColor: kYellow,
                                                                                              onTap: () {
                                                                                                DateTime newTime = DateTime.now().add(model.newDuration);
                                                                                                // update time
                                                                                                Navigator.pop(context);
                                                                                              }),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ));
                                                            },
                                                            child: Icon(
                                                              Icons.room,
                                                              color: model
                                                                      .isBeaconExpired
                                                                  ? Colors.grey
                                                                  : kYellow,
                                                              size: 40,
                                                            ),
                                                          )
                                                        : Container(
                                                            width: 10,
                                                          ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  Align(
                      alignment: Alignment(1, -0.8),
                      child: HikeScreenWidget.shareButton(
                          context, widget.beacon.shortcode)),
                  Align(
                    alignment: Alignment(-0.8, -0.8),
                    child: GestureDetector(
                      onTap: () {
                        if (widget.isReferred) {
                          Navigator.pop(context);
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainScreen()));
                        }
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
            ),
          );
        });
  }
}
