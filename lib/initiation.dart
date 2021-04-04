import 'package:beacon/constants.dart';
import 'package:beacon/routeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

class Initiation extends StatefulWidget {
  Initiation({Key? key}) : super(key: key);

  @override
  _InitiationState createState() => _InitiationState();
}

class _InitiationState extends State<Initiation> {
  final _firestore = FirebaseFirestore.instance;
  bool _isTappable = false;
  String username = 'Anonymous';
  String duration = '00:00:00';
  DateTime selectedTime = DateTime.now().subtract(Duration(hours: 1));
  Duration _duration = Duration(hours: 0, minutes: 0);
  TextEditingController _durationController = new TextEditingController();

  Future<void> initDynamicLinks() async {
    PendingDynamicLinkData? data =
        (await FirebaseDynamicLinks.instance.getInitialLink());
    Uri? deepLink = data?.link;

    if (deepLink != null) {
      print('Deep Link: $deepLink');
      String receivedPasskey = deepLink.queryParameters['key']!;
      await _firestore
          .collection('hikes')
          .doc(receivedPasskey)
          .get()
          .then((value) {
        AppConstants.lat = value.data()!["lat"];
        AppConstants.long = value.data()!["long"];
        value.exists
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HikeScreen(
                    receivedPasskey,
                    isReferred: true,
                    hickerName: 'Anonymous',
                  ),
                ))
            : Fluttertoast.showToast(msg: 'URL expired');
      });
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;

      if (deepLink != null) {
        print('Deep Link: $deepLink');
        String receivedPasskey = deepLink.queryParameters['key']!;
        await _firestore
            .collection('hikes')
            .doc(receivedPasskey)
            .get()
            .then((value) {
          AppConstants.lat = value.data()!["lat"];
          AppConstants.long = value.data()!["long"];
          value.exists
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HikeScreen(
                      receivedPasskey,
                      isReferred: true,
                      hickerName: 'Anonymous',
                    ),
                  ))
              : Fluttertoast.showToast(msg: 'URL expired');
        });
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  createHikeRoom() async {
    setState(() {
      _isTappable = true;
    });
    DocumentReference ref = await _firestore.collection('hikes').add({
      'leader': username,
      'hikers': FieldValue.arrayUnion(["$username"]),
      'lat': AppConstants.lat,
      'long': AppConstants.long,
      'expiringAt': DateTime.now().add(_duration),
    });
    String passKey = ref.id;
    print(ref.id);
    setState(() {
      _isTappable = false;
    });
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HikeScreen(
                  passKey,
                  isReferred: false,
                  hickerName: username,
                )));
  }

  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    AppConstants.long = position.longitude;
    AppConstants.lat = position.latitude;
  }

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
    getLocation();
  }

  validatePasskey(String enteredPasskey) async {
    setState(() {
      _isTappable = true;
    });
    try {
      await _firestore.collection('hikes').doc(enteredPasskey).update({
        "hikers": FieldValue.arrayUnion(['$username'])
      }).then((_) {
        print('success');
      });
      await _firestore
          .collection('hikes')
          .doc(enteredPasskey)
          .get()
          .then((value) {
        AppConstants.lat = value.data()!["lat"];
        AppConstants.long = value.data()!["long"];
        value.exists
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HikeScreen(
                    enteredPasskey,
                    isReferred: true,
                    hickerName: username,
                  ),
                ))
            : Fluttertoast.showToast(msg: 'Invalid Passkey');
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: 'Invalid Passkey');
    }
    setState(() {
      _isTappable = false;
    });
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
      containerColor: Color(0xff161427),
      headerColor: Color(0xff161427),
      cancelTextStyle:
          TextStyle(inherit: false, color: Colors.redAccent[700], fontSize: 20),
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
        _duration = Duration(
            days: picker.getSelectedValues()[0],
            hours: picker.getSelectedValues()[1],
            minutes: picker.getSelectedValues()[2]);
        print('$_duration');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff161427),
      body: _isTappable
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Welcome to your',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'BEACON',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xff75e6b8),
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Let\'s make travelling easy',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                      ]),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FlatButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                        backgroundColor: Color(0xff161427),
                                        child: Container(
                                          height: 400,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 16),
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 5),
                                                  child: Container(
                                                    // width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xff2a2549),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: TextFormField(
                                                        onChanged: (name) {
                                                          username = name;
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          alignLabelWithHint:
                                                              true,
                                                          floatingLabelBehavior:
                                                              FloatingLabelBehavior
                                                                  .always,
                                                          hintText: 'Name Here',
                                                          hintStyle: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.white),
                                                          labelText: 'Username',
                                                          labelStyle: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 5),
                                                  child: InkWell(
                                                    onTap: () {
                                                      showPicker(context);
                                                    },
                                                    child: Container(
                                                      // width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xff2a2549),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 10.0,
                                                                horizontal: 15),
                                                        child: TextFormField(
                                                          controller:
                                                              _durationController,
                                                          // onSaved: (value) {
                                                          //   duration = value;
                                                          // },
                                                          enabled: false,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          cursorColor:
                                                              Colors.white,
                                                          decoration: InputDecoration(
                                                              alignLabelWithHint:
                                                                  true,
                                                              floatingLabelBehavior:
                                                                  FloatingLabelBehavior
                                                                      .always,
                                                              labelText:
                                                                  'Duration',
                                                              labelStyle: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                              hintText:
                                                                  'Select beacon duration',
                                                              hintStyle: TextStyle(
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .white),
                                                              focusedBorder:
                                                                  InputBorder
                                                                      .none,
                                                              enabledBorder:
                                                                  InputBorder
                                                                      .none),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      150,
                                                  child: FlatButton(
                                                    textColor: Colors.white,
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      selectedTime =
                                                          DateTime.now()
                                                              .add(_duration);
                                                      createHikeRoom();
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 15.0),
                                                      child: Text(
                                                        'Create',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    color: Color(0xff6bd2ab),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100.0)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ));
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: Text(
                                'Create Hike',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            color: Color(0xff6bd2ab),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FlatButton(
                            onPressed: () async {
                              String enteredPasskey = '';
                              showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                      child: Container(
                                          height: 200,
                                          color: AppConstants.background,
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 32,
                                                      vertical: 16),
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: TextFormField(
                                                        onChanged: (key) {
                                                          enteredPasskey = key;
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Passkey Here',
                                                          hintStyle: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.white),
                                                          labelText: 'Passkey',
                                                          labelStyle: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                    color:
                                                        AppConstants.background,
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Flexible(
                                                    child: FlatButton(
                                                        minWidth: 90,
                                                        child: Text(
                                                          'Validate',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        color: AppConstants
                                                            .foreground,
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          validatePasskey(
                                                              enteredPasskey);
                                                        }),
                                                  ),
                                                ],
                                              )))));
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: Text(
                                'Join Hike',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            color: Color(0xff6bd2ab),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0)),
                          ),
                        ],
                      )
                    ]),
              ),
            ),
    );
  }
}
