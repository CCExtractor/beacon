import 'dart:async';
import 'dart:io';

import 'package:beacon/components/hike_button.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/utilities/constants.dart';
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
                  child: Container(
                    height: 35.h,
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
                            height: 3.h,
                          ),
                          Flexible(
                            child: HikeButton(
                                buttonHeight: optbheight,
                                buttonWidth: optbwidth,
                                textSize: 18,
                                text: 'Generate URL',
                                textColor: Colors.white,
                                buttonColor: kYellow,
                                onTap: () async {
                                  generateUrl(passkey);
                                  navigationService.pop();
                                }),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Flexible(
                            child: HikeButton(
                              buttonHeight: optbheight * 1,
                              buttonWidth: optbwidth,
                              textSize: 18,
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
                ));
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
        if (mapController == null) return;
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
}
