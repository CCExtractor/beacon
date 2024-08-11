import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/domain/entities/group/group_entity.dart';
import 'package:beacon/presentation/group/cubit/group_cubit/group_cubit.dart';
import 'package:beacon/presentation/group/cubit/group_cubit/group_state.dart';
import 'package:beacon/presentation/group/cubit/members_cubit/members_cubit.dart';
import 'package:beacon/presentation/group/widgets/create_join_dialog.dart';
import 'package:beacon/presentation/group/widgets/beacon_card.dart';
import 'package:beacon/presentation/group/widgets/group_widgets.dart';
import 'package:beacon/presentation/widgets/shimmer.dart';
import 'package:beacon/presentation/widgets/hike_button.dart';
import 'package:beacon/presentation/widgets/loading_screen.dart';
import 'package:beacon/presentation/widgets/shape_painter.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
    TabController tabController = TabController(length: 1, vsync: this);

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
              child: Stack(
                children: <Widget>[
                  CustomPaint(
                    size: Size(100.w, 100.h - 200),
                    painter: ShapePainter(),
                  ),
                  _buildGroupName(),
                  Align(
                    alignment: Alignment(0.9, -0.70),
                    child: GroupWidgetUtils.filterBeacons(
                        context, widget.group.id!, _groupCubit),
                  ),
                  Align(
                    alignment: Alignment(0.5, -0.70),
                    child: GroupWidgetUtils.membersWidget(context),
                  ),
                  _buildJoinCreateButton(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.565,
                        margin: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          color: kLightBlue,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            topRight: Radius.circular(50.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            TabBar(
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorColor: kBlue,
                              labelColor: kBlack,
                              tabs: [
                                _buildTab(state),
                              ],
                              controller: tabController,
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: tabController,
                                children: <Widget>[
                                  _groupBeacons(state),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildJoinCreateButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 23.h, 4.w, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 45.w,
            child: HikeButton(
              buttonWidth: homebwidth,
              buttonHeight: homebheight - 2,
              text: 'Create Hike',
              textColor: Colors.white,
              borderColor: Colors.white,
              buttonColor: kYellow,
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
              buttonWidth: homebwidth,
              buttonHeight: homebheight - 2,
              text: 'Join a Hike',
              textColor: kYellow,
              borderColor: kYellow,
              buttonColor: Colors.white,
              onTap: () async {
                CreateJoinBeaconDialog.joinBeaconDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(GroupState state) {
    return Tab(
      text: state is AllBeaconGroupState
          ? 'All Beacons'
          : state is NearbyBeaconGroupState
              ? 'Nearby Beacons'
              : state is StatusFilterBeaconGroupState
                  ? '${state.type!.name[0] + state.type!.name.substring(1).toLowerCase()} Beacons'
                  : 'Loading Beacons..',
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
    return Align(
      alignment: Alignment(-0.7, -0.95),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Text(
          'Welcome to Group ${widget.group.title!}',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
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
    return Slidable(
      key: Key(beacon.id!.toString()),
      startActionPane: ActionPane(
        dragDismissible: true,
        dismissible: DismissiblePane(
          onDismissed: () {
            _groupCubit.reloadState(message: 'Beacon deleted');
          },
          confirmDismiss: () async {
            bool? value = await GroupWidgetUtils.deleteDialog(context);
            if (value == null || !value) {
              return false;
            }
            bool delete = await _groupCubit.deleteBeacon(beacon);
            return delete;
          },
        ),
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: null,
            backgroundColor: Color.fromARGB(255, 217, 100, 94),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (context) {
              GroupWidgetUtils.reScheduleHikeDialog(context, beacon);
            },
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
            icon: Icons.edit_calendar,
            label: 'Reschedule',
          ),
        ],
      ),
      child: BeaconCard(beacon: beacon),
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
