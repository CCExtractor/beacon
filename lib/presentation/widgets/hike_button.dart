import 'package:beacon/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class HikeButton extends StatelessWidget {
  final Function? onTap;
  final String? text;
  final double textSize;
  final Color textColor;
  final Color borderColor;
  final Color buttonColor;
  final double buttonWidth;
  final double buttonHeight;
  final Widget? widget;
  final bool? isDotted;
  final bool? isDisabled;
  HikeButton(
      {this.onTap,
      this.borderColor = Colors.white,
      this.buttonColor = kYellow,
      this.text,
      this.textColor = Colors.white,
      this.buttonWidth = 100,
      this.buttonHeight = 30,
      this.textSize = 18,
      this.widget,
      this.isDotted = false,
      this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: isDisabled! ? null : onTap as void Function()?,
      child: DottedBorder(
          strokeWidth: 1,
          color: isDisabled!
              ? Colors.grey
              : !isDotted!
                  ? Colors.transparent
                  : Colors.teal,
          borderType: BorderType.RRect,
          radius: Radius.circular(12),
          padding: EdgeInsets.all(0),
          child: Container(
            width: buttonWidth,
            height: buttonHeight,
            decoration: BoxDecoration(
              color: isDotted!
                  ? Colors.transparent
                  : isDisabled!
                      ? Colors.grey
                      : Colors.teal,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              widget ?? SizedBox(),
              SizedBox(
                width: widget == null ? 0 : 5,
              ),
              Text(
                text!,
                style: TextStyle(
                  color: isDotted!
                      ? Colors.teal
                      : isDisabled!
                          ? Colors.white
                          : Colors.black,
                ),
              ),
            ]),
          )),
    );
  }
}
