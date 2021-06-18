import 'dart:ui';

import 'package:beacon/components/create_join_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../components/hike_button.dart';
import '../components/shape_painter.dart';
import '../utilities/constants.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isCreatingHikeRoom = false;

  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    AppConstants.long = position.longitude;
    AppConstants.lat = position.latitude;
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  double _screenHeight, _screenWidth;

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: isCreatingHikeRoom,
        child: Stack(
          children: <Widget>[
            Scaffold(
              body: Container(
                margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
                child: Center(
                  child: Image(
                    image: AssetImage('images/hikers_group.png'),
                  ),
                ),
              ),
            ),
            CustomPaint(
              size: Size(_screenWidth, _screenHeight),
              painter: ShapePainter(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  HikeButton(
                    text: 'Create Hike',
                    textColor: Colors.white,
                    borderColor: Colors.white,
                    buttonColor: kYellow,
                    buttonWidth: 64,
                    onTap: () {
                      CreateJoinBeaconDialog.createHikeDialog(context);
                    },
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 20,
                  ),
                  HikeButton(
                    text: 'Join a Hike',
                    textColor: kYellow,
                    borderColor: kYellow,
                    buttonColor: Colors.white,
                    buttonWidth: 64,
                    onTap: () async {
                      CreateJoinBeaconDialog.joinBeaconDialog(context);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
