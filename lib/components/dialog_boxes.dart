import 'package:beacon/components/hike_button.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogBoxes {
  static AlertDialog showExitDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Exit App',
        style: TextStyle(fontSize: 25, color: kYellow),
      ),
      content: Text(
        'Are you sure you wanna stop sending and receiving location?',
        style: TextStyle(fontSize: 16, color: kBlack),
      ),
      actions: <Widget>[
        HikeButton(
          buttonHeight: 20,
          buttonWidth: 40,
          onTap: () => Navigator.of(context).pop(false),
          text: 'No',
        ),
        HikeButton(
          buttonHeight: 20,
          buttonWidth: 40,
          onTap: () =>
              SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
          text: 'Yes',
        ),
      ],
    );
  }
}
