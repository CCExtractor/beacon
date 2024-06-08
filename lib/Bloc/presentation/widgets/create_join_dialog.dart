import 'package:auto_route/auto_route.dart';
import 'package:beacon/Bloc/core/utils/validators.dart';
import 'package:beacon/Bloc/presentation/cubit/group_cubit.dart';
import 'package:beacon/Bloc/presentation/cubit/home_cubit.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/old/components/hike_button.dart';
import 'package:beacon/old/components/utilities/constants.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class CreateJoinGroupDialog {
  static GlobalKey<FormState> _groupKey = GlobalKey<FormState>();

  static final TextEditingController _groupNameController =
      TextEditingController();

  static Future createGroupDialog(
    BuildContext context,
  ) {
    bool isSmallSized = MediaQuery.of(context).size.height < 800;
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _groupKey,
            child: Container(
              height: isSmallSized ? 35.h : 25.h,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: isSmallSized ? 12.h : 10.h,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextFormField(
                          controller: _groupNameController,
                          style: TextStyle(fontSize: 22.0),
                          validator: (value) =>
                              Validator.validateBeaconTitle(value!),
                          onChanged: (name) {},
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
                    Flexible(
                      flex: 2,
                      child: HikeButton(
                          text: 'Create Group',
                          textSize: 18.0,
                          textColor: Colors.white,
                          buttonColor: kYellow,
                          onTap: () {
                            if (!_groupKey.currentState!.validate()) return;
                            AutoRouter.of(context).maybePop();
                            BlocProvider.of<HomeCubit>(context)
                                .createGroup(_groupNameController.text.trim());
                            _groupNameController.clear();
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static GlobalKey<FormState> _joinGroupKey = GlobalKey<FormState>();

  static final TextEditingController _joinGroupController =
      TextEditingController();

  static Future joinGroupDialog(BuildContext context) {
    bool isSmallSized = MediaQuery.of(context).size.height < 800;
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Form(
          key: _joinGroupKey,
          child: Container(
            height: isSmallSized ? 35.h : 25.h,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Column(
                children: [
                  Container(
                    height: isSmallSized ? 12.h : 10.h,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        controller: _joinGroupController,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        style: TextStyle(fontSize: 22.0),
                        validator: (value) => Validator.validatePasskey(value!),
                        onChanged: (value) {
                          _joinGroupController.text = value.toUpperCase();
                        },
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Enter Group Code Here',
                          hintStyle:
                              TextStyle(fontSize: hintsize, color: hintColor),
                          labelText: 'Code',
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
                      text: 'Join Group',
                      textSize: 18.0,
                      textColor: Colors.white,
                      buttonColor: kYellow,
                      onTap: () {
                        if (!_joinGroupKey.currentState!.validate()) return;
                        AutoRouter.of(context).maybePop();
                        BlocProvider.of<HomeCubit>(context)
                            .joinGroup(_joinGroupController.text.trim());
                        _joinGroupController.clear();
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

class CreateJoinBeaconDialog {
  static late String title;
  static DateTime? startDate = DateTime.now();
  static TimeOfDay? startTime =
      TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute + 1);
  static Duration? duration = Duration(minutes: 5);

  static GlobalKey<FormState> _createFormKey = GlobalKey<FormState>();

  static FocusNode _titleNode = FocusNode();
  static FocusNode _startDateNode = FocusNode();
  static FocusNode _startTimeNode = FocusNode();
  static FocusNode _durationNode = FocusNode();

  static TextEditingController _dateController = TextEditingController();
  static TextEditingController _startTimeController = TextEditingController();
  static TextEditingController _durationController = TextEditingController();

  static Future<void> createHikeDialog(
      BuildContext context, String? groupID, GroupCubit groupCubit) {
    bool isSmallSized = MediaQuery.of(context).size.height < 800;
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
              key: _createFormKey,
              child: Container(
                height: isSmallSized ? 75.h : 65.h,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Column(
                    children: [
                      Container(
                        height: isSmallSized ? 14.h : 12.h,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 22.0),
                            validator: (value) =>
                                Validator.validateBeaconTitle(value!),
                            onChanged: (name) {
                              title = name;
                            },
                            focusNode: _titleNode,
                            onEditingComplete: () {
                              _titleNode.unfocus();
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
                      SizedBox(height: 2.h),
                      // Start Date Field
                      Container(
                        height: isSmallSized ? 12.h : 10.h,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () async {
                              startDate = await showDatePicker(
                                context: context,
                                initialDate: startDate!,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                                builder: (context, child) => Theme(
                                    data: ThemeData().copyWith(
                                      textTheme: Theme.of(context).textTheme,
                                      colorScheme: ColorScheme.light(
                                        primary: kLightBlue,
                                        onPrimary: Colors.grey,
                                        surface: kBlue,
                                      ),
                                    ),
                                    child: child!),
                              );
                              _dateController.text =
                                  DateFormat('yyyy-MM-dd').format(startDate!);

                              _startDateNode.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_startTimeNode);
                            },
                            child: TextFormField(
                              controller: _dateController,
                              enabled: false,
                              focusNode: _startDateNode,
                              onEditingComplete: () {},
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
                      SizedBox(height: 2.h),
                      // Start Time Field
                      Container(
                        height: isSmallSized ? 12.h : 10.h,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () async {
                              startTime = await showTimePicker(
                                  context: context, initialTime: startTime!);

                              if (startTime != null) {
                                _startTimeController.text =
                                    '${startTime!.hour}:${startTime!.minute}';
                              }
                            },
                            child: TextFormField(
                              controller: _startTimeController,
                              enabled: false,
                              onEditingComplete: () {},
                              focusNode: _startTimeNode,
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
                      SizedBox(height: 2.h),
                      // Duration Field
                      Container(
                        height: isSmallSized ? 14.h : 12.h,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () async {
                              duration = await showDurationPicker(
                                context: context,
                                initialTime: duration!,
                              );
                              if (duration!.inHours != 0 &&
                                  duration!.inMinutes != 0) {
                                _durationController.text =
                                    '${duration!.inHours.toString()} hour ${(duration!.inMinutes % 60)} minutes';
                              } else if (duration!.inMinutes != 0) {
                                _durationController.text =
                                    '${duration!.inMinutes.toString()} minutes';
                              }
                              if (_durationController.text.isEmpty) {
                                _durationNode.unfocus();
                              }
                            },
                            child: TextFormField(
                              enabled: false,
                              focusNode: _durationNode,
                              controller: _durationController,
                              onEditingComplete: () {
                                _durationNode.unfocus();
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
                      SizedBox(height: 2.h),
                      Flexible(
                        flex: 2,
                        child: HikeButton(
                            text: 'Create',
                            textSize: 18.0,
                            textColor: Colors.white,
                            buttonColor: kYellow,
                            onTap: () async {
                              if (_createFormKey.currentState!.validate()) {
                                DateTime startsAt = DateTime(
                                    startDate!.year,
                                    startDate!.month,
                                    startDate!.day,
                                    startTime!.hour,
                                    startTime!.minute);

                                final startingTime =
                                    startsAt.millisecondsSinceEpoch;

                                int currenTime =
                                    DateTime.now().millisecondsSinceEpoch;

                                if (startingTime < currenTime) {
                                  utils.showSnackBar(
                                      'Please chose a correct time!', context);
                                  return;
                                }

                                final endTime = startsAt
                                    .copyWith(
                                        hour: startsAt.hour + duration!.inHours,
                                        minute: startsAt.minute +
                                            duration!.inMinutes)
                                    .millisecondsSinceEpoch;

                                if (groupCubit.position == null) {
                                  utils.showSnackBar(
                                      'Please give access to location!',
                                      context);
                                  groupCubit.fetchPosition();
                                  return;
                                }
                                AutoRouter.of(context).maybePop();
                                groupCubit.createHike(
                                    title,
                                    startingTime,
                                    endTime,
                                    groupCubit.position!.latitude.toString(),
                                    groupCubit.position!.longitude.toString(),
                                    groupID!);
                              }
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

  static GlobalKey<FormState> _joinBeaconKey = GlobalKey<FormState>();
  static TextEditingController _joinBeaconController = TextEditingController();
  static Future joinBeaconDialog(BuildContext context, GroupCubit groupCubit) {
    bool isSmallSized = MediaQuery.of(context).size.height < 800;
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Form(
          key: _joinBeaconKey,
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
                        controller: _joinBeaconController,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        style: TextStyle(fontSize: 22.0),
                        validator: (value) => Validator.validatePasskey(value!),
                        onChanged: (key) {
                          _joinBeaconController.text = key.toUpperCase();
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
                        if (!_joinBeaconKey.currentState!.validate()) return;
                        AutoRouter.of(context).maybePop();
                        groupCubit.joinHike(_joinBeaconController.text.trim());
                        _joinBeaconController.clear();
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
