import 'dart:async';

import 'package:beacon/constants.dart';
import 'package:beacon/initiation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:intl/intl.dart';

class HikeScreen extends StatefulWidget {
  final String passKey;
  final bool isReferred;
  final String hickerName;
  HikeScreen(this.passKey,
      {required this.hickerName, required this.isReferred});
  @override
  _HikeScreenState createState() => _HikeScreenState();
}

class _HikeScreenState extends State<HikeScreen> {
  final _firestore = FirebaseFirestore.instance;
  String duration = '';
  TextEditingController _durationController = new TextEditingController();
  late int _numberOfHikers;
  late String _hikerName;
  late String _linkMessage;
  DateTime _expiringAt = DateTime.now();
  bool isExpired = false;
  late bool _isGeneratingLink = false, _isReferred = false;
  List hikers = [];
  Duration _newDuration = Duration(seconds: 0);
  PanelController _panelController = new PanelController();

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _kBeaconPosition = CameraPosition(
      target: LatLng(AppConstants.lat, AppConstants.long), zoom: 12.0);

  void beaconExpired() {
    _firestore.collection('hikes').doc(widget.passKey).delete();
    Fluttertoast.showToast(msg: 'Beacon Expired');
    setState(() {
      isExpired = true;
    });
  }

  startCountdown() {
    Future.delayed(_expiringAt.difference(DateTime.now()), () {
      beaconExpired();
    });
  }

  fetchHikersData() async {
    _isReferred = widget.isReferred;
    _hikerName = widget.hickerName;
    try {
      await _firestore
          .collection('hikes')
          .doc(widget.passKey)
          .get()
          .then((querySnapshot) async {
        if (!querySnapshot.exists) {
          print('idhar dikkat hai');
          beaconExpired();
        }
        setState(() {
          hikers = querySnapshot.data()!['hikers'];
          _numberOfHikers = hikers.length;
          _expiringAt = querySnapshot.data()!['expiringAt'].toDate();
        });

        if (_expiringAt.isAfter(DateTime.now())) {
          startCountdown();
        }
        setState(() {
          AppConstants.lat = querySnapshot.data()!['lat'] ?? 0.0;
          AppConstants.long = querySnapshot.data()!['long'] ?? 0.0;
        });

        if (hikers[0] == _hikerName) {
          await AppConstants.getLocation();
          print('Sending your location');
          _firestore.collection('hikes').doc(widget.passKey).update({
            'lat': AppConstants.lat,
            'long': AppConstants.long,
          });
        }
      });
    } catch (e) {
      beaconExpired();
      setState(() {
        isExpired = true;
      });
      print('InvalidPasskeyException: $e');
    }
  }

  void showPicker(BuildContext context) {
    Picker(
      adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
        const NumberPickerColumn(begin: 0, end: 999),
        const NumberPickerColumn(begin: 0, end: 999),
        const NumberPickerColumn(begin: 0, end: 60, jump: 15),
      ]),
      builderHeader: (BuildContext context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Days',
              style: TextStyle(color: Colors.white, fontSize: 15.0),
            ),
            Text(
              'Hours',
              style: TextStyle(color: Colors.white, fontSize: 15.0),
            ),
            Text(
              'Minutes',
              style: TextStyle(color: Colors.white, fontSize: 15.0),
            ),
          ],
        );
      },
      confirmText: 'OK',
      backgroundColor: Color(0xff161427),
      cancelTextStyle:
          TextStyle(inherit: false, color: Colors.redAccent[700], fontSize: 20),
      containerColor: AppConstants.background,
      headerColor: Color(0xff161427),
      confirmTextStyle:
          TextStyle(inherit: false, color: Colors.white, fontSize: 20),
      title: Text(
        'Select Duration',
        style: TextStyle(color: Colors.white),
      ),
      selectedTextStyle: TextStyle(color: Colors.white, fontSize: 25),
      textStyle: TextStyle(color: Colors.white, fontSize: 20),
      onConfirm: (Picker picker, List<int> value) {
        // You get your duration here
        _newDuration = Duration(
            days: picker.getSelectedValues()[0],
            hours: picker.getSelectedValues()[1],
            minutes: picker.getSelectedValues()[2]);
        print('${_newDuration.toString()}');
        duration = picker.getSelectedValues()[1].toString() +
            ':' +
            picker.getSelectedValues()[2].toString() +
            ':' +
            '00';
        _durationController.text = picker.getSelectedValues()[0].toString() +
            ' days ' +
            picker.getSelectedValues()[1].toString() +
            ' hours ' +
            picker.getSelectedValues()[2].toString() +
            ' minutes';
        print('${_durationController.text}');
      },
    ).showDialog(context);
  }

  void init() => initState();

  @override
  void initState() {
    super.initState();
    fetchHikersData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: _isGeneratingLink
          ? Scaffold(
              backgroundColor: Color(0xff161427),
              body: Center(child: CircularProgressIndicator()),
            )
          : Stack(
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
                _isReferred
                    ? Container(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FlatButton(
                              color: Color(0xff6bd2ab),
                              minWidth: 150,
                              child: Text('Start beacon',
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                showDialog(
                                    context: (context),
                                    builder: (context) => Dialog(
                                          backgroundColor:
                                              AppConstants.background,
                                          child: Container(
                                            height: 200,
                                            child: Scaffold(
                                              body: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10.0,
                                                          vertical: 5),
                                                      child: Container(
                                                        // width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xff2a2549),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: TextFormField(
                                                            onChanged: (name) {
                                                              _hikerName = name;
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              alignLabelWithHint:
                                                                  true,
                                                              floatingLabelBehavior:
                                                                  FloatingLabelBehavior
                                                                      .always,
                                                              hintText:
                                                                  'Name Here',
                                                              hintStyle: TextStyle(
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .white),
                                                              labelText:
                                                                  'Username',
                                                              labelStyle: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    FlatButton(
                                                      color: AppConstants
                                                          .foreground,
                                                      child: Text(
                                                        'Done',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      minWidth: 150,
                                                      onPressed: () {
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
                                                          _firestore
                                                              .collection(
                                                                  'hikes')
                                                              .doc(widget
                                                                  .passKey)
                                                              .update({
                                                            'hikers': FieldValue
                                                                .arrayUnion([
                                                              "$_hikerName"
                                                            ]),
                                                          });
                                                          SchedulerBinding
                                                              .instance!
                                                              .addPostFrameCallback(
                                                                  (_) {
                                                            setState(() {
                                                              _isReferred =
                                                                  false;
                                                            });
                                                            Navigator.pop(
                                                                context);
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
                    : SlidingUpPanel(
                        maxHeight: MediaQuery.of(context).size.height / 2,
                        minHeight: 50,
                        controller: _panelController,
                        panel: _panel(),
                      ),
                Align(
                  alignment: Alignment(1, -0.8),
                  child: FloatingActionButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                backgroundColor: AppConstants.background,
                                child: Container(
                                  height: 250,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 16),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              'Invite Friends',
                                              style: TextStyle(fontSize: 24),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Flexible(
                                          child: FlatButton(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15.0),
                                                child: Text(
                                                  'Copy and share URL',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              color: Color(0xff6bd2ab),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0)),
                                              onPressed: () async {
                                                generateUrl();
                                                Navigator.pop(context);
                                              }),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Flexible(
                                          child: FlatButton(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15.0),
                                              child: Text(
                                                'Copy and share PassKey',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            color: Color(0xff6bd2ab),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        50.0)),
                                            // color: AppConstants.foreground,
                                            onPressed: copyPasskey,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                    },
                    backgroundColor: AppConstants.foreground,
                    child: Icon(Icons.person_add),
                  ),
                ),
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
                                builder: (context) => Initiation()));
                      }
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  copyPasskey() async {
    Clipboard.setData(ClipboardData(text: widget.passKey));
    Share.text(
        'Sharing Beacon',
        'Use this passkey to get connected with this beacon: ${widget.passKey}',
        'text/plain');
    Fluttertoast.showToast(msg: 'PASSKEY: ${widget.passKey}  COPIED');
  }

  generateUrl() async {
    if (!_isGeneratingLink) {
      await _createDynamicLink(true);
      Clipboard.setData(ClipboardData(text: _linkMessage));
      Fluttertoast.showToast(msg: 'URL COPIED');
      Share.text('Sharing Beacon',
          'Get connected with this beacon: $_linkMessage', 'text/plain');
    }
  }

  Future<void> _createDynamicLink(bool short) async {
    setState(() {
      _isGeneratingLink = true;
    });
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://beaconshare.page.link',
      link: Uri.parse('https://beaconshare.page.link/?key=${widget.passKey}'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.beacon',
        minimumVersion: 0,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }
    setState(() {
      _linkMessage = url.toString();
      _isGeneratingLink = false;
    });
  }

  void relayBeacon(String newBeaconHolderName, int hikerNumber) {
    _firestore.collection('hikes').doc(widget.passKey).update({
      'leader': newBeaconHolderName,
      'hikers': FieldValue.arrayUnion(["$_hikerName"]),
    });
    Fluttertoast.showToast(msg: 'Beacon handed over to $newBeaconHolderName');
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => showExitDialog(context),
        )) ??
        false;
  }

  AlertDialog showExitDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppConstants.background,
      title: Text(
        'Exit App',
        style: TextStyle(fontSize: 25, color: AppConstants.foreground),
      ),
      content: Text(
        'Are you sure you wanna stop sending and receiving location?',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'No',
            style: TextStyle(color: Colors.red),
          ),
        ),
        FlatButton(
          onPressed: () =>
              SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
          child: Text('Yes'),
        ),
      ],
    );
  }

  Widget _panel() {
    return Container(
      color: AppConstants.background,
      // alignment: Alignment.bottomCenter,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
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
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
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
                              style: TextStyle(fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                    text: isExpired
                                        ? 'Beacon Expired - Please Exit\n'
                                        : 'Beacon expiring at ${DateFormat("hh:mm a").format(_expiringAt).toString()}\n',
                                    style: TextStyle(fontSize: 16)),
                                TextSpan(
                                    text:
                                        'Beacon holder at: ${AppConstants.lat.toStringAsFixed(4)}, ${AppConstants.long.toStringAsFixed(4)}\n',
                                    style: TextStyle(fontSize: 14)),
                                TextSpan(
                                    text:
                                        'Long press on any hiker to hand over the beacon\n',
                                    style: TextStyle(fontSize: 12)),
                                TextSpan(
                                    text:
                                        'Double Tap on beacon to change the duration\n',
                                    style: TextStyle(fontSize: 12)),
                              ]),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Color(0xff161427),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10))),
                      height: 80,
                    ),
                    Container(
                      height: 170,
                      color: AppConstants.background,
                      child: ListView.builder(
                        itemCount: hikers.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: GestureDetector(
                              onLongPress: () {
                                hikers[index] == _hikerName
                                    ? Fluttertoast.showToast(
                                        msg: 'Yeah, that\'s you')
                                    : hikers[0] == _hikerName
                                        ? relayBeacon(hikers[index], index)
                                        : Fluttertoast.showToast(
                                            msg:
                                                'You dont have beacon to relay');
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppConstants.foreground,
                                  radius: 18,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Icon(
                                        Icons.person_outline,
                                        color: Colors.white,
                                      )),
                                ),
                                title: Text(
                                  hikers[index],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                trailing: index == 0
                                    ? GestureDetector(
                                        onDoubleTap: () {
                                          hikers[0] != _hikerName
                                              ? Fluttertoast.showToast(
                                                  msg:
                                                      'Only beacon holder has access to change the duration')
                                              : showDialog(
                                                  context: context,
                                                  builder: (context) => Dialog(
                                                        backgroundColor:
                                                            AppConstants
                                                                .background,
                                                        child: Container(
                                                          height: 250,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16,
                                                                    vertical:
                                                                        16),
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          10.0,
                                                                      vertical:
                                                                          5),
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      showPicker(
                                                                          context);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      // width: double.infinity,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Color(
                                                                            0xff2a2549),
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets.symmetric(
                                                                            vertical:
                                                                                10.0,
                                                                            horizontal:
                                                                                15),
                                                                        child:
                                                                            TextFormField(
                                                                          controller:
                                                                              _durationController,
                                                                          // onSaved: (value) {
                                                                          //   duration = value;
                                                                          // },
                                                                          enabled:
                                                                              false,
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                          cursorColor:
                                                                              Colors.white,
                                                                          decoration: InputDecoration(
                                                                              alignLabelWithHint: true,
                                                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                              labelText: 'Duration',
                                                                              labelStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                                                                              hintText: 'Select beacon duration',
                                                                              hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                                                                              focusedBorder: InputBorder.none,
                                                                              enabledBorder: InputBorder.none),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 30,
                                                                ),
                                                                Flexible(
                                                                  child: FlatButton(
                                                                      minWidth: 150,
                                                                      child: Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(vertical: 15.0),
                                                                        child:
                                                                            Text(
                                                                          'Done',
                                                                          style: TextStyle(
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                      color: Color(0xff6bd2ab),
                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
                                                                      onPressed: () {
                                                                        DateTime
                                                                            newTime =
                                                                            DateTime.now().add(_newDuration);
                                                                        _firestore
                                                                            .collection('hikes')
                                                                            .doc(widget.passKey)
                                                                            .update({
                                                                          'expiringAt':
                                                                              newTime,
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
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
                                          color: AppConstants.foreground,
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
    );
  }
}
