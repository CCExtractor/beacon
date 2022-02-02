import 'package:beacon/locator.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:beacon/views/hike_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';

class CountdownTimerPage extends StatefulWidget {
  final String name;
  final DateTime dateTime;
  final Beacon beacon;
  CountdownTimerPage(
      {Key key,
      @required this.dateTime,
      @required this.name,
      @required this.beacon})
      : super(key: key);
  @override
  _CountdownTimerPageState createState() => _CountdownTimerPageState();
}

class _CountdownTimerPageState extends State<CountdownTimerPage>
    with SingleTickerProviderStateMixin {
  CountdownTimerController controller;
  int endTime = 0;
  @override
  void initState() {
    super.initState();
    setState(() {});
    int timeDiff = widget.dateTime.difference(DateTime.now()).inSeconds;
    setState(() {
      endTime = DateTime.now().millisecondsSinceEpoch + 1000 * timeDiff;
    });
    controller =
        CountdownTimerController(endTime: endTime, onEnd: onEnd, vsync: this);
  }

  void onEnd() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: Text(
          '${widget.name} is now active! \nYou can join the hike',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: kLightBlue.withOpacity(0.8),
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
            bool isLeader =
                widget.beacon.leader.id == userConfig.currentUser.id;
            navigationService.pushScreen(
              '/hikeScreen',
              arguments: HikeScreen(widget.beacon, isLeader: isLeader),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CountdownTimer(
      controller: controller,
      widgetBuilder: (_, CurrentRemainingTime time) {
        return Text(
          '${time?.days ?? 0} : ${time?.hours ?? 0} : ${time?.min ?? 0} : ${time?.sec ?? 0}',
          style: TextStyle(
              color: const Color(0xffb6b2df),
              fontSize: 14.0,
              fontWeight: FontWeight.w400),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
