import 'package:beacon/components/active_beacon.dart';
import 'package:beacon/components/timer.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:beacon/views/hike_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:intl/intl.dart';

class BeaconCustomWidgets {
  static final Color textColor = Color(0xFFAFAFAF);

  static Widget getBeaconCard(BuildContext context, Beacon beacon) {
    bool hasStarted;
    bool hasEnded;
    bool willStart;
    hasStarted = DateTime.now()
        .isAfter(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt));
    hasEnded = DateTime.now()
        .isAfter(DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt));
    willStart = DateTime.now()
        .isBefore(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt));
    return GestureDetector(
      onTap: () async {
        bool isJoinee = false;
        for (var i in beacon.followers) {
          if (i.id == userConfig.currentUser.id) {
            isJoinee = true;
          }
        }
        if (!hasStarted) {
          navigationService.showSnackBar(
            'Beacon has not yet started! \nPlease come back at ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt)).toString()}',
          );
          return;
        }
        if (hasStarted &&
            (beacon.leader.id == userConfig.currentUser.id || isJoinee)) {
          navigationService.pushScreen('/hikeScreen',
              arguments: HikeScreen(
                beacon,
                isLeader: (beacon.leader.id == userConfig.currentUser.id),
              ));
        } else {
          await databaseFunctions.init();
          final Beacon _beacon =
              await databaseFunctions.joinBeacon(beacon.shortcode);
          if (!hasStarted) {
            navigationService.showSnackBar(
              'Beacon has not yet started! \nPlease come back at ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt)).toString()}',
            );
            return;
          }
          if (hasStarted && _beacon != null) {
            navigationService.pushScreen('/hikeScreen',
                arguments: HikeScreen(beacon, isLeader: false));
          }
          //Snackbar is displayed by joinBeacon itself on any error or trying to join expired beacon.
        }
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
                              '${beacon?.title} by ${beacon.leader.name} ',
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
                      SizedBox(height: 4.0),
                      Text('Passkey: ${beacon?.shortcode}',
                          style: Style.commonTextStyle),
                      SizedBox(height: 4.0),
                      (beacon.startsAt != null)
                          ? Text(
                              'Started At: ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt)).toString()}',
                              style: Style.commonTextStyle)
                          : Container(),
                      SizedBox(height: 4.0),
                      (beacon.expiresAt != null)
                          ? Text(
                              'Expires At: ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt)).toString()}',
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
                                  '${beacon?.title} by ${beacon.leader.name} ',
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
                              CountdownTimerPage(
                                dateTime: DateTime.fromMillisecondsSinceEpoch(
                                    beacon.startsAt),
                                name: beacon?.title,
                                beacon: beacon,
                              )
                            ],
                          ),
                          SizedBox(height: 4.0),
                          Text('Passkey: ${beacon?.shortcode}',
                              style: Style.commonTextStyle),
                          SizedBox(height: 4.0),
                          (beacon.startsAt != null)
                              ? Text(
                                  'Starts At: ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt)).toString()}',
                                  style: Style.commonTextStyle)
                              : Container(),
                          SizedBox(height: 4.0),
                          (beacon.expiresAt != null)
                              ? Text(
                                  'Expires At: ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt)).toString()}',
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
                              '${beacon?.title} by ${beacon.leader.name} ',
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
                          SizedBox(height: 4.0),
                          Text('Passkey: ${beacon?.shortcode}',
                              style: Style.commonTextStyle),
                          SizedBox(height: 4.0),
                          (beacon.startsAt != null)
                              ? Text(
                                  'Started At: ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt)).toString()}',
                                  style: Style.commonTextStyle)
                              : Container(),
                          SizedBox(height: 4.0),
                          (beacon.expiresAt != null)
                              ? Text(
                                  'Expired At: ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt)).toString()}',
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
