import 'package:beacon/core/utils/constants.dart';
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
    return SizedBox(
      height: 65,
      child: TextFormField(
        validator: widget.validator,
        controller: widget.controller,
        focusNode: widget.focusNode,
        cursorColor: Colors.deepPurpleAccent.withAlpha(120),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            isDense: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.deepPurpleAccent)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.red)),
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
                      size: 18,
                    ),
                    padding: EdgeInsets.zero, // Remove padding from icon button
                  )
                : null),
        style:
            TextStyle(color: Colors.black, fontSize: 14), // Smaller text size
        obscureText: widget.showTrailing == false ? false : obscureText,

        onEditingComplete: () {
          if (widget.nextFocusNode != null) {
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
          } else {
            FocusScope.of(context).unfocus();
          }
        },
      ),
    );
  }
}
