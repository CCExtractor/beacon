import 'package:beacon/locator.dart';
import 'package:beacon/services/validators.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:beacon/components/hike_button.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:beacon/view_model/home_view_model.dart';
import 'package:flutter/material.dart';

class CreateJoinBeaconDialog {
  static Future createHikeDialog(BuildContext context, HomeViewModel model) {
    return showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Form(
                key: model.formKeyCreate,
                child: Container(
                  height: 320,
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
                                hintStyle:
                                    TextStyle(fontSize: 18, color: kBlack),
                                labelText: 'Title',
                              ),
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
                              child: DateTimePicker(
                                type: DateTimePickerType.dateTimeSeparate,
                                dateMask: 'd MMM, yyyy',
                                initialValue: DateTime.now().toString(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                dateLabelText: 'Expiry Date',
                                timeLabelText: "Expiry Time",
                                onChanged: (val) {
                                  model.expiryAt = val;
                                },
                                validator: (val) {
                                  if (DateTime.parse(val)
                                      .isAfter(DateTime.now())) {
                                    return null;
                                  } else {
                                    return "Please select correct expiry Date Time";
                                  }
                                },
                                onSaved: (val) {
                                  model.expiryAt = val;
                                },
                              )),
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
                                navigationService.pop();
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
