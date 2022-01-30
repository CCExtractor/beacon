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
    bool isSmallSized = MediaQuery.of(context).size.height < 800;
    model.resultingDuration = Duration(minutes: 30);
    model.durationController = new TextEditingController();
    model.startsAtDate = new TextEditingController();
    model.startsAtTime = new TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: model.formKeyCreate,
              child: Container(
                height: isSmallSized ? 75.h : 65.h,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: isSmallSized ? 14.h : 12.h,
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
                                border: InputBorder.none,
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
                        height: isSmallSized ? 12.h : 10.h,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              model.startingdate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                                builder: (context, child) => Theme(
                                    data: ThemeData().copyWith(
                                      textTheme: Theme.of(context).textTheme,
                                      colorScheme: ColorScheme.light(
                                        primary: kBlue,
                                        onPrimary: Colors.white,
                                        surface: kBlue,
                                      ),
                                    ),
                                    child: child),
                              );
                              model.startsAtDate.text = model.startingdate
                                  .toString()
                                  .substring(0, 10);
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
                                  border: InputBorder.none,
                                  hintText: 'Choose Start Date',
                                  labelStyle: TextStyle(
                                      fontSize: labelsize, color: kYellow),
                                  hintStyle: TextStyle(
                                      fontSize: hintsize, color: hintColor),
                                  labelText: 'Start Date',
                                  alignLabelWithHint: true,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
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
                      Container(
                        height: isSmallSized ? 12.h : 10.h,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              model.startingTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData(
                                      textTheme: Theme.of(context).textTheme,
                                      timePickerTheme: TimePickerThemeData(
                                        dialHandColor: kBlue,
                                        dayPeriodTextColor: kBlue,
                                        hourMinuteTextColor: kBlue,
                                        helpTextStyle: TextStyle(
                                          fontFamily: 'FuturaBold',
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        hourMinuteTextStyle: TextStyle(
                                          fontFamily: 'FuturaBold',
                                          fontSize: 40.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        dayPeriodTextStyle: TextStyle(
                                          fontFamily: 'FuturaBold',
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    // This will change to light theme.
                                    child: child,
                                  );
                                },
                              );
                              model.startsAtTime.text = model.startingTime
                                  .toString()
                                  .substring(10, 15);
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
                                border: InputBorder.none,
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
                        height: isSmallSized ? 14.h : 12.h,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              model.resultingDuration =
                                  await showDurationPicker(
                                context: context,
                                initialTime: model.resultingDuration != null
                                    ? model.resultingDuration
                                    : Duration(minutes: 30),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
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
                                  border: InputBorder.none,
                                  alignLabelWithHint: true,
                                  errorStyle: TextStyle(color: Colors.red[800]),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelText: 'Duration',
                                  labelStyle: TextStyle(
                                      fontSize: labelsize, color: kYellow),
                                  hintStyle: TextStyle(
                                      fontSize: hintsize, color: hintColor),
                                  hintText: 'Enter duration of hike',
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
                            text: 'Create',
                            textSize: 18.0,
                            textColor: Colors.white,
                            buttonColor: kYellow,
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
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
      ),
    );
  }

  static Future joinBeaconDialog(BuildContext context, HomeViewModel model) {
    bool isSmallSized = MediaQuery.of(context).size.height < 800;
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Form(
          key: model.formKeyJoin,
          child: Container(
            height: isSmallSized ? 30.h : 25.h,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Column(
                children: <Widget>[
                  Container(
                    height: isSmallSized ? 14.h : 12.h,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        style: TextStyle(fontSize: 22.0),
                        validator: (value) => Validator.validatePasskey(value),
                        onChanged: (key) {
                          model.enteredPasskey = key.toUpperCase();
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
                      text: 'Validate',
                      textSize: 18.0,
                      textColor: Colors.white,
                      buttonColor: kYellow,
                      onTap: () {
                        // navigationService.pop();
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
