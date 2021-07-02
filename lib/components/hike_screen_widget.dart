import 'package:beacon/components/dialog_boxes.dart';
import 'package:beacon/components/hike_button.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:beacon/view_model/hike_screen_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class HikeScreenWidget {
  static copyPasskey(String passkey) {
    Clipboard.setData(ClipboardData(text: passkey));
    Fluttertoast.showToast(msg: 'PASSKEY: $passkey  COPIED');
  }

  static Widget shareButton(
      BuildContext context, String passkey, HikeScreenViewModel model) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) => Dialog(
                  child: Container(
                    height: 400,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                'Invite Friends',
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Flexible(
                            child: HikeButton(
                                textSize: 20,
                                text: 'Generate URL',
                                textColor: Colors.white,
                                buttonColor: kYellow,
                                onTap: () async {
                                  model.generateUrl(passkey);
                                  navigationService.pop();
                                }),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Flexible(
                            child: HikeButton(
                              textSize: 20,
                              text: 'Copy Passkey',
                              textColor: Colors.white,
                              buttonColor: kYellow,
                              onTap: copyPasskey(passkey),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ));
      },
      backgroundColor: kYellow,
      child: Icon(Icons.person_add),
    );
  }

  static Widget addMeButton(Beacon beacon) {
    return Container(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: HikeButton(
            buttonHeight: 25,
            buttonColor: kYellow,
            buttonWidth: 64,
            text: 'Add Me',
            onTap: () async {
              final bool userLoggedIn = await userConfig.userLoggedIn();
              if (!userLoggedIn) {
                navigationService.pushReplacementScreen('/auth');
                navigationService.showSnackBar("User must be authenticated");
              } else {
                // call join mutation using beacon.shortcode and pass beacon model to hike screen if successfully joined
                // else pop back to main screen displaying something went wrong
              }
            },
          ),
        ),
      ),
    );
  }
}
