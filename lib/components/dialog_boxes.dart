import 'package:beacon/components/hike_button.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DialogBoxes {
  static AlertDialog showExitDialog(
      BuildContext context, bool isLeader, int X, bool isBeaconExpired) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Text(
        'This will terminate the hike, Confirm?',
        style: TextStyle(fontSize: 25, color: kYellow),
      ),
      content: Text(
        isBeaconExpired
            ? 'Are you sure you want to exit?'
            : isLeader && (X - 1 > 0)
                ? 'There are ${X - 1} followers and you are carrying the beacon. Do you want to terminate the hike?'
                : 'Are you sure you want to terminate the hike?',
        style: TextStyle(fontSize: 16, color: kBlack),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: <Widget>[
        HikeButton(
          buttonHeight: 2.5.h,
          buttonWidth: 8.w,
          onTap: () => Navigator.of(context).pop(false),
          text: 'No',
          textSize: 18.0,
        ),
        HikeButton(
          buttonHeight: 2.5.h,
          buttonWidth: 8.w,
          onTap: () {
            navigationService.removeAllAndPush('/main', '/');
          },
          text: 'Yes',
          textSize: 18.0,
        ),
      ],
    );
  }

  static Future changeDurationDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          height: 500,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Column(
              children: <Widget>[
                Flexible(
                  child: Container(
                    color: kLightBlue,
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Change Beacon Duration',
                          style: TextStyle(color: kYellow, fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Flexible(
                  child: HikeButton(
                      buttonWidth: optbwidth,
                      text: 'Done',
                      textSize: 18.0,
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
      ),
    );
  }

  static Future<DateTime> setReminderDialogueBox(
    BuildContext context,
    Beacon beacon,
  ) async {
    DateTime dateTime;
    TimeOfDay timeOfDay;
    var startsAtDate = TextEditingController();
    var startsAtTime = TextEditingController();
    var title = TextEditingController();
    var message = TextEditingController();
    return await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 2.h,
                  ),
                  Container(
                    child: Text(
                      'Set reminders for yourself!',
                      style: TextStyle(color: kYellow, fontSize: 13.0),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Container(
                    color: kLightBlue,
                    height: 10.h,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InkWell(
                        onTap: () async {
                          dateTime = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.fromMillisecondsSinceEpoch(
                                beacon.expiresAt),
                          );
                          startsAtDate.text =
                              dateTime.toString().substring(0, 10);
                        },
                        child: TextFormField(
                          enabled: false,
                          controller: startsAtDate,
                          onChanged: (value) {
                            startsAtDate.text =
                                dateTime.toString().substring(0, 10);
                          },
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            errorStyle: TextStyle(color: Colors.red[800]),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Date',
                            labelStyle:
                                TextStyle(fontSize: labelsize, color: kYellow),
                            hintStyle:
                                TextStyle(fontSize: 13, color: hintColor),
                            hintText: 'Choose a date to reminded at!',
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
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
                          timeOfDay = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          startsAtTime.text =
                              timeOfDay.toString().substring(10, 15);
                        },
                        child: TextFormField(
                          enabled: false,
                          controller: startsAtTime,
                          onChanged: (value) {
                            startsAtTime.text =
                                timeOfDay.toString().substring(10, 15);
                          },
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            errorStyle: TextStyle(color: Colors.red[800]),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Time',
                            labelStyle:
                                TextStyle(fontSize: labelsize, color: kYellow),
                            hintStyle:
                                TextStyle(fontSize: 13, color: hintColor),
                            hintText: 'Choose a time to be reminded at!',
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
                      child: TextFormField(
                        enabled: true,
                        controller: title,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          errorStyle: TextStyle(color: Colors.red[800]),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Title',
                          labelStyle:
                              TextStyle(fontSize: labelsize, color: kYellow),
                          hintStyle: TextStyle(fontSize: 13, color: hintColor),
                          hintText: 'A title for the reminder!',
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
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
                      child: TextFormField(
                        enabled: true,
                        controller: message,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          errorStyle: TextStyle(color: Colors.red[800]),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Message',
                          labelStyle:
                              TextStyle(fontSize: labelsize, color: kYellow),
                          hintStyle: TextStyle(fontSize: 13, color: hintColor),
                          hintText: 'A message for the reminder!',
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    color: kLightBlue,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  HikeButton(
                    buttonWidth: optbwidth,
                    text: 'Done',
                    textSize: 18.0,
                    textColor: Colors.white,
                    buttonColor: kYellow,
                    onTap: () {
                      if (dateTime == null || timeOfDay == null) {
                        navigationService.showSnackBar("Enter date and time");
                        return;
                      }
                      if (message.text.trim().isEmpty) {
                        navigationService.showSnackBar("Choose a message");
                        return;
                      }
                      if (title.text.trim().isEmpty) {
                        navigationService.showSnackBar("Choose a title");
                        return;
                      }
                      dateTime = DateTime(
                        dateTime.year,
                        dateTime.month,
                        dateTime.day,
                        timeOfDay.hour,
                        timeOfDay.minute,
                      );
                      if (DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt)
                          .isBefore(dateTime)) {
                        navigationService
                            .showSnackBar("Enter a valid date and time!!");
                        return;
                      }
                      localNotif.scheduleNotificationForBeacon(
                          beacon, dateTime, title.text, message.text);

                      Navigator.pop(context, dateTime);
                    },
                  ),
                  SizedBox(
                    height: 2.h,
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
