import 'package:beacon/components/hike_button.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:flutter/material.dart';

class DialogBoxes {
  static AlertDialog showExitDialog(
      BuildContext context, bool isLeader, int X) {
    return AlertDialog(
      title: Text(
        'This will terminate the hike, Confirm?',
        style: TextStyle(fontSize: 25, color: kYellow),
      ),
      content: Text(
        isLeader && (X - 1 > 0)
            ? 'There are ${X - 1} followers and you are carrying the beacon. Do you want to terminate the hike?'
            : 'Are you sure you want to terminate the hike?',
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
          onTap: () {
            navigationService.removeAllAndPush('/main', '/');
          },
          text: 'Yes',
        ),
      ],
    );
  }

  static Future changeDurationDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Container(
                height: 500,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          color: kLightBlue,
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Change Beacon Duration',
                                style: TextStyle(color: kYellow, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Flexible(
                        child: HikeButton(
                            buttonWidth: 48,
                            text: 'Done',
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
            ));
  }
}
