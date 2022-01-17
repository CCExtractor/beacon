import 'package:beacon/components/hike_button.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';

class HikeScreenWidget {
  static copyPasskey(String passkey) {
    Clipboard.setData(ClipboardData(text: passkey));
    Fluttertoast.showToast(msg: 'PASSKEY: $passkey  COPIED');
  }

  static generateUrl(String shortcode) async {
    Uri url = Uri.parse('https://beacon.aadibajpai.com/?shortcode=$shortcode');
    Share.share('To join beacon follow this link: $url');
  }

  static Widget shareButton(BuildContext context, String passkey) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    height: 35.h,
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
                            height: 3.h,
                          ),
                          Flexible(
                            child: HikeButton(
                                buttonHeight: optbheight,
                                buttonWidth: optbwidth,
                                textSize: 18,
                                text: 'Generate URL',
                                textColor: Colors.white,
                                buttonColor: kYellow,
                                onTap: () async {
                                  generateUrl(passkey);
                                  navigationService.pop();
                                }),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Flexible(
                            child: HikeButton(
                              buttonHeight: optbheight * 1,
                              buttonWidth: optbwidth,
                              textSize: 18,
                              text: 'Copy Passkey',
                              textColor: Colors.white,
                              buttonColor: kYellow,
                              onTap: () {
                                copyPasskey(passkey);
                                navigationService.pop();
                              },
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
