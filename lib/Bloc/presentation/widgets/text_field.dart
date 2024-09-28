import 'package:beacon/old/components/utilities/constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final IconData iconData;
  final String hintText;
  final bool showTrailing;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  CustomTextField(
      {super.key,
      required this.iconData,
      required this.hintText,
      required this.controller,
      this.showTrailing = false,
      this.validator,
      this.focusNode,
      this.nextFocusNode});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(
            widget.iconData,
            color: Colors.black,
            size: 24.0,
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(fontSize: hintsize - 2, color: hintColor),
          suffixIcon: widget.showTrailing == true
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black,
                  ))
              : null),
      style: TextStyle(color: Colors.black),
      obscureText: widget.showTrailing == false ? false : obscureText,
      onEditingComplete: () {
        if (widget.nextFocusNode != null) {
          FocusScope.of(context).requestFocus(widget.nextFocusNode);
        } else {
          FocusScope.of(context).unfocus();
        }
      },
    );
  }
}
