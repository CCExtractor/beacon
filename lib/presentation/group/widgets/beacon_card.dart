import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:beacon/core/utils/constants.dart';
import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/presentation/group/cubit/group_cubit/group_cubit.dart';
import 'package:beacon/presentation/hike/widgets/active_beacon.dart';
import 'package:beacon/presentation/widgets/hike_button.dart';
import 'package:beacon/presentation/group/widgets/timer.dart';
import 'package:beacon/config/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BeaconCard extends StatefulWidget {
  final BeaconEntity beacon;
  final void Function()? onDelete;
  final void Function()? onReschedule;
  BeaconCard(
      {required this.beacon,
      required this.onDelete,
      required this.onReschedule,
      Key? key})
      : super(key: key);

  @override
  State<BeaconCard> createState() => _BeaconCardState();
}

class _BeaconCardState extends State<BeaconCard> {
  late bool hasStarted;
  late bool hasEnded;
  late bool willStart;
  DateTime now = DateTime.now();
  late DateTime startAt;
  late DateTime expiresAt;
  Timer? _rebuildTimer;

  @override
  void initState() {
    startAt = DateTime.fromMillisecondsSinceEpoch(widget.beacon.startsAt!);
    expiresAt = DateTime.fromMillisecondsSinceEpoch(widget.beacon.expiresAt!);
    hasStarted = now.isAfter(startAt);
    hasEnded = now.isAfter(expiresAt);
    willStart = now.isBefore(startAt);
    scheduleRebuild();
    super.initState();
  }

  void scheduleRebuild() {
    if (hasEnded) return;

    late int seconds;

    if (willStart) {
      Duration difference = startAt.difference(now);
      seconds = difference.inSeconds;
    } else if (hasStarted && !hasEnded) {
      Duration difference = expiresAt.difference(now);
      seconds = difference.inSeconds;
    }
    _rebuildTimer?.cancel();

    _rebuildTimer = Timer(Duration(milliseconds: seconds * 1000 + 1000), () {
      var now = DateTime.now();
      hasStarted = now.isAfter(startAt);
      hasEnded = now.isAfter(expiresAt);
      willStart = now.isBefore(startAt);
      setState(() {});

      Future.delayed(Duration(seconds: 1), () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 5),
            content: Text(
              '${widget.beacon.title} is now active! \nYou can join the hike',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: kLightBlue.withValues(alpha: 0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            behavior: SnackBarBehavior.floating,
            elevation: 5,
            action: SnackBarAction(
              textColor: kBlue,
              label: 'Click to Join',
              onPressed: () async {
                appRouter.push(HikeScreenRoute(
                    beacon: widget.beacon,
                    isLeader: widget.beacon.id! == localApi.userModel.id!));
              },
            ),
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    _rebuildTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BeaconEntity beacon = widget.beacon;

    return InkWell(
      onTap: () async {
        locator<GroupCubit>().joinBeacon(beacon, hasEnded, hasStarted);
      },
      child: Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8, top: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 70.w,
                        child: Row(
                          children: [
                            Icon(
                              Icons.hiking,
                              color: Colors.black,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              '${beacon.title!.toUpperCase()} by ${beacon.leader!.name} ',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: (hasStarted && !hasEnded)
                            ? BlinkIcon()
                            : willStart
                                ? Align(
                                    alignment: Alignment.topRight,
                                    child: Icon(
                                      Icons.circle,
                                      color: kYellow,
                                      size: 10,
                                    ),
                                  )
                                : null,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  (hasStarted && !hasEnded)
                      ? RichText(
                          text: TextSpan(
                            text: 'Hike is ',
                            style: Style.commonTextStyle,
                            children: const <TextSpan>[
                              TextSpan(
                                text: 'Active',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0),
                              ),
                            ],
                          ),
                        )
                      : willStart
                          ? Row(
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
                                            color: Colors.black,
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
                                      beacon.startsAt!),
                                  name: beacon.title,
                                  beacon: beacon,
                                )
                              ],
                            )
                          : Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'Hike ',
                                    style: Style.commonTextStyle,
                                    children: const <TextSpan>[
                                      TextSpan(
                                        text: 'is Ended',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text('Passkey: ${beacon.shortcode}',
                          style: Style.commonTextStyle),
                      Gap(10),
                      InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                text: beacon.shortcode.toString()));
                            utils.showSnackBar('Shortcode copied!', context);
                          },
                          child: Icon(
                            Icons.copy,
                            color: Colors.black,
                            size: 15,
                          ))
                    ],
                  ),
                  SizedBox(height: 4.0),
                  (beacon.startsAt != null)
                      ? Text(
                          willStart
                              ? 'Starting At: ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt!)).toString()}'
                              : 'Started At: ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt!)).toString()}',
                          style: Style.commonTextStyle)
                      : Container(),
                  SizedBox(height: 4.0),
                  (beacon.expiresAt != null)
                      ? willStart
                          ? Text(
                              'Expiring At: ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt!)).toString()}',
                              style: Style.commonTextStyle)
                          : Text(
                              'Expires At: ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt!)).toString()}',
                              style: Style.commonTextStyle)
                      : Container(),
                  SizedBox(height: 4.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            visualDensity: const VisualDensity(
                                horizontal: -2.0, vertical: -2.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            side: const BorderSide(color: Colors.black)),
                        onPressed: widget.onDelete,
                        child: const Text("Delete"),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            visualDensity: const VisualDensity(
                                horizontal: .0, vertical: -2.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            foregroundColor: Colors.black,
                            side: const BorderSide(color: Colors.black)),
                        onPressed: widget.onReschedule,
                        child: const Text("Reschedule"),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 1.0),
                blurRadius: 6.0,
              ),
            ],
          )),
    );
  }

  Future<bool?> deleteDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        // actionsAlignment: MainAxisAlignment.spaceEvenly,
        contentPadding: EdgeInsets.all(25.0),
        content: Text(
          'Are you sure you want to delete this beacon?',
          style: TextStyle(fontSize: 18, color: kBlack),
        ),
        actions: <Widget>[
          HikeButton(
            buttonHeight: 2.5.h,
            buttonWidth: 8.w,
            onTap: () => AutoRouter.of(context).maybePop(false),
            text: 'No',
          ),
          HikeButton(
            buttonHeight: 2.5.h,
            buttonWidth: 8.w,
            onTap: () => AutoRouter.of(context).maybePop(true),
            text: 'Yes',
          ),
        ],
      ),
    );
  }
}
