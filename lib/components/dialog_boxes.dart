import 'package:beacon/components/hike_button.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:beacon/view_model/hike_screen_model.dart';
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

  static Future<DateTime> changeDurationDialog(
    BuildContext context,
    HikeScreenViewModel model,
  ) {
    DateTime dateTime;
    TimeOfDay timeOfDay;
    var startsAtDate = TextEditingController();
    var startsAtTime = TextEditingController();
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
                          'Choose a date and time for the beacon to expire at.',
                          style: TextStyle(color: kYellow, fontSize: 14.0),
                        ),
                        Container(
                          height: 10.h,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: InkWell(
                              onTap: () async {
                                dateTime = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
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
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelText: 'End Date',
                                  labelStyle: TextStyle(
                                      fontSize: labelsize, color: kYellow),
                                  hintStyle: TextStyle(
                                      fontSize: hintsize, color: hintColor),
                                  hintText: 'Choose end date',
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
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelText: 'End Time',
                                  labelStyle: TextStyle(
                                      fontSize: labelsize, color: kYellow),
                                  hintStyle: TextStyle(
                                      fontSize: hintsize, color: hintColor),
                                  hintText: 'Choose End time',
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          color: kLightBlue,
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
                      onTap: () async {
                        if (dateTime == null || timeOfDay == null) {
                          navigationService.showSnackBar("Enter date and time");
                          return;
                        }
                        dateTime = DateTime(
                          dateTime.year,
                          dateTime.month,
                          dateTime.day,
                          timeOfDay.hour,
                          timeOfDay.minute,
                        );
                        // localNotif.scheduleNotification();
                        if (DateTime.fromMillisecondsSinceEpoch(
                                model.beacon.startsAt)
                            .isAfter(dateTime)) {
                          navigationService
                              .showSnackBar("Enter a valid date and time!!");
                          return;
                        }
                        // DateTime newTime =
                        // DateTime.now().add(newDuration);
                        // update time
                        await databaseFunctions.init();
                        final updatedBeacon =
                            await databaseFunctions.changeBeaconDuration(
                          model.beacon.id,
                          dateTime.millisecondsSinceEpoch,
                        );
                        if (updatedBeacon != null) {
                          model.updateBeaconDuration(
                              dateTime.millisecondsSinceEpoch);
                        }
                        Navigator.pop(context, dateTime);
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
