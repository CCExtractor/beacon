import 'dart:developer';

import 'package:beacon/core/utils/validators.dart';
import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/presentation/group/cubit/members_cubit/members_cubit.dart';
import 'package:beacon/presentation/group/cubit/members_cubit/members_state.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/presentation/widgets/shimmer.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beacon/presentation/group/cubit/group_cubit/group_cubit.dart';
import 'package:beacon/presentation/group/cubit/group_cubit/group_state.dart';
import 'package:beacon/presentation/widgets/hike_button.dart';
import 'package:beacon/core/utils/constants.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GroupWidgetUtils {
  static Widget membersWidget(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'members',
      backgroundColor: kYellow,
      onPressed: () {
        showMembers(context);
      },
      child: Icon(Icons.person, size: 30),
    );
  }

  static void showMembers(BuildContext context) {
    // Dialog for filtering beacons
    locator<MembersCubit>().loadMembers();
    showDialog(
      context: context,
      builder: (context) {
        bool isSmallSized = 100.h < 800;
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.group),
              Gap(5),
              Text(
                'Members',
                textAlign: TextAlign.center,
              )
            ],
          ),
          content: Container(
              height: isSmallSized ? 30.h : 25.h,
              width: isSmallSized ? 200 : 300,
              child: BlocConsumer<MembersCubit, MembersState>(
                listener: (context, state) {
                  if (state is LoadedMemberState && state.message != null) {
                    utils.showSnackBar(state.message!, context);
                  }
                },
                builder: (context, state) {
                  if (state is LoadingMemberState) {
                    return ShimmerWidget.getPlaceholder();
                  } else if (state is LoadedMemberState) {
                    var members = state.members;
                    return members!.isEmpty
                        ? Container(
                            child:
                                Text('Please check your internet connection'),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: members.length,
                            itemBuilder: (context, index) {
                              bool isLeader =
                                  localApi.userModel.id! == members[0].id!;
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    color: kLightBlue,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: ListTile(
                                  leading: index == 0
                                      ? Icon(
                                          Icons.star,
                                          color: kYellow,
                                        )
                                      : Icon(Icons.person),
                                  trailing: index == 0
                                      ? Text('Leader')
                                      : isLeader
                                          ? IconButton(
                                              onPressed: () {
                                                context
                                                    .read<MembersCubit>()
                                                    .removeMember(
                                                        members[index].id ??
                                                            '');
                                              },
                                              icon: Icon(
                                                Icons.person_remove_alt_1,
                                                weight: 20,
                                                color: const Color.fromARGB(
                                                    255, 215, 103, 95),
                                              ))
                                          : null,
                                  subtitle: localApi.userModel.id! ==
                                          members[index].id!
                                      ? Text(
                                          '(YOU)',
                                          style: TextStyle(fontSize: 12),
                                        )
                                      : null,
                                  title:
                                      Text(members[index].name ?? 'Anonymous'),
                                ),
                              );
                            },
                          );
                  }
                  return Container();
                },
              )),
        );
      },
    );
  }

  static Future<bool?> deleteDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        // actionsAlignment: MainAxisAlignment.spaceEvenly,
        contentPadding: EdgeInsets.all(25.0),
        content: Text(
          'Are you sure you want to delete this beacon?',
          style: TextStyle(fontSize: 18, color: kBlack),
        ),
        actions: <Widget>[
          HikeButton(
            buttonHeight: 2.5.h,
            buttonWidth: 8.w,
            onTap: () => appRouter.maybePop(false),
            text: 'No',
          ),
          HikeButton(
            buttonHeight: 2.5.h,
            buttonWidth: 8.w,
            onTap: () => appRouter.maybePop(true),
            text: 'Yes',
          ),
        ],
      ),
    );
  }

  static Widget filterBeacons(
      BuildContext context, String groupId, GroupCubit groupCubit) {
    // Widget for filtering beacons
    return FloatingActionButton(
      heroTag: 'filter beacon',
      backgroundColor: kYellow,
      onPressed: () => showFilterBeaconAlertBox(context, groupId, groupCubit),
      child: ImageIcon(
        AssetImage(AppConstants.filterIconPath),
        size: 35,
        semanticLabel: 'Filter',
        color: Colors.black,
      ),
    );
  }

  static Future<void> reScheduleHikeDialog(
      BuildContext context, BeaconEntity beacon) {
    var startsAt = beacon.startsAt!;
    var expiresAt = beacon.expiresAt!;
    var previousStartDate = DateTime.fromMillisecondsSinceEpoch(startsAt);
    var previousExpireDate = DateTime.fromMillisecondsSinceEpoch(expiresAt);

    var previousDuration = previousExpireDate.difference(previousStartDate);

    DateTime? newstartDate = previousStartDate;
    TextEditingController _dateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(previousStartDate));

    TimeOfDay? startTime = TimeOfDay(
        hour: previousStartDate.hour, minute: previousStartDate.minute);
    TextEditingController _startTimeController = TextEditingController(
        text: DateFormat('HH:mm').format(previousStartDate));

    Duration? duration = previousDuration;
    TextEditingController _durationController = TextEditingController(
        text: previousDuration.inMinutes < 60
            ? '${previousDuration.inMinutes} minutes'
            : '${previousDuration.inHours} hours');

    GlobalKey<FormState> _createFormKey = GlobalKey<FormState>();
    bool isSmallSized = 100.h < 800;

    bool isExpired = DateTime.now()
        .isAfter(DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt!));
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
                height: isSmallSized ? 68.h : 62.h,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Column(
                    children: [
                      Text(
                        isExpired ? 'Activate Hike' : 'Reschedule Hike',
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(height: 2.h),
                      // start date field
                      Container(
                        height: isSmallSized ? 14.h : 12.h,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () async {
                              newstartDate = await showDatePicker(
                                context: context,
                                initialDate: newstartDate ?? DateTime.now(),
                                firstDate: newstartDate ?? DateTime.now(),
                                lastDate: DateTime(2100),
                                // builder: (context, child) => Theme(
                                //     data: ThemeData().copyWith(
                                //       textTheme: Theme.of(context).textTheme,
                                //       colorScheme: ColorScheme.light(
                                //         primary: kLightBlue,
                                //         onPrimary: Colors.grey,
                                //         surface: kBlue,
                                //       ),
                                //     ),
                                //     child: child!),
                              );
                              if (newstartDate == null) return;
                              _dateController.text = DateFormat('yyyy-MM-dd')
                                  .format(newstartDate!);
                            },
                            child: TextFormField(
                              validator: (value) =>
                                  Validator.validateDate(value),
                              controller: _dateController,
                              enabled: false,
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
                        height: isSmallSized ? 14.h : 12.h,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () async {
                              startTime = await showTimePicker(
                                  context: context,
                                  initialTime: startTime ??
                                      TimeOfDay(
                                          hour: DateTime.now().hour,
                                          minute: DateTime.now().minute + 1));
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
                              validator: (value) => Validator.validateStartTime(
                                  value, _dateController.text),
                              controller: _startTimeController,
                              enabled: false,
                              onEditingComplete: () {},
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
                      // // Duration Field
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
                                  Validator.validateDuration(value),
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
                            text: 'Update',
                            textSize: 18.0,
                            textColor: Colors.white,
                            buttonColor: kYellow,
                            onTap: () async {
                              if (!_createFormKey.currentState!.validate())
                                return;
                              DateTime startsAt = DateTime(
                                  newstartDate!.year,
                                  newstartDate!.month,
                                  newstartDate!.day,
                                  startTime!.hour,
                                  startTime!.minute);

                              final newStartsAt =
                                  startsAt.millisecondsSinceEpoch;

                              final newExpiresAT = startsAt
                                  .copyWith(
                                      hour: startsAt.hour + duration!.inHours,
                                      minute:
                                          startsAt.minute + duration!.inMinutes)
                                  .millisecondsSinceEpoch;

                              context.read<GroupCubit>().rescheduleHike(
                                  newExpiresAT, newStartsAt, beacon.id!);
                              _dateController.clear();
                              _startTimeController.clear();
                              _durationController.clear();
                              appRouter.maybePop();
                              // }
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

  static void showFilterBeaconAlertBox(
      BuildContext context, String groupId, GroupCubit groupCubit) {
    log(100.h.toString());
    // Dialog for filtering beacons
    showDialog(
      context: context,
      builder: (context) {
        bool isSmallSized = 100.h < 800;
        return AlertDialog(
          backgroundColor: Colors.grey[100],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageIcon(
                AssetImage(AppConstants.filterIconPath),
                semanticLabel: 'Filter',
                color: Colors.black,
              ),
              Gap(10),
              Text(
                'Filter',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: SizedBox(
            width: 200,
            height: isSmallSized ? 32.h : 30.h,
            child: BlocBuilder<GroupCubit, GroupState>(
              builder: (context, state) => ListView.builder(
                itemCount: filters.values.length,
                itemBuilder: (context, index) {
                  String type = filters.values[index].name;

                  return ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (filters.values[index] == filters.NEARBY) {
                          _neabyFilterAlertBox(context, groupId, groupCubit);
                        } else {
                          locator<GroupCubit>()
                              .changeFilter(filters.values[index]);
                        }
                      },
                      child: Text(
                        type,
                        style: TextStyle(fontSize: 18, height: 1.5),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      ));
                },
              ),
            ),
          ),
        );
      },
    );
  }

  static void _neabyFilterAlertBox(
      BuildContext context, String groupId, GroupCubit groupCubit) {
    GlobalKey<FormState> _key = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (context) {
        double value = 1000.0 /
            100000; // Default radius for range (100 km) // creating a 100.0 km range
        bool isSmallSized = 100.h < 800;
        return AlertDialog(
          content: SizedBox(
            height: isSmallSized ? 28.h : 25.h,
            child: Form(
              key: _key,
              child: Column(
                children: [
                  Gap(5),
                  Container(
                    color: kLightBlue,
                    child: StatefulBuilder(
                      builder: (context, setState) => Stack(
                        children: [
                          Container(
                            height: 14.h,
                            child: Slider(
                              activeColor: kYellow,
                              value: value,
                              onChanged: (double newValue) {
                                setState(() {
                                  value = newValue;
                                });
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment(0, 0),
                            child: Text(
                              '${(value * 100).toStringAsFixed(2)} km',
                              style: TextStyle(fontSize: 20, color: hintColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Gap(10),
                  HikeButton(
                    text: 'Fetch',
                    buttonColor: kYellow,
                    onTap: () {
                      if (_key.currentState!.validate()) {
                        appRouter.maybePop();
                        locator<GroupCubit>()
                            .nearbyHikes(groupId, radius: value * 100000);
                      }
                    },
                    buttonWidth: 60,
                    borderColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
