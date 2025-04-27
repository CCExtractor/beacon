import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/domain/entities/group/group_entity.dart';
import 'package:beacon/presentation/auth/auth_cubit/auth_cubit.dart';
import 'package:beacon/presentation/group/cubit/group_cubit/group_cubit.dart';
import 'package:beacon/presentation/group/cubit/group_cubit/group_state.dart';
import 'package:beacon/presentation/group/cubit/members_cubit/members_cubit.dart';
import 'package:beacon/presentation/group/widgets/create_join_dialog.dart';
import 'package:beacon/presentation/group/widgets/beacon_card.dart';
import 'package:beacon/presentation/group/widgets/group_widgets.dart';
import 'package:beacon/presentation/widgets/shimmer.dart';
import 'package:beacon/presentation/widgets/hike_button.dart';
import 'package:beacon/presentation/widgets/loading_screen.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

@RoutePage()
class GroupScreen extends StatefulWidget {
  final GroupEntity group;

  GroupScreen(this.group);

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen>
    with TickerProviderStateMixin {
  late List<BeaconEntity?> fetchingUserBeacons;
  late List<BeaconEntity?> fetchingNearbyBeacons;
  late GroupCubit _groupCubit;
  late MembersCubit _membersCubit;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_listener);
    _groupCubit = BlocProvider.of<GroupCubit>(context);
    _membersCubit = BlocProvider.of<MembersCubit>(context);
    _groupCubit.init(widget.group);
    _groupCubit.allHikes(widget.group.id!);
    _membersCubit.init(widget.group);
  }

  void _listener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final state = _groupCubit.state;
      if (state is AllBeaconGroupState && !state.isCompletelyFetched) {
        _groupCubit.allHikes(widget.group.id!);
      }
    }
  }

  @override
  void dispose() {
    _groupCubit.clear();
    _membersCubit.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screensize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BlocConsumer<GroupCubit, GroupState>(
          listener: (context, state) {
            if (state is AllBeaconGroupState && state.message != null) {
              utils.showSnackBar(state.message!, context);
            }
          },
          builder: (context, state) {
            return ModalProgressHUD(
              progressIndicator: const LoadingScreen(),
              inAsyncCall: state is LoadingGroupState,
              child: Padding(
                padding: EdgeInsets.only(
                    left: screensize.width * 0.04,
                    right: screensize.width * 0.04,
                    top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.all(0),
                          icon: const Icon(Icons.arrow_back_outlined,
                              color: Colors.grey),
                          onPressed: () => AutoRouter.of(context).maybePop(),
                        ),
                        Image.asset(
                          'images/beacon_logo.png',
                          height: 28,
                        ),
                        IconButton(
                            icon: const Icon(Icons.power_settings_new,
                                color: Colors.grey),
                            onPressed: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      backgroundColor: Color(0xffFAFAFA),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      title:
                                          Text('Logout', style: Style.heading),
                                      content: Text(
                                        'Are you sure you want to logout?',
                                        style: TextStyle(
                                            fontSize: 16, color: kBlack),
                                      ),
                                      actions: <Widget>[
                                        HikeButton(
                                          buttonWidth: 80,
                                          buttonHeight: 40,
                                          isDotted: true,
                                          onTap: () => AutoRouter.of(context)
                                              .maybePop(false),
                                          text: 'No',
                                          textSize: 18.0,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        HikeButton(
                                          buttonWidth: 80,
                                          buttonHeight: 40,
                                          onTap: () async {
                                            appRouter.replaceNamed('/auth');
                                            localApi.deleteUser();
                                            context
                                                .read<AuthCubit>()
                                                .googleSignOut();
                                          },
                                          text: 'Yes',
                                          textSize: 18.0,
                                        ),
                                      ],
                                    ))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildGroupName(),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        widget.group.members != null &&
                                widget.group.members!.isNotEmpty
                            ? SizedBox(
                                width: 40 *
                                    widget.group.members!.length.toDouble(),
                                // 40 is the width of each profile circle
                                height: 40,
                                child: Stack(
                                  children: (widget.group.members != null &&
                                              widget.group.members!.length > 3
                                          ? widget.group.members!.sublist(0, 3)
                                          : widget.group.members ?? [])
                                      .map((member) {
                                    if (member != null) {
                                      return Positioned(
                                        left: widget.group.members!
                                                .indexOf(member) *
                                            20.0,
                                        child: _buildProfileCircle(
                                          member.id == localApi.userModel.id
                                              ? Colors.teal
                                              : shimmerSkeletonColor,
                                        ),
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  }).toList(),
                                ),
                              )
                            : Container(),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Group has ${widget.group.members!.length.toString()} ${widget.group.members!.length == 1 ? 'member' : 'members'}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            // view all members button
                            GestureDetector(
                              onTap: () {
                                GroupWidgetUtils.showMembers(context);
                              },
                              child: Text(
                                "View all members",
                                style: TextStyle(
                                  color: kBlack,
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _buildJoinCreateButton(),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'All Beacons',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          padding: EdgeInsets.all(0),
                          visualDensity: VisualDensity.compact,
                          onPressed: () {
                            GroupWidgetUtils.showFilterBeaconAlertBox(
                                context, widget.group.id!, _groupCubit);
                          },
                          icon: Icon(
                            Icons.filter_alt_outlined,
                            color: Colors.purple,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(child: _groupBeacons(state)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildJoinCreateButton() {
    Size screensize = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 45.w,
          child: HikeButton(
            text: 'Create Hike',
            widget: Icon(
              Icons.add,
              color: Colors.black,
              size: 18,
            ),
            textColor: Colors.white,
            borderColor: Colors.white,
            buttonWidth: screensize.width * 0.44,
            buttonHeight: 45,
            onTap: () {
              CreateJoinBeaconDialog.createHikeDialog(
                  context, widget.group.id!);
            },
          ),
        ),
        SizedBox(width: 1.w),
        Container(
          width: 45.w,
          child: HikeButton(
            text: 'Join a Hike',
            widget: Icon(
              Icons.add,
              color: Colors.black,
              size: 18,
            ),
            buttonColor: Colors.white,
            isDotted: true,
            buttonWidth: screensize.width * 0.44,
            buttonHeight: 45,
            onTap: () async {
              CreateJoinBeaconDialog.joinBeaconDialog(context);
            },
          ),
        ),
      ],
    );
  }

  Widget _groupBeacons(GroupState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0),
      child: Builder(
        builder: (context) {
          if (state is ShrimmerGroupState) {
            return Center(child: ShimmerWidget.getPlaceholder());
          } else if (state is AllBeaconGroupState) {
            final beacons = state.beacons;
            String message = 'You haven\'t joined or created any beacon yet';
            return _buildBeaconsList(beacons, state.isLoadingMore,
                state.isCompletelyFetched, message);
          } else if (state is NearbyBeaconGroupState) {
            final beacons = state.beacons;
            String message =
                'No beacons found under ${state.radius.toStringAsFixed(2)} m... radius';
            return _buildBeaconsList(beacons, false, false, message);
          } else if (state is StatusFilterBeaconGroupState) {
            final beacons = state.beacons;
            var type = state.type!.name;
            String message =
                'No ${type[0].toUpperCase() + type.substring(1).toLowerCase()} beacons found';
            return _buildBeaconsList(beacons, false, false, message);
          } else if (state is ErrorGroupState) {
            return _buildErrorWidget(state.message);
          }
          return _buildErrorWidget('Something went wrong!');
        },
      ),
    );
  }

  Widget _buildGroupName() {
    return Row(
      children: [
        Text(
          'Welcome to Group ',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        SizedBox(
          width: 2.w,
        ),
        Text(
          widget.group.title!,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 24,
              color: Colors.tealAccent,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildBeaconsList(List<BeaconEntity> beacons, bool isLoadingMore,
      bool isCompletelyFetched, String message) {
    return Container(
      alignment: Alignment.center,
      child: beacons.isEmpty
          ? SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: _noBeaconsWidget(message),
            )
          : ListView.builder(
              controller: _scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: beacons.length +
                  (isLoadingMore && !isCompletelyFetched ? 1 : 0),
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) {
                if (index == beacons.length) {
                  return LinearProgressIndicator();
                }
                return _buildBeaconCard(beacons[index]);
              },
            ),
    );
  }

  Widget _buildBeaconCard(BeaconEntity beacon) {
    return BeaconCard(
      beacon: beacon,
      onDelete: () async {
        bool? value = await GroupWidgetUtils.deleteDialog(context);
        if (value == null || !value) {
          return;
        }
        await _groupCubit.deleteBeacon(beacon);
        _groupCubit.reloadState(message: 'Beacon deleted');
        return;
      },
      onReschedule: () {
        GroupWidgetUtils.reScheduleHikeDialog(context, beacon);
      },
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: kBlack, fontSize: 20),
            ),
            Gap(5),
            FloatingActionButton(
              onPressed: () async {
                try {
                  await locationService.openSettings();
                } catch (e) {
                  log('error: $e');
                }
              },
              child: Icon(
                Icons.settings,
                color: kBlack,
              ),
              backgroundColor: kYellow,
            ),
            Gap(15),
            RichText(
              text: TextSpan(
                style: TextStyle(color: kBlack, fontSize: 20),
                children: [
                  TextSpan(
                      text: 'Join',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ' a Hike or '),
                  TextSpan(
                      text: 'Create',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '  a new one! '),
                ],
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _noBeaconsWidget(String message) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: kBlack, fontSize: 20),
          ),
          SizedBox(
            height: 2.h,
          ),
          RichText(
            text: TextSpan(
              style: TextStyle(color: kBlack, fontSize: 20),
              children: [
                TextSpan(
                    text: 'Join',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' a Hike or '),
                TextSpan(
                    text: 'Create',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: '  a new one! '),
              ],
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
        ],
      ),
    );
  }
}

Widget _buildProfileCircle(Color color) {
  return Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
      border: Border.all(color: Colors.white, width: 2),
    ),
  );
}

class HikeCard extends StatelessWidget {
  final bool isActive;
  final String startTime;
  final String endTime;
  final String passkey;

  const HikeCard({
    super.key,
    required this.isActive,
    required this.startTime,
    required this.endTime,
    required this.passkey,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.hiking, size: 28),
                SizedBox(width: 8),
                Text('Hike 1',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Hike is ${isActive ? "Active" : "inactive"}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.teal : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text('Started at: $startTime'),
            Text('Expires at: $endTime'),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Passkey: $passkey',
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    // TODO: Copy to clipboard
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // TODO: Delete action
                  },
                  child: const Text("Delete"),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    // TODO: Reschedule action
                  },
                  child: const Text("Reschedule"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
