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

  const BeaconCard({
    required this.beacon,
    required this.onDelete,
    required this.onReschedule,
    Key? key,
  }) : super(key: key);

  @override
  State<BeaconCard> createState() => _BeaconCardState();
}

class _BeaconCardState extends State<BeaconCard> {
  late bool hasStarted;
  late bool hasEnded;
  late bool willStart;
  Timer? _rebuildTimer;

  late DateTime startAt;
  late DateTime expiresAt;

  @override
  void initState() {
    final now = DateTime.now();
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

    final now = DateTime.now();
    late int seconds;

    if (willStart) {
      seconds = startAt.difference(now).inSeconds;
    } else {
      seconds = expiresAt.difference(now).inSeconds;
    }

    _rebuildTimer?.cancel();
    _rebuildTimer = Timer(Duration(seconds: seconds + 1), () {
      setState(() {
        final now = DateTime.now();
        hasStarted = now.isAfter(startAt);
        hasEnded = now.isAfter(expiresAt);
        willStart = now.isBefore(startAt);
      });

      // Show notification if the beacon becomes active
      Future.delayed(Duration(seconds: 1), () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 5),
            content: Text(
              '${widget.beacon.title} is now active!\nYou can join the hike',
              style: const TextStyle(color: Colors.black),
            ),
            backgroundColor: kLightBlue.withAlpha(200),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            behavior: SnackBarBehavior.floating,
            elevation: 5,
            action: SnackBarAction(
              label: 'Click to Join',
              textColor: kBlue,
              onPressed: () {
                appRouter.push(HikeScreenRoute(
                  beacon: widget.beacon,
                  isLeader: widget.beacon.id == localApi.userModel.id,
                ));
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

  String formatDate(int timestamp) {
    return DateFormat("hh:mm a, d/M/y")
        .format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  @override
  Widget build(BuildContext context) {
    final beacon = widget.beacon;

    return InkWell(
      onTap: () {
        locator<GroupCubit>().joinBeacon(beacon, hasEnded, hasStarted);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 6.0,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.hiking, color: Colors.black),
                Gap(8),
                Expanded(
                  child: Text(
                    '${beacon.title?.toUpperCase()} by ${beacon.leader?.name}',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                if (hasStarted && !hasEnded)
                  BlinkIcon()
                else if (willStart)
                  Icon(Icons.circle, color: kYellow, size: 10),
              ],
            ),
            Gap(8),

            /// Status Row
            if (hasStarted && !hasEnded)
              RichText(
                text: TextSpan(
                  style: Style.commonTextStyle,
                  children: [
                    const TextSpan(text: 'Hike is '),
                    TextSpan(
                      text: 'Active',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              )
            else if (willStart)
              Row(
                children: [
                  RichText(
                    text: TextSpan(
                      style: Style.commonTextStyle,
                      children: [
                        const TextSpan(text: 'Hike '),
                        TextSpan(
                          text: 'Starts ',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text: 'in ',
                          style: TextStyle(
                            color: Color(0xffb6b2df),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(4),
                  CountdownTimerPage(
                    dateTime: startAt,
                    name: beacon.title ?? '',
                    beacon: beacon,
                  )
                ],
              )
            else
              RichText(
                text: TextSpan(
                  style: Style.commonTextStyle,
                  children: [
                    const TextSpan(text: 'Hike '),
                    TextSpan(
                      text: 'is Ended',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            Gap(8),

            /// Passkey Row
            Row(
              children: [
                Text(
                  'Passkey: ${beacon.shortcode}',
                  style: Style.commonTextStyle,
                ),
                Gap(10),
                InkWell(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: beacon.shortcode ?? ''),
                    );
                    utils.showSnackBar('Shortcode copied!', context);
                  },
                  child: Icon(Icons.copy, color: Colors.black, size: 16.sp),
                ),
              ],
            ),
            Gap(8),

            /// Start and expiry
            if (beacon.startsAt != null)
              Text(
                willStart
                    ? 'Starting At: ${formatDate(beacon.startsAt!)}'
                    : 'Started At: ${formatDate(beacon.startsAt!)}',
                style: Style.commonTextStyle,
              ),
            if (beacon.expiresAt != null)
              Text(
                willStart
                    ? 'Expiring At: ${formatDate(beacon.expiresAt!)}'
                    : 'Expires At: ${formatDate(beacon.expiresAt!)}',
                style: Style.commonTextStyle,
              ),
            Gap(12),

            /// Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    visualDensity: VisualDensity(horizontal: -1, vertical: -2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: widget.onDelete,
                  child: const Text("Delete"),
                ),
                Gap(8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    visualDensity: VisualDensity(horizontal: -1, vertical: -2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: widget.onReschedule,
                  child: const Text("Reschedule"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
