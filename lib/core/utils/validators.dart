import 'package:flutter/material.dart';

class Validator {
  static String? validateName(String? name) {
    if (name != null && name.isEmpty) {
      return "Name must not be left blank";
    }
    return null;
  }

  static String? validateRadius(String? radius) {
    if (radius == null) {
      return 'Radius can\'t be blank';
    }
    try {
      double.parse(radius);

      return null;
    } catch (e) {
      return 'Radius should be number';
    }
  }

  static String? validateDate(String? date) {
    if (date == null || date.isEmpty || date == '') {
      return 'Date can\'t be empty';
    }

    DateTime parsedDate = DateTime.parse(date);
    DateTime now = DateTime.now();

    DateTime currentDate = DateTime(now.year, now.month, now.day);
    DateTime onlyDate =
        DateTime(parsedDate.year, parsedDate.month, parsedDate.day);

    if (onlyDate.isBefore(currentDate)) {
      return 'Please enter a valid date';
    }

    return null;
  }

  static String? validateStartTime(String? time, String date) {
    DateTime parsedDate = DateTime.parse(date);
    DateTime selectedDate =
        DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
    DateTime now = DateTime.now();
    DateTime currentDate = DateTime(now.year, now.month, now.day);

    if (selectedDate.isAfter(currentDate)) {
      return null;
    }

    if (time == null || time.isEmpty) {
      return 'Please chose a start time';
    }

    RegExp timeRegex = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9] (AM|PM)$');

    if (!timeRegex.hasMatch(time)) {
      return 'Invalid time format. Please enter time in hh:mm AM/PM format';
    }

    TimeOfDay enteredTime = _stringToTimeOfDay(time);

    TimeOfDay currentTime = TimeOfDay.now();

    int isValid = compareTimeOfDay(enteredTime, currentTime);

    if (isValid == -1) {
      return 'Please chose a valid time';
    }

    return null;
  }

  static int compareTimeOfDay(TimeOfDay time1, TimeOfDay time2) {
    if (time1.hour < time2.hour) {
      return -1;
    } else if (time1.hour > time2.hour) {
      return 1;
    } else {
      // If hours are the same, compare minutes
      if (time1.minute < time2.minute) {
        return -1;
      } else if (time1.minute > time2.minute) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  static TimeOfDay _stringToTimeOfDay(String time) {
    final numbers = time.split(' ');
    final format = numbers[0].split(":");
    final hour = int.parse(format[0]);
    final minute = int.parse(format[1]);

    return TimeOfDay(hour: hour, minute: minute);
  }

  static String? validateEmail(String? email) {
    // If email is empty return.
    if (email != null && email.isEmpty) {
      return "Email must not be left blank";
    }
    const String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    final RegExp regex = RegExp(pattern);
    if (email != null && !regex.hasMatch(email)) {
      return 'Please enter a valid Email Address';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    // If password is empty return.
    if (password != null && password.isEmpty) {
      return "Password must not be left blank";
    }
    // const String pattern = r'^(?=.*?[0-9])(?=.*?[!@#\$&*%^~.]).{8,}$';
    // final RegExp regExp = RegExp(pattern);

    //Regex for no spaces allowed
    const String noSpaces = r'^\S+$';
    final RegExp noSpaceRegex = RegExp(noSpaces);

    if (password!.length < 8) {
      return "Must be of atleast 8 characters";
    }
    // if (!regExp.hasMatch(password)) {
    //   return "At least 1 number and symbol required";
    // }
    if (!noSpaceRegex.hasMatch(password)) {
      return "Password must not contain spaces";
    }
    return null;
  }

  static String? validateBeaconTitle(String? title) {
    if (title != null && title.isEmpty) {
      return "Title must not be left blank";
    }
    return null;
  }

  static String? validatePasskey(String? passkey) {
    if (passkey != null && passkey.isEmpty) {
      return "Passkey must not be left blank";
    }
    const String pattern = r'[A-Z]+';
    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(passkey!) || passkey.length != 6) {
      return "Invalid passkey";
    }
    return null;
  }

  static String? validateDuration(String? duration) {
    if (duration == null || duration.isEmpty || duration == '') {
      return "Please enter duration";
    }
    return null;
  }
}
