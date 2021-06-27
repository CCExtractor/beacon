import 'package:beacon/locator.dart';
import 'package:beacon/view_model/base_view_model.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends BaseModel {
  bool isCreatingHike = false;
  String title;
  String expiryAt;
  DateTime selectedTime = DateTime.now().subtract(Duration(hours: 1));
  TextEditingController _titleController = new TextEditingController();

  createHikeRoom() async {
    databaseFunctions.init();
    final bool createBeaconSuccess = await databaseFunctions.createBeacon(
        _titleController.text ?? "Event", DateTime.parse(expiryAt));
    if (createBeaconSuccess) {
      print("beacon created");
      // navigationService.pushScreen('/hike_screen');
    } else {
      navigationService.showSnackBar('SomeThing went wrong');
    }
  }
}
