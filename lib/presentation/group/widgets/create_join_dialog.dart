import 'package:auto_route/auto_route.dart';
import 'package:beacon/core/utils/validators.dart';
import 'package:beacon/presentation/group/cubit/group_cubit/group_cubit.dart';
import 'package:beacon/presentation/home/home_cubit/home_cubit.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/presentation/widgets/hike_button.dart';
import 'package:beacon/core/utils/constants.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CreateJoinGroupDialog {
  static GlobalKey<FormState> _groupKey = GlobalKey<FormState>();

  static final TextEditingController _groupNameController =
      TextEditingController();

  static Future createGroupDialog(
    BuildContext context,
  ) {
    bool isSmallSized = 100.h < 800;
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
              height: isSmallSized ? 30.h : 25.h,
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
                            context
                                .read<HomeCubit>()
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
            height: isSmallSized ? 30.h : 25.h,
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
                        appRouter.maybePop();
                        context
                            .read<HomeCubit>()
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

String title = '';
DateTime? startDate = DateTime.now();
TimeOfDay? startTime =
    TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute + 1);
Duration? duration = Duration(minutes: 5);

class CreateJoinBeaconDialog {
  static Future createHikeDialog(BuildContext context, String groupId) {
    bool isSmallSized = 100.h < 800;
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          height: isSmallSized ? 30.h : 25.h,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            children: [
              Gap(15),
              Text(
                'Create hike',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              Gap(20),
              HikeButton(
                text: 'Start Hike',
                buttonWidth: 2,
                buttonHeight: 16,
                buttonColor: kYellow,
                onTap: () {
                  Navigator.of(context).pop();
                  createHikeBox(context, groupId, true);
                },
              ),
              Gap(10),
              HikeButton(
                text: 'Schedule Hike',
                buttonWidth: 5,
                buttonHeight: 16,
                buttonColor: kYellow,
                onTap: () {
                  Navigator.of(context).pop();
                  createHikeBox(context, groupId, false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> createHikeBox(
      BuildContext context, String? groupID, bool isInstant) {
    bool isSmallSized = 100.h < 800;

    GlobalKey<FormState> _createFormKey = GlobalKey<FormState>();

    FocusNode _titleNode = FocusNode();
    FocusNode _startDateNode = FocusNode();

    TextEditingController _dateController = TextEditingController();
    TextEditingController _startTimeController = TextEditingController();
    TextEditingController _durationController = TextEditingController();
    String title = '';
    DateTime? startDate = DateTime.now();
    TimeOfDay? startTime = TimeOfDay(
        hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute + 1);
    Duration? duration = Duration(minutes: 5);

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
                height: isInstant
                    ? isSmallSized
                        ? 45.h
                        : 40.h
                    : isSmallSized
                        ? 75.h
                        : 65.h,
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
                                Validator.validateBeaconTitle(value),
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
                      isInstant ? Container() : SizedBox(height: 2.h),
                      // start date field
                      isInstant
                          ? Container()
                          : Container(
                              height: isSmallSized ? 12.h : 10.h,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  onTap: () async {
                                    startDate = await showDatePicker(
                                      context: context,
                                      initialDate: startDate ?? DateTime.now(),
                                      firstDate: startDate ?? DateTime.now(),
                                      lastDate: DateTime(2100),
                                      // builder: (context, child) => Theme(
                                      //     // data: ThemeData().copyWith(
                                      //     //   textTheme:
                                      //     //       Theme.of(context).textTheme,
                                      //     //   colorScheme: ColorScheme.light(
                                      //     //     primary: kLightBlue,
                                      //     //     onPrimary: Colors.grey,
                                      //     //     surface: kBlue,
                                      //     //   ),
                                      //     // ),
                                      //     child: child!),
                                    );
                                    if (startDate == null) return;
                                    _dateController.text =
                                        DateFormat('yyyy-MM-dd')
                                            .format(startDate!);
                                  },
                                  child: TextFormField(
                                    validator: (value) =>
                                        Validator.validateDate(value),
                                    controller: _dateController,
                                    enabled: false,
                                    focusNode: _startDateNode,
                                    onEditingComplete: () {},
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Choose Start Date',
                                        labelStyle: TextStyle(
                                            fontSize: labelsize,
                                            color: kYellow),
                                        hintStyle: TextStyle(
                                            fontSize: hintsize,
                                            color: hintColor),
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
                      isInstant ? Container() : SizedBox(height: 2.h),
                      // Start Time Field
                      isInstant
                          ? SizedBox.shrink()
                          : Container(
                              height: isSmallSized ? 12.h : 10.h,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  onTap: () async {
                                    startTime = await showTimePicker(
                                        context: context,
                                        initialTime: startTime ??
                                            TimeOfDay(
                                                hour: DateTime.now().hour,
                                                minute:
                                                    DateTime.now().minute + 1));
                                    if (startTime != null) {
                                      if (startTime!.minute < 10) {
                                        _startTimeController.text =
                                            '${startTime!.hour}:0${startTime!.minute} ${startTime!.period == DayPeriod.am ? 'AM' : 'PM'}';
                                      } else {
                                        _startTimeController.text =
                                            '${startTime!.hour}:${startTime!.minute} ${startTime!.period == DayPeriod.am ? 'AM' : 'PM'}';
                                      }
                                    }
                                  },
                                  child: TextFormField(
                                    validator: (value) =>
                                        Validator.validateStartTime(
                                            value, _dateController.text),
                                    controller: _startTimeController,
                                    enabled: false,
                                    onEditingComplete: () {},
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      alignLabelWithHint: true,
                                      errorStyle:
                                          TextStyle(color: Colors.red[800]),
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
                                initialTime: duration ?? Duration(minutes: 5),
                              );
                              if (duration == null) return;
                              if (duration!.inHours != 0 &&
                                  duration!.inMinutes != 0) {
                                _durationController.text =
                                    '${duration!.inHours.toString()} hour ${(duration!.inMinutes % 60)} minutes';
                              } else if (duration!.inMinutes != 0) {
                                _durationController.text =
                                    '${duration!.inMinutes.toString()} minutes';
                              }
                            },
                            child: TextFormField(
                              enabled: false,
                              controller: _durationController,
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
                            text: isInstant ? 'Start' : 'Create',
                            textSize: 18.0,
                            textColor: Colors.white,
                            buttonColor: kYellow,
                            onTap: () async {
                              if (_createFormKey.currentState!.validate()) {
                                var groupCubit = locator<GroupCubit>();
                                if (!isInstant) {
                                  DateTime start = DateTime(
                                      startDate!.year,
                                      startDate!.month,
                                      startDate!.day,
                                      startTime!.hour,
                                      startTime!.minute);

                                  final startsAt = start.millisecondsSinceEpoch;

                                  final expiresAt = start
                                      .add(duration!)
                                      .millisecondsSinceEpoch;

                                  groupCubit.createHike(title, startsAt,
                                      expiresAt, groupID!, isInstant);
                                  _durationController.clear();
                                  _startTimeController.clear();
                                  _durationController.clear();

                                  appRouter.maybePop();
                                } else {
                                  int startsAt =
                                      DateTime.now().millisecondsSinceEpoch;

                                  int expiresAt = DateTime.now()
                                      .add(duration!)
                                      .millisecondsSinceEpoch;

                                  groupCubit.createHike(title, startsAt,
                                      expiresAt, groupID!, isInstant);

                                  _durationController.clear();
                                  _startTimeController.clear();
                                  _durationController.clear();
                                  appRouter.maybePop();
                                }
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
  static Future joinBeaconDialog(BuildContext context) {
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
                        locator<GroupCubit>().joinBeaconWithShortCode(
                            _joinBeaconController.text);
                        appRouter.maybePop();
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
