import 'package:beacon/enums/view_state.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/view_model/base_view_model.dart';
import 'package:beacon/views/hike_screen.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends BaseModel {
  final formKeyCreate = GlobalKey<FormState>();
  final formKeyJoin = GlobalKey<FormState>();
  Duration resultingDuration = Duration(minutes: 30);
  AutovalidateMode validate = AutovalidateMode.onUserInteraction;
  bool isCreatingHike = false;
  String title;
  //commenting out since its value isnt used anywhere.
  //TextEditingController _titleController = new TextEditingController();
  TextEditingController durationController = new TextEditingController();
  String enteredPasskey = '';

  createHikeRoom() async {
    FocusScope.of(navigationService.navigatorKey.currentContext).unfocus();
    validate = AutovalidateMode.always;
    if (formKeyCreate.currentState.validate()) {
      navigationService.pop();
      setState(ViewState.busy);
      validate = AutovalidateMode.disabled;
      databaseFunctions.init();
      final Beacon beacon = await databaseFunctions.createBeacon(title,
          DateTime.now().add(resultingDuration).millisecondsSinceEpoch.toInt());
      // setState(ViewState.idle);
      if (beacon != null) {
        navigationService.pushScreen('/hikeScreen',
            arguments: HikeScreen(
              beacon,
              isLeader: true,
            ));
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
        navigationService.pushScreen('/hikeScreen',
            arguments: HikeScreen(beacon, isLeader: false));
      } else {
        navigationService.showSnackBar('SomeThing went wrong');
      }
    } else {
      navigationService.showSnackBar('Enter valid passkey');
    }
  }

  logout() async {
    setState(ViewState.busy);
    await userConfig.currentUser.delete();
    // setState(ViewState.idle);
    navigationService.removeAllAndPush('/auth', '/');
  }
}
