import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

String showPicker(BuildContext context) {
  String duration;
  Duration _duration = Duration(hours: 0, minutes: 0);
  Picker(
    adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
      const NumberPickerColumn(begin: 0, end: 999),
      const NumberPickerColumn(begin: 0, end: 999),
      const NumberPickerColumn(begin: 0, end: 60, jump: 15),
    ]),
    builderHeader: (BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Days',
            style: TextStyle(color: Colors.white, fontSize: 15.0),
          ),
          Text(
            'Hours',
            style: TextStyle(color: Colors.white, fontSize: 15.0),
          ),
          Text(
            'Minutes',
            style: TextStyle(color: Colors.white, fontSize: 15.0),
          ),
        ],
      );
    },
    confirmText: 'OK',
    backgroundColor: Color(0xff161427),
    containerColor: Color(0xff161427),
    headerColor: Color(0xff161427),
    cancelTextStyle:
        TextStyle(inherit: false, color: Colors.redAccent[700], fontSize: 20),
    confirmTextStyle:
        TextStyle(inherit: false, color: Colors.white, fontSize: 20),
    title: Text(
      'Select Duration',
      style: TextStyle(color: Colors.white),
    ),
    selectedTextStyle: TextStyle(color: Colors.white, fontSize: 25),
    textStyle: TextStyle(color: Colors.white, fontSize: 20),
    onConfirm: (Picker picker, List<int> value) {
      // You get your duration here
      _duration = Duration(
          days: picker.getSelectedValues()[0],
          hours: picker.getSelectedValues()[1],
          minutes: picker.getSelectedValues()[2]);
      duration = picker.getSelectedValues()[1].toString() +
          ':' +
          picker.getSelectedValues()[2].toString() +
          ':' +
          '00';
      duration = picker.getSelectedValues()[0].toString() +
          ' days ' +
          picker.getSelectedValues()[1].toString() +
          ' hours ' +
          picker.getSelectedValues()[2].toString() +
          ' minutes';
      print('${duration}');
    },
  ).showDialog(context);
  return duration;
}
