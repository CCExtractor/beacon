import 'package:auto_route/annotations.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

@RoutePage()
class AdvancedOptionsScreen extends StatelessWidget {
  String title;
  TextEditingController durationController;

  // Chang
  AdvancedOptionsScreen(
      {super.key, required this.title, required this.durationController});

  @override
  Widget build(BuildContext context) {
    DateTime? startDate = DateTime.now();
    TimeOfDay? startTime = TimeOfDay(
        hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute + 1);
    Duration? duration = Duration(minutes: 5);
    return Scaffold(
      body: Form(
        child: Container(
          height: 12.h,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () async {
                duration = await showDurationPicker(
                  context: context,
                  initialTime: duration ?? Duration(minutes: 5),
                );
                if (duration == null) return;
                if (duration!.inHours != 0 && duration!.inMinutes != 0) {
                  durationController.text =
                      '${duration!.inHours.toString()} hour ${(duration!.inMinutes % 60)} minutes';
                } else if (duration!.inMinutes != 0) {
                  durationController.text =
                      '${duration!.inMinutes.toString()} minutes';
                }
              },
              child: TextFormField(
                enabled: false,
                controller: durationController,
                decoration: InputDecoration(
                    fillColor: Colors.grey[200],
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    border: InputBorder.none,
                    alignLabelWithHint: true,
                    errorStyle: TextStyle(color: Colors.red[800]),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Duration',
                    labelStyle: TextStyle(
                        fontSize: 16, color: Theme.of(context).primaryColor),
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    hintText: 'Enter duration of hike',
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
