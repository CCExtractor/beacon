import 'dart:async';
import 'dart:io';

import 'package:beacon/components/hike_button.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:beacon/view_model/hike_screen_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:sizer/sizer.dart';

class HikeScreenWidget {
  static copyPasskey(String passkey) {
    Clipboard.setData(ClipboardData(text: passkey));
    Fluttertoast.showToast(msg: 'PASSKEY: $passkey  COPIED');
  }

  static generateUrl(String shortcode) async {
    Uri url = Uri.parse('https://beacon.aadibajpai.com/?shortcode=$shortcode');
    Share.share('To join beacon follow this link: $url');
  }

  static Widget shareButton(BuildContext context, String passkey) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              height: 30.h,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
                      height: 3.5.h,
                    ),
                    Flexible(
                      child: HikeButton(
                          buttonHeight: optbheight - 4,
                          textSize: 16,
                          text: 'Generate URL',
                          textColor: Colors.white,
                          buttonColor: kYellow,
                          onTap: () async {
                            generateUrl(passkey);
                            navigationService.pop();
                          }),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Flexible(
                      child: HikeButton(
                        buttonHeight: optbheight - 4,
                        textSize: 16,
                        text: 'Copy Passkey',
                        textColor: Colors.white,
                        buttonColor: kYellow,
                        onTap: () {
                          copyPasskey(passkey);
                          navigationService.pop();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
      backgroundColor: kYellow,
      child: Icon(Icons.person_add),
    );
  }

  static Widget shareRouteButton(
    BuildContext context,
    Beacon beacon,
    Completer<GoogleMapController> googleMapControllerCompleter,
    List<LatLng> beaconRoute,
  ) {
    return FloatingActionButton(
      heroTag:
          'shareRouteTag', //had to pass this tag else we would get error since there will be two FAB in the same subtree with the same tag.
      onPressed: () async {
        final mapController = await googleMapControllerCompleter.future;
        // sanity check.
        if (mapController == null ||
            googleMapControllerCompleter.isCompleted == false) return;
        if (!await connectionChecker.checkForInternetConnection()) {
          navigationService.showSnackBar(
              'Cannot share the route, please check your internet connection.');
          return;
        }
        //show marker description so that image will be more usefull.
        await mapController.showMarkerInfoWindow(MarkerId("1"));
        //getting the image (ss) of map.
        final image = await mapController.takeSnapshot();
        // getting the app directory
        final appDir = await getApplicationDocumentsDirectory();
        // Creating a file for the image.
        File imageFile = await File('${appDir.path}/shareImage.png').create();
        //writing the image to the file we just created so that it can be shared.
        imageFile.writeAsBytesSync(image);
        // initial coordinates
        Coordinates coordinates = Coordinates(
          beaconRoute.first.latitude,
          beaconRoute.first.longitude,
        );
        // initial address
        var initialAddress =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        //current coordinates
        coordinates = Coordinates(
          beaconRoute.last.latitude,
          beaconRoute.last.longitude,
        );
        //current address
        var currentAddress =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        // All the neccessary info should be here.
        String textToShare =
            "${beacon.title} Beacon started at: ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt)).toString()} from: ${initialAddress.first.addressLine}.\n\nIt will end on: ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt)).toString()}.\n\nBeacon's current location is: ${currentAddress.first.addressLine}.\n\nBeacon's current leader is: ${beacon.leader.name}.\n\nTo join this beacon, enter this code in the app: ${beacon.shortcode}.\nYou can also join the beacon by clicking the following link: https://beacon.aadibajpai.com/?shortcode=${beacon.shortcode}";
        //Will be used as subject if shared via email, else isnt used.
        String subjectToShare = "${beacon.title} beacons's route";
        await Share.shareFiles([imageFile.path],
            text: textToShare, subject: subjectToShare);
        //hide after sharing.
        await mapController.hideMarkerInfoWindow(MarkerId("1"));
        return;
      },
      backgroundColor: kYellow,
      child: Icon(
        Icons.share,
      ),
    );
  }

  static Column panel(ScrollController sc, HikeScreenViewModel model,
      BuildContext context, bool isLeader) {
    return Column(
      children: [
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
              isLeader
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
                          ],
                        ),
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
                  itemCount: model.hikers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        model.hikers[index].id == userConfig.currentUser.id
                            ? Fluttertoast.showToast(msg: 'Yeah, that\'s you')
                            : model.beacon.leader.id ==
                                    userConfig.currentUser.id
                                ? model.relayBeacon(model.hikers[index])
                                : Fluttertoast.showToast(
                                    msg: 'You dont have beacon to relay');
                      },
                      leading: CircleAvatar(
                        backgroundColor:
                            model.isBeaconExpired ? Colors.grey : kYellow,
                        radius: 18,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Icon(
                              Icons.person_outline,
                              color: Colors.white,
                            )),
                      ),
                      title: Text(
                        model.hikers[index].name,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      trailing: model.hikers[index].id == model.beacon.leader.id
                          ? GestureDetector(
                              onDoubleTap: () {
                                isLeader
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
                                color: model.isBeaconExpired
                                    ? Colors.grey
                                    : kYellow,
                                size: 40,
                              ),
                            )
                          : Container(width: 10),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static void showCreateLandMarkDialogueDialog(
    BuildContext context,
    var landmarkFormKey,
    var title,
    var loc,
    Future<void> createLandmark(var landmarkTitle, var location),
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height < 800 ? 30.h : 25.h,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Form(
              key: landmarkFormKey,
              child: Column(
                children: <Widget>[
                  Container(
                    height:
                        MediaQuery.of(context).size.height < 800 ? 14.h : 12.h,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        style: TextStyle(fontSize: 20.0),
                        onChanged: (key) {
                          title = key;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter title for landmark";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          alignLabelWithHint: true,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Add title for the landmark',
                          hintStyle:
                              TextStyle(fontSize: hintsize, color: hintColor),
                          labelText: 'Title',
                          labelStyle:
                              TextStyle(fontSize: labelsize, color: kYellow),
                        ),
                      ),
                    ),
                    color: kLightBlue,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Flexible(
                    child: HikeButton(
                      text: 'Create Landmark',
                      textSize: 17.0,
                      textColor: Colors.white,
                      buttonColor: kYellow,
                      onTap: () => createLandmark(title, loc),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
