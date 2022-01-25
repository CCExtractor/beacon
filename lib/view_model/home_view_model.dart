import 'package:beacon/enums/view_state.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/view_model/base_view_model.dart';
import 'package:beacon/views/hike_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeViewModel extends BaseModel {
  final formKeyCreate = GlobalKey<FormState>();
  final formKeyJoin = GlobalKey<FormState>();
  Duration resultingDuration = Duration(minutes: 30);
  AutovalidateMode validate = AutovalidateMode.onUserInteraction;
  DateTime startsAt;
  DateTime startingdate;
  TimeOfDay startingTime;
  bool isCreatingHike = false;
  String title;
  bool hasStarted;
  //commenting out since its value isnt used anywhere.
  //TextEditingController _titleController = new TextEditingController();
  TextEditingController durationController = new TextEditingController();
  TextEditingController startsAtDate = new TextEditingController();
  TextEditingController startsAtTime = new TextEditingController();
  String enteredPasskey;

  createHikeRoom() async {
    FocusScope.of(navigationService.navigatorKey.currentContext).unfocus();
    validate = AutovalidateMode.always;
    if (formKeyCreate.currentState.validate()) {
      navigationService.pop();
      setState(ViewState.busy);
      validate = AutovalidateMode.disabled;
      databaseFunctions.init();
      final Beacon beacon = await databaseFunctions.createBeacon(
        title,
        startsAt.millisecondsSinceEpoch.toInt(),
        startsAt.add(resultingDuration).millisecondsSinceEpoch.toInt(),
      );
      // setState(ViewState.idle);
      if (beacon != null) {
        hasStarted = DateTime.now()
            .isAfter(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt));
        if (hasStarted) {
          navigationService.pushScreen('/hikeScreen',
              arguments: HikeScreen(
                beacon,
                isLeader: true,
              ));
        } else {
          localNotif.scheduleNotification(beacon);
          setState(ViewState.idle);
          navigationService.showSnackBar(
            'Beacon has not yet started! \nPlease come back at ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt)).toString()}',
          );
          return;
        }
      } else {
        // navigationService.showSnackBar('Something went wrong');
        setState(ViewState.idle);
      }
    }
  }

  joinHikeRoom() async {
    FocusScope.of(navigationService.navigatorKey.currentContext).unfocus();
    validate = AutovalidateMode.always;
    if (formKeyJoin.currentState.validate()) {
      setState(ViewState.busy);
      validate = AutovalidateMode.disabled;
      databaseFunctions.init();
      final Beacon beacon = await databaseFunctions.joinBeacon(enteredPasskey);
      // setState(ViewState.idle);
      if (beacon != null) {
        hasStarted = DateTime.now()
            .isAfter(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt));

        if (hasStarted) {
          navigationService.pushScreen('/hikeScreen',
              arguments: HikeScreen(beacon, isLeader: false));
        } else {
          localNotif.scheduleNotification(beacon);
          setState(ViewState.idle);
          navigationService.showSnackBar(
            'Beacon has not yet started! \nPlease come back at ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt)).toString()}',
          );
          return;
        }
      } else {
        //there was some error, go back to homescreen.
        setState(ViewState.idle);
      }
      //Snackbar is displayed by joinBeacon itself on any error or trying to join expired beacon.
    } else {
      navigationService.showSnackBar('Enter Valid Passkey');
    }
  }

  logout() async {
    setState(ViewState.busy);
    await userConfig.currentUser.delete();
    // setState(ViewState.idle);
    await localNotif.deleteNotification();
    navigationService.removeAllAndPush('/auth', '/');
  }
}
