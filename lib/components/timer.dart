import 'package:beacon/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';

class CountdownTimerPage extends StatefulWidget {
  final String name;
  final DateTime dateTime;
  CountdownTimerPage({Key key, @required this.dateTime, @required this.name})
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
    navigationService
        .showSnackBar('${widget.name} is now active! You can join the hike');
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
