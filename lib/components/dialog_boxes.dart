import 'package:beacon/components/hike_button.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:beacon/view_model/hike_screen_model.dart';
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
                              Expanded(
                                flex: 8,
                                // Use it from the context of a stateful widget, passing in
                                // and saving the duration as a state variable.
                                // child: DurationPicker(
                                //   height: 100,
                                //   width: double.infinity,
                                //   duration: _newDuration,
                                //   onChange: (val) {
                                //     setState(() {
                                //       _newDuration = val;
                                //       print(_newDuration);
                                //     });
                                //   },
                                //   snapToMins: 5.0,
                                // )
                              )
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
