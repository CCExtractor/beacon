import 'package:beacon/components/hike_button.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:beacon/utilities/handle_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HikeScreenWidget {
  static copyPasskey(String passkey) {
    Clipboard.setData(ClipboardData(text: passkey));
    Fluttertoast.showToast(msg: 'PASSKEY: $passkey  COPIED');
  }

  static Widget shareButton(BuildContext context, String passkey) {
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
                                  DynamicLinks.generateUrl();
                                  Navigator.pop(context);
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
}
