class Validator {
  static String validateName(String name) {
    if (name.isEmpty) {
      return "Name must not be left blank";
    }
    return null;
  }

  static String validateEmail(String email) {
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

  static String validatePassword(String password) {
    // If password is empty return.
    if (password.isEmpty) {
      return "Password must not be left blank";
    }
    // const String pattern = r'^(?=.*?[0-9])(?=.*?[!@#\$&*%^~.]).{8,}$';
    // final RegExp regExp = RegExp(pattern);

    //Regex for no spaces allowed
    const String noSpaces = r'^\S+$';
    final RegExp noSpaceRegex = RegExp(noSpaces);

    if (password.length < 8) {
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

  static String validateBeaconTitle(String title) {
    if (title.isEmpty) {
      return "Title must not be left blank";
    }
    return null;
  }

  static String validatePasskey(String passkey) {
    if (passkey.isEmpty) {
      return "Passkey must not be left blank";
    }
    const String pattern = r'[A-Z]+';
    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(passkey) || passkey.length != 6) {
      return "Invalid passkey";
    }
    return null;
  }

  static String validateDuration(String duration) {
    if (duration.startsWith("0:00:00.")) {
      return "Duration cannot be $duration";
    }
    return null;
  }

  static String validateStartingTime(String startTime) {
    print(startTime);
    if (startTime == null) {
      return "Enter the valid Time";
    }
    return null;
  }
}
