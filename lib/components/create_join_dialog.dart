import 'package:beacon/components/duration_picker.dart';
import 'package:beacon/components/hike_button.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:flutter/material.dart';

class CreateJoinBeaconDialog {
  static Future createHikeDialog(BuildContext context) {
    String username = 'Anonymous';
    String duration = '00:00:00';
    DateTime selectedTime = DateTime.now().subtract(Duration(hours: 1));
    Duration _duration = Duration(hours: 0, minutes: 0);
    TextEditingController _durationController = new TextEditingController();

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
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextFormField(
                            onChanged: (name) {
                              username = name;
                            },
                            decoration: InputDecoration(
                              hintText: 'Name Here',
                              hintStyle: TextStyle(fontSize: 20, color: kBlack),
                              labelText: 'Username',
                              labelStyle:
                                  TextStyle(fontSize: 14, color: kYellow),
                            ),
                          ),
                        ),
                        color: kLightBlue,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Flexible(
                        flex: 3,
                        child: Container(
                          color: kLightBlue,
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Select Beacon Duration',
                                style: TextStyle(color: kYellow, fontSize: 12),
                              ),
                              Expanded(
                                flex: 5,
                                // Use it from the context of a stateful widget, passing in
                                // and saving the duration as a state variable.
                                child: InkWell(
                                  onTap: () {
                                    _durationController.text =
                                        showPicker(context);
                                  },
                                  child: Container(
                                    // width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Color(0xff2a2549),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 15),
                                      child: TextFormField(
                                        controller: _durationController,
                                        // onSaved: (value) {
                                        //   duration = value;
                                        // },
                                        enabled: false,
                                        style: TextStyle(color: Colors.white),
                                        cursorColor: Colors.white,
                                        decoration: InputDecoration(
                                            alignLabelWithHint: true,
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            labelText: 'Duration',
                                            labelStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                            hintText: 'Select beacon duration',
                                            hintStyle: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Flexible(
                        flex: 2,
                        child: HikeButton(
                            buttonWidth: 48,
                            text: 'Create',
                            textColor: Colors.white,
                            buttonColor: kYellow,
                            onTap: () {
                              Navigator.pop(context);
                              selectedTime = DateTime.now().add(_duration);
                              // TODO : create Beacon
                              // createHikeRoom();
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  static Future joinBeaconDialog(BuildContext context) {
    String enteredPasskey = '';
    return showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Container(
                height: 250,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextFormField(
                            onChanged: (key) {
                              enteredPasskey = key;
                            },
                            decoration: InputDecoration(
                              hintText: 'Passkey Here',
                              hintStyle: TextStyle(fontSize: 20, color: kBlack),
                              labelText: 'Passkey',
                              labelStyle:
                                  TextStyle(fontSize: 14, color: kYellow),
                            ),
                          ),
                        ),
                        color: kLightBlue,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Flexible(
                        child: HikeButton(
                            buttonWidth: 48,
                            text: 'Validate',
                            textColor: Colors.white,
                            buttonColor: kYellow,
                            onTap: () {
                              Navigator.pop(context);
                              // TODO: validate pass key
                              // validatePasskey(enteredPasskey);
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
