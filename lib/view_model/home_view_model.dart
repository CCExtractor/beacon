import 'package:beacon/enums/view_state.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/view_model/base_view_model.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends BaseModel {
  bool isCreatingHike = false;
  String title;
  String expiryAt;
  TextEditingController _titleController = new TextEditingController();

  createHikeRoom() async {
    setState(ViewState.busy);
    databaseFunctions.init();
    final Beacon createBeaconSuccess = await databaseFunctions.createBeacon(
        _titleController.text ?? "Event",
        DateTime.parse(expiryAt).millisecondsSinceEpoch.toInt());
    setState(ViewState.idle);
    if (createBeaconSuccess != null) {
      navigationService.pushScreen('/hikeScreen');
    } else {
      navigationService.showSnackBar('SomeThing went wrong');
    }
  }
}
