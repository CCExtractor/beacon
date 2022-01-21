import 'package:beacon/components/hike_button.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DialogBoxes {
  static AlertDialog showExitDialog(
      BuildContext context, bool isLeader, int X, bool isBeaconExpired) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Text(
        'This will terminate the hike, Confirm?',
        style: TextStyle(fontSize: 25, color: kYellow),
      ),
      content: Text(
        isBeaconExpired
            ? 'Are you sure you want to exit?'
            : isLeader && (X - 1 > 0)
                ? 'There are ${X - 1} followers and you are carrying the beacon. Do you want to terminate the hike?'
                : 'Are you sure you want to terminate the hike?',
        style: TextStyle(fontSize: 16, color: kBlack),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: <Widget>[
        HikeButton(
          buttonHeight: 2.5.h,
          buttonWidth: 8.w,
          onTap: () => Navigator.of(context).pop(false),
          text: 'No',
          textSize: 18.0,
        ),
        HikeButton(
          buttonHeight: 2.5.h,
          buttonWidth: 8.w,
          onTap: () {
            navigationService.removeAllAndPush('/main', '/');
          },
          text: 'Yes',
          textSize: 18.0,
        ),
      ],
    );
  }

  static Future changeDurationDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          height: 500,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Column(
              children: <Widget>[
                Flexible(
                  child: Container(
                    color: kLightBlue,
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Change Beacon Duration',
                          style: TextStyle(color: kYellow, fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Flexible(
                  child: HikeButton(
                      buttonWidth: optbwidth,
                      text: 'Done',
                      textSize: 18.0,
                      textColor: Colors.white,
                      buttonColor: kYellow,
                      onTap: () {
                        // DateTime newTime =
                        // DateTime.now().add(newDuration);
                        // update time
                        Navigator.pop(context);
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
