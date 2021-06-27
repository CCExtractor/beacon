import 'dart:async';

import 'package:beacon/components/dialog_boxes.dart';
import 'package:beacon/components/hike_screen_widget.dart';
import 'package:beacon/components/shape_painter.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:beacon/views/home.dart';
import 'package:beacon/utilities/handle_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../components/hike_button.dart';

double _lat = 0, _long = 0;

class HikeScreen extends StatefulWidget {
  final String _passkey, hikerName;
  final bool isReferred;
  HikeScreen(this._passkey, {this.isReferred, this.hikerName});
  @override
  _HikeScreenState createState() => _HikeScreenState();
}

//Assuming passkey validation is done previously
class _HikeScreenState extends State<HikeScreen> {
  double _screenHeight, _screenWidth;
  int _numberOfHikers;
  String _hikerName;

  String _expiringAt;
  bool _isGeneratingLink = false, _isReferred, isBeaconExpired = false;
  List<String> hikers = [];
  Duration _newDuration = Duration(seconds: 0);

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _kBeaconPosition =
      CameraPosition(target: LatLng(_lat, _long), zoom: 12.0);

  void beaconExpired() {
    // TODO
    Fluttertoast.showToast(msg: 'Beacon Expired');
  }

  startCountdown() {
    Future.delayed(
        DateTime.fromMillisecondsSinceEpoch(int.parse(_expiringAt))
            .difference(DateTime.now()), () {
      beaconExpired();
    });
  }

  fetchHikersData() async {}

  void init() => initState();

  @override
  void initState() {
    super.initState();
    fetchHikersData();
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: ModalProgressHUD(
        inAsyncCall: _isGeneratingLink,
        child: Stack(
          children: <Widget>[
            Scaffold(
              body: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kBeaconPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
            CustomPaint(
              size: Size(_screenWidth, _screenHeight),
              painter: ShapePainter(),
            ),
            _isReferred
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
                          onTap: () {
                            showDialog(
                                context: (context),
                                builder: (context) => Dialog(
                                      child: Container(
                                        height: 200,
                                        child: Scaffold(
                                          body: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: <Widget>[
                                                Flexible(
                                                  child: TextFormField(
                                                    onChanged: (key) {
                                                      _hikerName = key;
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText: 'Username Here',
                                                      hintStyle: TextStyle(
                                                          fontSize: 20,
                                                          color: kBlack),
                                                      labelText: 'Username',
                                                      labelStyle: TextStyle(
                                                          fontSize: 14,
                                                          color: kYellow),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                HikeButton(
                                                  text: 'Done',
                                                  buttonWidth: 48,
                                                  onTap: () {
                                                    bool isUsernameUnique =
                                                        true;
                                                    for (int i = 0;
                                                        i < hikers.length;
                                                        i++) {
                                                      if (hikers[i] ==
                                                          _hikerName) {
                                                        isUsernameUnique =
                                                            false;
                                                        break;
                                                      }
                                                    }
                                                    if (isUsernameUnique) {
                                                      //  user entering through link
                                                      SchedulerBinding.instance
                                                          .addPostFrameCallback(
                                                              (_) {
                                                        setState(() {
                                                          _isReferred = false;
                                                        });
                                                        Navigator.pop(context);
                                                      });
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'Username already taken, please take any other name');
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ));
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
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                                                fontWeight: FontWeight.bold),
                                            children: [
                                              TextSpan(
                                                  text: isBeaconExpired
                                                      ? 'Beacon Expired - Please Exit\n'
                                                      : 'Beacon expiring at ${_expiringAt == null ? '<Fetching data>' : DateFormat("hh:mm a").format(DateTime.fromMillisecondsSinceEpoch(int.parse(_expiringAt))).toString()}\n',
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                              TextSpan(
                                                  text:
                                                      'Beacon holder at: ${_lat.toStringAsFixed(4)}, ${_long.toStringAsFixed(4)}\n',
                                                  style:
                                                      TextStyle(fontSize: 14)),
                                              TextSpan(
                                                  text:
                                                      'Long press on any hiker to hand over the beacon\n',
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                              TextSpan(
                                                  text:
                                                      'Double Tap on beacon to change the duration\n',
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                            ]),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color: kBlue,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            topLeft: Radius.circular(10))),
                                    height: 80,
                                  ),
                                  Container(
                                    height: 170,
                                    child: ListView.builder(
                                      itemCount: hikers.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          child: GestureDetector(
                                            onLongPress: () {
                                              hikers[index] == _hikerName
                                                  ? Fluttertoast.showToast(
                                                      msg: 'Yeah, that\'s you')
                                                  : hikers[0] == _hikerName
                                                      ? relayBeacon(
                                                          hikers[index], index)
                                                      : Fluttertoast.showToast(
                                                          msg:
                                                              'You dont have beacon to relay');
                                            },
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                backgroundColor: isBeaconExpired
                                                    ? Colors.grey
                                                    : kYellow,
                                                radius: 18,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: Icon(
                                                      Icons.person_outline,
                                                      color: Colors.white,
                                                    )),
                                              ),
                                              title: Text(
                                                hikers[index],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              ),
                                              trailing: index == 0
                                                  ? GestureDetector(
                                                      onDoubleTap: () {
                                                        hikers[0] != _hikerName
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
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                500,
                                                                            child:
                                                                                Padding(
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
                                                                                          DateTime newTime = DateTime.now().add(_newDuration);
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
                                                        color: isBeaconExpired
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
                child: HikeScreenWidget.shareButton(context, widget._passkey)),
            Align(
              alignment: Alignment(-0.8, -0.8),
              child: GestureDetector(
                onTap: () {
                  if (widget.isReferred) {
                    Navigator.pop(context);
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MainScreen()));
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
  }

  Future<void> _createDynamicLink(bool short) async {
    // setState(() {
    //   _isGeneratingLink = true;
    // });
  }

  void relayBeacon(String newBeaconHolderName, int hikerNumber) {
    Fluttertoast.showToast(msg: 'Beacon handed over to $newBeaconHolderName');
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => DialogBoxes.showExitDialog(context),
        )) ??
        false;
  }
}
