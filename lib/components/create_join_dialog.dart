import 'package:beacon/locator.dart';
import 'package:beacon/models/landmarks/landmark.dart';
import 'package:beacon/services/validators.dart';
import 'package:beacon/components/hike_button.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:beacon/view_model/home_view_model.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
                                  initialTime: model.resultingDuration != null
                                      ? model.resultingDuration
                                      : Duration(minutes: 30),
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
                                validator: (value) =>
                                    Validator.validateDuration(
                                        value.toString()),
                                decoration: InputDecoration(
                                    alignLabelWithHint: true,
                                    errorStyle:
                                        TextStyle(color: Colors.red[800]),
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

  static Future<Landmark> addLandmarkDialog(
      BuildContext context, LatLng loc, String id) {
    String title;
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: 250,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Column(
              children: <Widget>[
                Container(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                      onChanged: (key) {
                        title = key;
                      },
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Add title for the landmark',
                        hintStyle: TextStyle(fontSize: 15, color: kBlack),
                        labelText: 'Title',
                        labelStyle: TextStyle(fontSize: 20, color: kYellow),
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
                      buttonWidth: 25,
                      text: 'Create Landmark',
                      textColor: Colors.white,
                      buttonColor: kYellow,
                      onTap: () async {
                        navigationService.pop();
                        await databaseFunctions.init();
                        await databaseFunctions
                            .createLandmark(title, loc, id)
                            .then((value) {
                          return value;
                        });
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
