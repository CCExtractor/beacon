import 'package:beacon/locator.dart';
import 'package:beacon/services/validators.dart';
import 'package:beacon/components/hike_button.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:beacon/view_model/home_view_model.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CreateJoinBeaconDialog {
  static Future createHikeDialog(BuildContext context, HomeViewModel model) {
    model.resultingDuration = Duration(minutes: 30);
    model.durationController = new TextEditingController();
    model.startsAtDate = new TextEditingController();
    model.startsAtTime = new TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: model.formKeyCreate,
            child: Container(
              height: 65.h,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 10.h,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextFormField(
                          style: TextStyle(fontSize: 22.0),
                          validator: (value) =>
                              Validator.validateBeaconTitle(value),
                          onChanged: (name) {
                            model.title = name;
                          },
                          decoration: InputDecoration(
                              hintText: 'Enter Title Here',
                              labelStyle: TextStyle(
                                  fontSize: labelsize, color: kYellow),
                              hintStyle: TextStyle(
                                  fontSize: hintsize, color: hintColor),
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
                      height: 2.h,
                    ),
                    Container(
                      height: 10.h,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () async {
                            model.startingdate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            model.startsAtDate.text =
                                model.startingdate.toString().substring(0, 10);
                          },
                          child: TextFormField(
                            enabled: false,
                            controller: model.startsAtDate,
                            onChanged: (value) {
                              model.startsAtDate.text = model.startingdate
                                  .toString()
                                  .substring(0, 10);
                            },
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              errorStyle: TextStyle(color: Colors.red[800]),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'Start Date',
                              labelStyle: TextStyle(
                                  fontSize: labelsize, color: kYellow),
                              hintStyle: TextStyle(
                                  fontSize: hintsize, color: hintColor),
                              hintText: 'Choose start date',
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      color: kLightBlue,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      height: 10.h,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () async {
                            model.startingTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            model.startsAtTime.text =
                                model.startingTime.toString().substring(10, 15);
                          },
                          child: TextFormField(
                            enabled: false,
                            controller: model.startsAtTime,
                            onChanged: (value) {
                              model.startsAtTime.text = model.startingTime
                                  .toString()
                                  .substring(10, 15);
                            },
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              errorStyle: TextStyle(color: Colors.red[800]),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'Start Time',
                              labelStyle: TextStyle(
                                  fontSize: labelsize, color: kYellow),
                              hintStyle: TextStyle(
                                  fontSize: hintsize, color: hintColor),
                              hintText: 'Choose start time',
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      color: kLightBlue,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      height: 10.h,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () async {
                            model.resultingDuration = await showDurationPicker(
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
                                Validator.validateDuration(value.toString()),
                            decoration: InputDecoration(
                                alignLabelWithHint: true,
                                errorStyle: TextStyle(color: Colors.red[800]),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: 'Duration',
                                labelStyle: TextStyle(
                                    fontSize: labelsize, color: kYellow),
                                hintStyle: TextStyle(
                                    fontSize: hintsize, color: hintColor),
                                hintText: 'How long should beacon last for?',
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none),
                          ),
                        ),
                      ),
                      color: kLightBlue,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Flexible(
                      flex: 2,
                      child: HikeButton(
                          buttonWidth: optbwidth,
                          buttonHeight: optbheight,
                          textSize: 18.0,
                          text: 'Create',
                          textColor: Colors.white,
                          buttonColor: kYellow,
                          onTap: () {
                            // navigationService.pop();
                            if (model.startingdate == null ||
                                model.startingTime == null) {
                              navigationService
                                  .showSnackBar("Enter date and time");
                              return;
                            }
                            model.startsAt = DateTime(
                              model.startingdate.year,
                              model.startingdate.month,
                              model.startingdate.day,
                              model.startingTime.hour,
                              model.startingTime.minute,
                            );
                            // localNotif.scheduleNotification();
                            if (model.startsAt.isBefore(DateTime.now())) {
                              navigationService.showSnackBar(
                                  "Enter a valid date and time!!");
                              return;
                            }
                            model.createHikeRoom();
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Future joinBeaconDialog(BuildContext context, HomeViewModel model) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Form(
          key: model.formKeyJoin,
          child: Container(
            height: 28.h,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        style: TextStyle(fontSize: 22.0),
                        validator: (value) => Validator.validatePasskey(value),
                        onChanged: (key) {
                          model.enteredPasskey = key;
                        },
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Enter Passkey Here',
                          hintStyle:
                              TextStyle(fontSize: hintsize, color: hintColor),
                          labelText: 'Passkey',
                          labelStyle:
                              TextStyle(fontSize: labelsize, color: kYellow),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    color: kLightBlue,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Flexible(
                    child: HikeButton(
                      buttonWidth: optbwidth,
                      buttonHeight: optbheight,
                      text: 'Validate',
                      textSize: 18.0,
                      textColor: Colors.white,
                      buttonColor: kYellow,
                      onTap: () {
                        navigationService.pop();
                        model.joinHikeRoom();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
