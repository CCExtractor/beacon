import 'dart:developer';

import 'package:beacon/core/utils/validators.dart';
import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
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
    locator<MembersCubit>().loadMembers();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        final bool isSmallSized = 100.h < 800;
        final double dialogHeight = isSmallSized ? 30.h : 25.h;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.group, color: Colors.black, size: 30),
              Gap(8),
              Text(
                'Members',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              )
            ],
          ),
          content: SizedBox(
            height: dialogHeight,
            width: isSmallSized ? 280 : 350,
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

                  if (members == null || members.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wifi_off,
                              size: 40, color: Colors.grey.shade500),
                          const SizedBox(height: 8),
                          Text(
                            'No members found.\nCheck your internet connection.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: members.length,
                    separatorBuilder: (_, __) => Gap(8),
                    itemBuilder: (context, index) {
                      final member = members[index];
                      final isCurrentUser = localApi.userModel.id == member.id;
                      final isLeader =
                          localApi.userModel.id == members.first.id;
                      return _MemberTile(
                        member: member,
                        isLeader: index == 0,
                        canRemove: isLeader && index != 0,
                        isCurrentUser: isCurrentUser,
                      );
                    },
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
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
            buttonHeight: 5.h,
            buttonWidth: 20.w,
            onTap: () => appRouter.maybePop(false),
            text: 'No',
            isDotted: true,
          ),
          HikeButton(
            buttonHeight: 5.h,
            buttonWidth: 20.w,
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
    BuildContext context,
    BeaconEntity beacon,
  ) {
    var previousStartDate =
        DateTime.fromMillisecondsSinceEpoch(beacon.startsAt!);
    var previousExpireDate =
        DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt!);
    var previousDuration = previousExpireDate.difference(previousStartDate);

    DateTime? newStartDate = previousStartDate;
    var _dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(previousStartDate),
    );

    TimeOfDay? startTime = TimeOfDay(
      hour: previousStartDate.hour,
      minute: previousStartDate.minute,
    );
    var _startTimeController = TextEditingController(
      text: DateFormat('hh:mm a').format(previousStartDate),
    );

    Duration? duration = previousDuration;
    var _durationController = TextEditingController(
      text: previousDuration.inHours > 0
          ? '${previousDuration.inHours} hour${previousDuration.inHours > 1 ? 's' : ''} ${previousDuration.inMinutes % 60} minutes'
          : '${previousDuration.inMinutes} minutes',
    );

    final _formKey = GlobalKey<FormState>();
    bool isSmallSized = 100.h < 800;

    bool isExpired = DateTime.now().isAfter(previousExpireDate);

    return showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Dialog(
          backgroundColor: Colors.grey[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                height: isSmallSized ? 55.h : 50.h,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    children: [
                      Text(
                        isExpired ? 'Activate Hike' : 'Reschedule Hike',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.h),

                      /// Start Date
                      Container(
                        height: isSmallSized ? 11.h : 9.h,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () async {
                              newStartDate = await showDatePicker(
                                context: context,
                                initialDate: newStartDate ?? DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (newStartDate != null) {
                                _dateController.text = DateFormat('yyyy-MM-dd')
                                    .format(newStartDate!);
                              }
                            },
                            child: TextFormField(
                              validator: (value) =>
                                  Validator.validateDate(value),
                              controller: _dateController,
                              enabled: false,
                              decoration: InputDecoration(
                                fillColor: Colors.grey[200],
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                border: InputBorder.none,
                                hintText: 'Choose Start Date',
                                labelStyle: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                labelText: 'Start Date',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),

                      /// Start Time
                      Container(
                        height: isSmallSized ? 11.h : 9.h,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () async {
                              startTime = await showTimePicker(
                                context: context,
                                initialTime: startTime ??
                                    TimeOfDay(
                                      hour: DateTime.now().hour,
                                      minute: DateTime.now().minute + 1,
                                    ),
                              );
                              if (startTime != null) {
                                _startTimeController.text =
                                    startTime!.format(context);
                              }
                            },
                            child: TextFormField(
                              validator: (value) => Validator.validateStartTime(
                                  value, _dateController.text),
                              controller: _startTimeController,
                              enabled: false,
                              decoration: InputDecoration(
                                fillColor: Colors.grey[200],
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                border: InputBorder.none,
                                hintText: 'Choose Start Time',
                                labelStyle: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                labelText: 'Start Time',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),

                      /// Duration
                      Container(
                        height: isSmallSized ? 11.h : 9.h,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () async {
                              duration = await showDurationPicker(
                                context: context,
                                initialTime: duration ?? Duration(minutes: 5),
                              );
                              if (duration != null) {
                                if (duration!.inHours > 0) {
                                  _durationController.text =
                                      '${duration!.inHours} hour${duration!.inHours > 1 ? 's' : ''} ${duration!.inMinutes % 60} minutes';
                                } else {
                                  _durationController.text =
                                      '${duration!.inMinutes} minutes';
                                }
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
                                hintText: 'Enter duration of hike',
                                labelStyle: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                labelText: 'Duration',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),

                      /// Button
                      Flexible(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              DateTime startsAt = DateTime(
                                newStartDate!.year,
                                newStartDate!.month,
                                newStartDate!.day,
                                startTime!.hour,
                                startTime!.minute,
                              );

                              final newStartsAt =
                                  startsAt.millisecondsSinceEpoch;
                              final newExpiresAt = startsAt
                                  .add(duration!)
                                  .millisecondsSinceEpoch;

                              context.read<GroupCubit>().rescheduleHike(
                                  newExpiresAt, newStartsAt, beacon.id!);

                              _dateController.clear();
                              _startTimeController.clear();
                              _durationController.clear();

                              appRouter.maybePop();
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
                            'Update',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
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

Widget _buildProfileCircle(String? url) {
  return Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.grey[300],
      border: Border.all(color: Colors.white, width: 2),
      image: DecorationImage(
        image: NetworkImage(url!),
        fit: BoxFit.cover,
      ),
    ),
  );
}

class _MemberTile extends StatelessWidget {
  final UserEntity member;
  final bool isLeader;
  final bool canRemove;
  final bool isCurrentUser;

  const _MemberTile({
    required this.member,
    required this.isLeader,
    required this.canRemove,
    required this.isCurrentUser,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kLightBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: _buildProfileCircle(member.imageUrl),
        title: Text(
          member.name ?? 'Anonymous',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: isCurrentUser
            ? Text(
                '(YOU)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              )
            : null,
        trailing: isLeader
            ? Text(
                'Leader',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              )
            : canRemove
                ? IconButton(
                    onPressed: () {
                      context
                          .read<MembersCubit>()
                          .removeMember(member.id ?? '');
                    },
                    icon: Icon(
                      Icons.person_remove_alt_1,
                      color: Colors.red.shade400,
                    ),
                  )
                : null,
      ),
    );
  }
}
