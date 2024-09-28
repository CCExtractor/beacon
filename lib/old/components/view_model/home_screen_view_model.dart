import 'package:auto_route/auto_route.dart';
import 'package:beacon/old/components/enums/view_state.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/old/components/view_model/base_view_model.dart';
import 'package:beacon/router.dart';
import 'package:flutter/material.dart';

import '../models/group/group.dart';

class HomeViewModel extends BaseModel {
  final formKeyCreate = GlobalKey<FormState>();
  final formKeyJoin = GlobalKey<FormState>();
  AutovalidateMode validate = AutovalidateMode.onUserInteraction;
  String? title;
  bool isCreatingGroup = false;
  String? enteredGroupCode;

  createGroupRoom(BuildContext context) async {
    FocusScope.of(navigationService!.navigatorKey.currentContext!).unfocus();
    validate = AutovalidateMode.always;
    if (formKeyCreate.currentState!.validate()) {
      // navigationService!.pop();
      AutoRouter.of(context).maybePop();
      setState(ViewState.busy);
      validate = AutovalidateMode.disabled;
      databaseFunctions!.init();
      final Group? group = await databaseFunctions!.createGroup(
        title,
      );
      if (group != null) {
        // navigationService!.pushScreen('/groupScreen',
        //     arguments: GroupScreen(
        //       group,
        //     ));

        AutoRouter.of(context).pushNamed('/group');
      }
    } else {
      // navigationService!.showSnackBar('Something went wrong');
      setState(ViewState.idle);
    }
  }

  joinGroupRoom(BuildContext context) async {
    // FocusScope.of(navigationService!.navigatorKey.currentContext!).unfocus();
    validate = AutovalidateMode.always;
    if (formKeyJoin.currentState!.validate()) {
      setState(ViewState.busy);
      validate = AutovalidateMode.disabled;
      databaseFunctions!.init();
      final Group? group = await databaseFunctions!.joinGroup(enteredGroupCode);
      // setState(ViewState.idle);
      if (group != null) {
        // navigationService!.pushScreen('/groupScreen',
        //     arguments: GroupScreen(
        //       group,
        //     ));

        AutoRouter.of(context).pushNamed('/group');
      } else {
        //there was some error, go back to homescreen.
        setState(ViewState.idle);
      }
      //Snackbar is displayed by joinBeacon itself on any error or trying to join expired beacon.
    } else {
      // navigationService!.showSnackBar('Enter Valid Group Code');
    }
  }

  logout(BuildContext context) async {
    setState(ViewState.busy);
    await userConfig!.currentUser!.delete();
    await hiveDb!.beaconsBox.clear();
    // setState(ViewState.idle);
    await localNotif!.deleteNotification();
    // navigationService!.removeAllAndPush('/auth', '/');
    AutoRouter.of(context).pushAndPopUntil(
      AuthScreenRoute(),
      predicate: (route) {
        return true;
      },
    );
  }
}
