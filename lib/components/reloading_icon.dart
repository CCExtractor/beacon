import 'package:beacon/utilities/constants.dart';
import 'package:flutter/material.dart';

class ReloadIcon extends StatefulWidget {
  const ReloadIcon({Key key}) : super(key: key);

  @override
  State<ReloadIcon> createState() => _ReloadIconState();
}

class _ReloadIconState extends State<ReloadIcon> with TickerProviderStateMixin {
  AnimationController _animation;
  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
      upperBound: 1,
    )..repeat();
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animation..forward();
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 10.0).animate(_animation),
      child: Transform.rotate(
        angle: 0.5,
        child: Icon(
          Icons.refresh,
          color: kBlue,
          size: 30,
        ),
      ),
    );
  }
}
