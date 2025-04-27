import 'package:auto_route/auto_route.dart';
import 'package:beacon/core/utils/validators.dart';
import 'package:beacon/presentation/group/cubit/group_cubit/group_cubit.dart';
import 'package:beacon/presentation/home/home_cubit/home_cubit.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/core/utils/constants.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CreateJoinGroupDialog {
  static GlobalKey<FormState> _groupKey = GlobalKey<FormState>();

  static final TextEditingController _groupNameController =
      TextEditingController();

  static Future createGroupDialog(BuildContext context) {
    // Use MediaQuery instead of responsive height for more consistent sizing
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 800;

    return showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.grey[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          width: size.width * 0.85, // Set a reasonable width
          height: isSmallScreen ? size.height * 0.3 : size.height * 0.25,
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _groupKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Create New Group',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: kLightBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextFormField(
                    controller: _groupNameController,
                    style: TextStyle(fontSize: 18.0),
                    validator: (value) => Validator.validateBeaconTitle(value!),
                    decoration: InputDecoration(
                      hintText: 'Enter Group Title',
                      labelText: 'Title',
                      labelStyle: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                      ),
                      hintStyle:
                          TextStyle(fontSize: 16, color: Colors.grey[400]),
                      alignLabelWithHint: true,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (!_groupKey.currentState!.validate()) return;
                    AutoRouter.of(context).maybePop();
                    context
                        .read<HomeCubit>()
                        .createGroup(_groupNameController.text.trim());
                    _groupNameController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    minimumSize: Size(160, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'Create Group',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 800;

    return showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.grey[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          width: size.width * 0.85,
          height: isSmallScreen ? size.height * 0.3 : size.height * 0.25,
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _joinGroupKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Join Group',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: kLightBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextFormField(
                    controller: _joinGroupController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    style: TextStyle(fontSize: 18.0),
                    validator: (value) => Validator.validatePasskey(value!),
                    onChanged: (value) {
                      _joinGroupController.text = value.toUpperCase();
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Group Code Here',
                      labelText: 'Code',
                      labelStyle: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                      ),
                      hintStyle:
                          TextStyle(fontSize: 16, color: Colors.grey[400]),
                      alignLabelWithHint: true,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (!_joinGroupKey.currentState!.validate()) return;
                    appRouter.maybePop();
                    context
                        .read<HomeCubit>()
                        .joinGroup(_joinGroupController.text.trim());
                    _joinGroupController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    minimumSize: Size(160, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'Join Group',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 800;

    return showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.grey[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          width: size.width * 0.85,
          height: isSmallScreen ? size.height * 0.3 : size.height * 0.25,
          padding: const EdgeInsets.all(24),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Create Hike',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  createHikeBox(context, groupId, true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  minimumSize: Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  'Start Hike',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  createHikeBox(context, groupId, false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  minimumSize: Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  'Schedule Hike',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
          backgroundColor: Colors.grey[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
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
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                                fillColor: Colors.grey[200],
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                border: InputBorder.none,
                                hintText: 'Enter Title Here',
                                labelStyle: TextStyle(
                                    fontSize: labelsize,
                                    color: Theme.of(context).primaryColor),
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
                        // color: Colors.grey[200],
                      ),
                      isInstant ? Container() : SizedBox(height: 1.2.h),
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
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        border: InputBorder.none,
                                        hintText: 'Choose Start Date',
                                        labelStyle: TextStyle(
                                            fontSize: labelsize,
                                            color:
                                                Theme.of(context).primaryColor),
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
                            ),
                      isInstant ? Container() : SizedBox(height: 1.2.h),
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
                                      fillColor: Colors.grey[200],
                                      filled: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      border: InputBorder.none,
                                      alignLabelWithHint: true,
                                      errorStyle:
                                          TextStyle(color: Colors.red[800]),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      labelText: 'Start Time',
                                      labelStyle: TextStyle(
                                          fontSize: labelsize,
                                          color:
                                              Theme.of(context).primaryColor),
                                      hintStyle: TextStyle(
                                          fontSize: hintsize, color: hintColor),
                                      hintText: 'Choose start time',
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(height: 1.2.h),
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
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  border: InputBorder.none,
                                  alignLabelWithHint: true,
                                  errorStyle: TextStyle(color: Colors.red[800]),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelText: 'Duration',
                                  labelStyle: TextStyle(
                                      fontSize: labelsize,
                                      color: Theme.of(context).primaryColor),
                                  hintStyle: TextStyle(
                                      fontSize: hintsize, color: hintColor),
                                  hintText: 'Enter duration of hike',
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Flexible(
                          flex: 2,
                          child: // Replace the Flexible widget with this
                              ElevatedButton(
                            onPressed: () async {
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
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              minimumSize: Size(160, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: Text(
                              isInstant ? 'Start' : 'Create',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 800;

    return showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.grey[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          width: size.width * 0.85,
          height: isSmallScreen ? size.height * 0.3 : size.height * 0.25,
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _joinBeaconKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Join Beacon',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: kLightBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextFormField(
                    controller: _joinBeaconController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    style: TextStyle(fontSize: 18.0),
                    validator: (value) => Validator.validatePasskey(value!),
                    onChanged: (key) {
                      _joinBeaconController.text = key.toUpperCase();
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Passkey Here',
                      labelText: 'Passkey',
                      labelStyle: TextStyle(
                          fontSize: 14, color: Theme.of(context).primaryColor),
                      hintStyle:
                          TextStyle(fontSize: 16, color: Colors.grey[400]),
                      alignLabelWithHint: true,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (!_joinBeaconKey.currentState!.validate()) return;
                    locator<GroupCubit>()
                        .joinBeaconWithShortCode(_joinBeaconController.text);
                    appRouter.maybePop();
                    _joinBeaconController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    minimumSize: Size(160, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'Validate',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
