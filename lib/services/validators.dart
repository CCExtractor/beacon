import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Validator {
  static String validateName(String value) {
    if (value.isEmpty) {
      return 'Name must not be left blank.';
    }
    return null;
  }

  static String validateEmail(
    String email,
  ) {
    // If email is empty return.
    if (email.isEmpty) {
      return "Email must not be left blank";
    }
    const String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    final RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(email)) {
      return 'Please enter a valid Email Address';
    }
    return null;
  }

  static String validatePassword(
    String password,
  ) {
    // If password is empty return.
    if (password.isEmpty) {
      return "Password must not be left blank";
    }
    const String pattern =
        r'^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#\$&*%^~.]).{8,}$';
    final RegExp regExp = RegExp(pattern);

    //Regex for no spaces allowed
    const String noSpaces = r'^\S+$';
    final RegExp noSpaceRegex = RegExp(noSpaces);

    if (!regExp.hasMatch(password)) {
      return "Invalid Password";
    }
    if (!noSpaceRegex.hasMatch(password)) {
      return "Password must not contain spaces";
    }

    return null;
  }
}
