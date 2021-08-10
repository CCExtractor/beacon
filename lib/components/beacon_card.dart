import 'dart:io';

import 'package:beacon/locator.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class BeaconCustomWidgets {
  static final Color textColor = Color(0xFFAFAFAF);

  static Widget getBeaconCard(BuildContext context, Beacon beacon) {
    return GestureDetector(
      onTap: () {
        navigationService.pushScreen('/hikeScreen');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 10.0,
        ),
        height: 70,
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 4.0),
            Text('${beacon?.title}', style: Style.titleTextStyle),
            SizedBox(height: 8.0),
            Text('${beacon?.shortcode}', style: Style.commonTextStyle),
            SizedBox(height: 8.0),
            (beacon.startsAt != null)
                ? Text(
                    'Start DateTime: ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt)).toString()}',
                    style: Style.commonTextStyle)
                : Container(),
            SizedBox(height: 8.0),
            (beacon.expiresAt != null)
                ? Text(
                    'Expiry DateTime: ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt)).toString()}',
                    style: Style.commonTextStyle)
                : Container(),
          ],
        ),
        decoration: BoxDecoration(
          color: kBlue,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
      ),
    );
  }

  // static ListView getPlaceholder() {
  //   final BorderRadius borderRadius = BorderRadius.circular(10.0);
  //   return ListView.builder(
  //       scrollDirection: Axis.vertical,
  //       physics: BouncingScrollPhysics(),
  //       itemCount: 5,
  //       itemBuilder: (BuildContext context, int index) {
  //         return Padding(
  //           padding: const EdgeInsets.all(10.0),
  //           child: Container(
  //             decoration: BoxDecoration(
  //                 borderRadius: borderRadius, color: Colors.transparent),
  //             child: Container(
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 mainAxisSize: MainAxisSize.max,
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: <Widget>[
  //                   ClipRRect(
  //                     borderRadius: borderRadius,
  //                     child: SkeletonAnimation(
  //                       child: Container(
  //                         width: 110.0,
  //                         height: 110.0,
  //                         decoration: BoxDecoration(
  //                           color: shimmerSkeletonColor,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   Column(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisSize: MainAxisSize.max,
  //                     children: <Widget>[
  //                       Padding(
  //                         padding: const EdgeInsets.only(
  //                           left: 15.0,
  //                           bottom: 15.0,
  //                         ),
  //                         child: ClipRRect(
  //                           borderRadius: borderRadius,
  //                           child: SkeletonAnimation(
  //                             child: Container(
  //                               height: 20.0,
  //                               width: MediaQuery.of(context).size.width * 0.5,
  //                               decoration:
  //                                   BoxDecoration(color: shimmerSkeletonColor),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.only(
  //                             left: 15.0, right: 5.0, bottom: 15.0),
  //                         child: ClipRRect(
  //                           borderRadius: borderRadius,
  //                           child: SkeletonAnimation(
  //                             child: Container(
  //                               width: MediaQuery.of(context).size.width * 0.4,
  //                               height: 20.0,
  //                               decoration:
  //                                   BoxDecoration(color: shimmerSkeletonColor),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.only(
  //                             left: 15.0, right: 5.0, bottom: 15.0),
  //                         child: ClipRRect(
  //                           borderRadius: BorderRadius.circular(10.0),
  //                           child: SkeletonAnimation(
  //                             child: Container(
  //                               width: MediaQuery.of(context).size.width * 0.3,
  //                               height: 20.0,
  //                               decoration:
  //                                   BoxDecoration(color: shimmerSkeletonColor),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }
}
