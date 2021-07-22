import 'package:beacon/locator.dart';
import 'package:beacon/services/validators.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:beacon/components/hike_button.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:beacon/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';

class CreateJoinBeaconDialog {
  static Future createHikeDialog(BuildContext context, HomeViewModel model) {
    model.resultingDuration = Duration(minutes: 30);
    model.durationController = new TextEditingController();
    return showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Form(
                key: model.formKeyCreate,
                child: Container(
                  height: 325,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextFormField(
                              validator: (value) =>
                                  Validator.validateBeaconTitle(value),
                              onChanged: (name) {
                                model.title = name;
                              },
                              decoration: InputDecoration(
                                  hintText: 'Title Here',
                                  labelStyle:
                                      TextStyle(fontSize: 18, color: kBlack),
                                  labelText: 'Title',
                                  alignLabelWithHint: true,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none),
                            ),
                          ),
                          color: kLightBlue,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: InkWell(
                              onTap: () async {
                                model.resultingDuration =
                                    await showDurationPicker(
                                  context: context,
                                  initialTime: model.resultingDuration,
                                );
                                model.durationController.text = model
                                    .resultingDuration
                                    .toString()
                                    .substring(0, 8);
                              },
                              child: TextFormField(
                                enabled: false,
                                controller: model.durationController,
                                onChanged: (value) {
                                  model.durationController.text = model
                                      .resultingDuration
                                      .toString()
                                      .substring(0, 8);
                                },
                                validator: (value) {
                                  if (value.startsWith("0:00:00"))
                                    return "Enter valid duration";
                                  return null;
                                },
                                decoration: InputDecoration(
                                    alignLabelWithHint: true,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelText: 'Duration',
                                    labelStyle:
                                        TextStyle(fontSize: 18, color: kBlack),
                                    hintText:
                                        'How long should beacon last for?',
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none),
                              ),
                            ),
                          ),
                          color: kLightBlue,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Flexible(
                          flex: 2,
                          child: HikeButton(
                              buttonWidth: 20,
                              buttonHeight: 20,
                              text: 'Create',
                              textColor: Colors.white,
                              buttonColor: kYellow,
                              onTap: () {
                                // navigationService.pop();
                                model.createHikeRoom();
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  static Future joinBeaconDialog(BuildContext context, HomeViewModel model) {
    return showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Form(
                key: model.formKeyJoin,
                child: Container(
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextFormField(
                              validator: (value) =>
                                  Validator.validatePasskey(value),
                              onChanged: (key) {
                                model.enteredPasskey = key;
                              },
                              decoration: InputDecoration(
                                hintText: 'Passkey Here',
                                hintStyle:
                                    TextStyle(fontSize: 20, color: kBlack),
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
                                navigationService.pop();
                                model.joinHikeRoom();
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
