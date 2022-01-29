import 'package:flutter/material.dart';

class BlinkIcon extends StatefulWidget {
  @override
  _BlinkIconState createState() => _BlinkIconState();
}

class _BlinkIconState extends State<BlinkIcon> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> _colorAnimation;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _colorAnimation = ColorTween(
            begin: Color(0xFF30c295), end: Colors.transparent)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
      setState(() {});
    });
    _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Icon(
          Icons.circle,
          size: 10,
          color: _colorAnimation.value,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
