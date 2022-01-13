import 'package:beacon/utilities/constants.dart';
import 'package:flutter/material.dart';

class HikeButton extends StatelessWidget {
  final Function onTap;
  final String text;
  final double textSize;
  final Color textColor;
  final Color borderColor;
  final Color buttonColor;
  final double buttonWidth;
  final double buttonHeight;
  HikeButton(
      {this.onTap,
      this.borderColor = Colors.white,
      this.buttonColor = kYellow,
      this.text,
      this.textColor = Colors.white,
      this.buttonWidth = optbwidth,
      this.buttonHeight = optbheight,
      this.textSize = 18});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: buttonColor,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(50.0),
            side: BorderSide(color: borderColor)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: buttonWidth, vertical: buttonHeight),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: textSize),
        ),
      ),
      onPressed: onTap,
    );
  }
}
