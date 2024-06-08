import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:beacon/Bloc/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/old/components/active_beacon.dart';
import 'package:beacon/old/components/models/location/location.dart';
import 'package:beacon/old/components/models/user/user_info.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/old/components/models/beacon/beacon.dart';
import 'package:beacon/old/components/utilities/constants.dart';
import 'package:beacon/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:intl/intl.dart';

class BeaconCustomWidgets {
  static final Color textColor = Color(0xFFAFAFAF);

  static Widget getBeaconCard(BuildContext context, BeaconEntity beacon) {
    print(beacon.leader!.name);
    bool hasStarted;
    bool hasEnded;
    bool willStart;
    hasStarted = DateTime.now()
        .isAfter(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt!));
    hasEnded = DateTime.now()
        .isAfter(DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt!));
    willStart = DateTime.now()
        .isBefore(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt!));
    return GestureDetector(
      onTap: () async {
        if (hasEnded)
          utils.showSnackBar('Beacon is not active anymore!', context);
        bool isJoinee = false;
        for (var i in beacon.followers!) {
          if (i!.id == localApi.userModel.id) {
            isJoinee = true;
          }
        }
        if (!hasStarted) {
          utils.showSnackBar(
              'Beacon has not yet started! \nPlease come back at ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt!)).toString()}',
              context);
          return;
        }
        if (hasStarted &&
            (beacon.leader!.id == localApi.userModel.id || isJoinee)) {
          log('here');
          // navigationService!.pushScreen('/hikeScreen',
          //     arguments: HikeScreen(
          //       beacon,
          //       isLeader: (beacon.leader!.id == userConfig!.currentUser!.id),
          //     ));

          // for(int i=0; i<beacon.followers!.length; i++){

          //   users.add(value)

          // }

          log('beacon id: ${beacon.id.toString()}');

          Beacon refrencedBeacon = Beacon(
              expiresAt: beacon.expiresAt,
              followers: [],
              id: beacon.id,
              shortcode: beacon.shortcode,
              startsAt: beacon.startsAt,
              title: beacon.title,
              leader: User(id: beacon.leader!.id),
              group: beacon.group == null ? '' : beacon.group!.id,
              landmarks: [],
              location: Location(
                  lat: beacon.location!.lat, lon: beacon.location!.lon),
              route: []);

          log('location: ${beacon.location!.lon} ${beacon.location!.lat}');

          AutoRouter.of(context)
              .push(HikeScreenRoute(beacon: refrencedBeacon, isLeader: false));
        }
        // else {
        //   await databaseFunctions!.init();
        //   final Beacon? _beacon =
        //       await databaseFunctions!.joinBeacon(beacon.shortcode);
        //   if (!hasStarted) {
        //     // navigationService!.showSnackBar(
        //     //   'Beacon has not yet started! \nPlease come back at ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt!)).toString()}',
        //     // );
        //     return;
        //   }
        //   if (hasStarted && _beacon != null) {
        //     // navigationService!.pushScreen('/hikeScreen',
        //     //     arguments: HikeScreen(beacon, isLeader: false));
        //     AutoRouter.of(context).pushNamed('/hike');
        //   }
        //   //Snackbar is displayed by joinBeacon itself on any error or trying to join expired beacon.
        // }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 10.0,
        ),
        padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8, top: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            (hasStarted && !hasEnded)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 70.w,
                            child: Text(
                              '${beacon.title} by ${beacon.leader!.name} ',
                              style: Style.titleTextStyle,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: BlinkIcon(),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.0),
                      RichText(
                        text: TextSpan(
                          text: 'Hike is ',
                          style: Style.commonTextStyle,
                          children: const <TextSpan>[
                            TextSpan(
                              text: 'Active',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text('Passkey: ${beacon.shortcode}',
                              style: Style.commonTextStyle),
                          IconButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: beacon.shortcode.toString()));
                                utils.showSnackBar(
                                    'Shortcode copied!', context);
                              },
                              icon: Icon(
                                Icons.copy,
                                color: Colors.white,
                                size: 15,
                              ))
                        ],
                      ),
                      (beacon.startsAt != null)
                          ? Text(
                              'Started At: ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt!)).toString()}',
                              style: Style.commonTextStyle)
                          : Container(),
                      SizedBox(height: 4.0),
                      (beacon.expiresAt != null)
                          ? Text(
                              'Expires At: ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt!)).toString()}',
                              style: Style.commonTextStyle)
                          : Container(),
                    ],
                  )
                : (willStart)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 70.w,
                                child: Text(
                                  '${beacon.title} by ${beacon.leader!.name} ',
                                  style: Style.titleTextStyle,
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Icon(
                                  Icons.circle,
                                  color: kYellow,
                                  size: 10,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.0),
                          Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'Hike ',
                                  style: Style.commonTextStyle,
                                  children: const <TextSpan>[
                                    TextSpan(
                                      text: 'Starts ',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0),
                                    ),
                                    TextSpan(
                                      text: 'in ',
                                      style: TextStyle(
                                          color: const Color(0xffb6b2df),
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 3.0,
                              ),
                              // CountdownTimerPage(
                              //   dateTime: DateTime.fromMillisecondsSinceEpoch(
                              //       beacon.startsAt!),
                              //   name: beacon.title,
                              //   beacon: Beacon(),
                              // )
                            ],
                          ),
                          // SizedBox(height: 4.0),
                          Row(
                            children: [
                              Text('Passkey: ${beacon.shortcode}',
                                  style: Style.commonTextStyle),
                              IconButton(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                        text: beacon.shortcode.toString()));
                                    utils.showSnackBar(
                                        'Shortcode copied!', context);
                                  },
                                  icon: Icon(
                                    Icons.copy,
                                    color: Colors.white,
                                    size: 15,
                                  ))
                            ],
                          ),
                          // SizedBox(height: 4.0),
                          (beacon.startsAt != null)
                              ? Text(
                                  'Starts At: ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt!)).toString()}',
                                  style: Style.commonTextStyle)
                              : Container(),
                          SizedBox(height: 4.0),
                          (beacon.expiresAt != null)
                              ? Text(
                                  'Expires At: ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt!)).toString()}',
                                  style: Style.commonTextStyle)
                              : Container(),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 70.w,
                            child: Text(
                              '${beacon.title} by ${beacon.leader!.name} ',
                              style: Style.titleTextStyle,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          RichText(
                            text: TextSpan(
                              text: 'Hike has ',
                              style: Style.commonTextStyle,
                              children: const <TextSpan>[
                                TextSpan(
                                  text: 'Ended',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text('Passkey: ${beacon.shortcode}',
                                  style: Style.commonTextStyle),
                              IconButton(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                        text: beacon.shortcode.toString()));
                                    utils.showSnackBar(
                                        'Shortcode copied!', context);
                                  },
                                  icon: Icon(
                                    Icons.copy,
                                    color: Colors.white,
                                    size: 15,
                                  ))
                            ],
                          ),
                          SizedBox(height: 4.0),
                          (beacon.startsAt != null)
                              ? Text(
                                  'Started At: ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt!)).toString()}',
                                  style: Style.commonTextStyle)
                              : Container(),
                          SizedBox(height: 4.0),
                          (beacon.expiresAt != null)
                              ? Text(
                                  'Expired At: ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt!)).toString()}',
                                  style: Style.commonTextStyle)
                              : Container(),
                        ],
                      ),
          ],
        ),
        decoration: BoxDecoration(
          color: willStart
              ? Color(0xFF141546)
              : hasEnded
                  ? lightkBlue
                  : kBlue,
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

  static ListView getPlaceholder() {
    final BorderRadius borderRadius = BorderRadius.circular(10.0);
    return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        itemCount: 3,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 10.0,
            ),
            height: 110,
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
            padding:
                EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10, top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, bottom: 10.0, right: 15.0),
                  child: ClipRRect(
                    borderRadius: borderRadius,
                    child: SkeletonAnimation(
                      child: Container(
                        height: 15.0,
                        decoration: BoxDecoration(color: shimmerSkeletonColor),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 30.0, bottom: 10.0),
                  child: ClipRRect(
                    borderRadius: borderRadius,
                    child: SkeletonAnimation(
                      child: Container(
                        height: 10.0,
                        decoration: BoxDecoration(color: shimmerSkeletonColor),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 45.0, bottom: 10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: SkeletonAnimation(
                      child: Container(
                        height: 10.0,
                        decoration: BoxDecoration(color: shimmerSkeletonColor),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 60.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: SkeletonAnimation(
                      child: Container(
                        height: 10.0,
                        decoration: BoxDecoration(color: shimmerSkeletonColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
