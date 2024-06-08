import 'package:auto_route/auto_route.dart';
import 'package:beacon/Bloc/domain/entities/group/group_entity.dart';
import 'package:beacon/Bloc/presentation/cubit/group_cubit.dart';
import 'package:beacon/Bloc/presentation/widgets/create_join_dialog.dart';
import 'package:beacon/old/components/beacon_card.dart';
import 'package:beacon/old/components/hike_button.dart';
import 'package:beacon/old/components/loading_screen.dart';
import 'package:beacon/old/components/shape_painter.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/old/components/models/beacon/beacon.dart';
import 'package:beacon/old/components/utilities/constants.dart';
import 'package:beacon/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sizer/sizer.dart';

@RoutePage()
class GroupScreen extends StatefulWidget {
  final GroupEntity group;
  GroupScreen(this.group) : super();

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen>
    with TickerProviderStateMixin {
  late List<Beacon?> fetchingUserBeacons;
  late List<Beacon?> fetchingNearbyBeacons;

  late GroupCubit _groupCubit;
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_listener);
    _groupCubit = context.read<GroupCubit>();
    _groupCubit.fetchGroupHikes(widget.group.id!);
    super.initState();
  }

  _listener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_groupCubit.isCompletelyFetched == true) {
        return;
      }
      _groupCubit.fetchGroupHikes(widget.group.id!);
    }
  }

  @override
  void dispose() {
    _groupCubit.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = new TabController(length: 2, vsync: this);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BlocConsumer<GroupCubit, GroupState>(
          listener: (context, state) {
            if (state is GroupErrorState) {
              utils.showSnackBar(state.error, context);
            }
          },
          builder: (context, state) {
            return ModalProgressHUD(
              progressIndicator: const LoadingScreen(),
              inAsyncCall: (state is GroupLoadingState) ? true : false,
              child: Stack(
                children: <Widget>[
                  CustomPaint(
                    size: Size(MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height - 200),
                    painter: ShapePainter(),
                  ),
                  Align(
                    alignment: Alignment(-0.7, -0.95),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        'Welcome to Group ' + widget.group.title!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0.9, -0.8),
                    child: FloatingActionButton(
                      onPressed: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                // actionsAlignment:
                                //     MainAxisAlignment.spaceEvenly,
                                title: Text(
                                  localApi.userModel.isGuest!
                                      ? 'Create Account'
                                      : 'Logout',
                                  style:
                                      TextStyle(fontSize: 25, color: kYellow),
                                ),
                                content: Text(
                                  localApi.userModel.isGuest!
                                      ? 'Would you like to create an account?'
                                      : 'Are you sure you wanna logout?',
                                  style: TextStyle(fontSize: 16, color: kBlack),
                                ),
                                actions: <Widget>[
                                  HikeButton(
                                    buttonHeight: 2.5.h,
                                    buttonWidth: 8.w,
                                    onTap: () =>
                                        Navigator.of(context).pop(false),
                                    text: 'No',
                                    textSize: 18.0,
                                  ),
                                  HikeButton(
                                    buttonHeight: 2.5.h,
                                    buttonWidth: 8.w,
                                    onTap: () async {
                                      AutoRouter.of(context).maybePop();
                                      AutoRouter.of(context).pushAndPopUntil(
                                        AuthScreenRoute(),
                                        predicate: (route) => true,
                                      );
                                      await localApi.deleteUser();
                                    },
                                    text: 'Yes',
                                    textSize: 18.0,
                                  ),
                                ],
                              )),
                      backgroundColor: kYellow,
                      child: localApi.userModel.isGuest!
                          ? Icon(Icons.person)
                          : Icon(Icons.logout),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4.w, 25.h, 4.w, 5),
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
                                  context, widget.group.id, _groupCubit);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
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
                              CreateJoinBeaconDialog.joinBeaconDialog(
                                  context, _groupCubit);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
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
                              topLeft: const Radius.circular(50.0),
                              topRight: const Radius.circular(50.0),
                            ),
                          ),
                          child: Column(
                            children: [
                              TabBar(
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicatorColor: kBlue,
                                labelColor: kBlack,
                                tabs: [
                                  Tab(text: 'Your Beacons'),
                                  Tab(text: 'Nearby Beacons'),
                                ],
                                controller: tabController,
                              ),
                              Expanded(
                                child: TabBarView(
                                  controller: tabController,
                                  children: <Widget>[
                                    _groupBeacons(),
                                    _nearByBeacons()
                                  ],
                                ),
                              )
                            ],
                          ))
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

  Widget _groupBeacons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0),
      child: BlocBuilder<GroupCubit, GroupState>(
        builder: (context, state) {
          if (state is ShrimmerGroupState) {
            return Center(
              child: BeaconCustomWidgets.getPlaceholder(),
            );
          }
          final beacons = _groupCubit.beacons;

          return Container(
              alignment: Alignment.center,
              child: beacons.length == 0
                  ? SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Text(
                            'You haven\'t joined or created any beacon yet',
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: ' a Hike or '),
                                TextSpan(
                                    text: 'Create',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: '  a new one! '),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      physics: AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: beacons.length,
                      padding: EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        if (index == beacons.length) {
                          return _groupCubit.isLoadingMore
                              ? Center(
                                  child: LinearProgressIndicator(
                                  color: kBlue,
                                ))
                              : SizedBox.shrink();
                        }
                        return BeaconCustomWidgets.getBeaconCard(
                            context, beacons[index]);
                      },
                    ));
        },
      ),
    );
  }

  Widget _nearByBeacons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: BlocBuilder<GroupCubit, GroupState>(
        builder: (context, state) {
          if (state is ShrimmerGroupState) {
            return Center(
              child: BeaconCustomWidgets.getPlaceholder(),
            );
          }
          final beacons = _groupCubit.beacons;

          return Container(
              alignment: Alignment.center,
              child: beacons.length == 0
                  ? SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Text(
                            'You haven\'t joined or created any beacon yet',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: kBlack, fontSize: 20),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          RichText(
                            text: TextSpan(
                              // textAlign:
                              //   TextAlign
                              //       .center,
                              style: TextStyle(color: kBlack, fontSize: 20),
                              children: [
                                TextSpan(
                                    text: 'Join',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: ' a Hike or '),
                                TextSpan(
                                    text: 'Create',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: '  a new one! '),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: beacons.length,
                      padding: EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        return BeaconCustomWidgets.getBeaconCard(
                            context, beacons[index]);
                      },
                    ));
        },
      ),
    );
  }
}
