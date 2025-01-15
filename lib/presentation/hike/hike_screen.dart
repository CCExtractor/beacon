import 'package:auto_route/auto_route.dart';
import 'package:beacon/config/pip_manager.dart';
import 'package:beacon/core/utils/constants.dart';
import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/presentation/hike/cubit/hike_cubit/hike_cubit.dart';
import 'package:beacon/presentation/hike/cubit/hike_cubit/hike_state.dart';
import 'package:beacon/presentation/hike/cubit/location_cubit/location_cubit.dart';
import 'package:beacon/presentation/hike/cubit/location_cubit/location_state.dart';
import 'package:beacon/presentation/hike/cubit/panel_cubit/panel_cubit.dart';
import 'package:beacon/presentation/hike/cubit/panel_cubit/panel_state.dart';
import 'package:beacon/presentation/hike/widgets/hike_screen_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_pip_mode/pip_widget.dart';
import 'package:simple_pip_mode/simple_pip.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

@RoutePage()
class HikeScreen extends StatefulWidget {
  final BeaconEntity beacon;
  final bool? isLeader;
  const HikeScreen({super.key, required this.beacon, required this.isLeader});

  @override
  State<HikeScreen> createState() => _HikeScreenState();
}

class _HikeScreenState extends State<HikeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  HikeCubit _hikeCubit = locator<HikeCubit>();
  LocationCubit _locationCubit = locator();

  int value = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _hikeCubit.startHike(widget.beacon.id!, this, context);
    SimplePip().setAutoPipMode(aspectRatio: (2, 3));
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    PIPMode.disablePIPMode();
    _hikeCubit.clear();
    _locationCubit.clear();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {}
  }

  bool isSmallsized = 100.h < 800;
  PanelController _panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PipWidget(
          onPipExited: () {
            _panelController.open();
          },
          builder: (context) {
            return BlocBuilder<HikeCubit, HikeState>(
              builder: (context, state) {
                if (state is InitialHikeState) {
                  return Center(
                      child: SpinKitWave(
                    color: kYellow,
                  ));
                } else if (state is ErrorHikeState) {
                  return Container(
                    child: Center(child: Text('Restart beacon')),
                  );
                } else {
                  return Scaffold(
                      body: Stack(
                    children: [
                      SlidingUpPanel(
                          onPanelOpened: () {
                            setState(() {});
                          },
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15),
                          ),
                          controller: _panelController,
                          maxHeight: 60.h,
                          minHeight: isSmallsized ? 22.h : 20.h,
                          panel: _SlidingPanelWidget(),
                          collapsed: _collapsedWidget(),
                          body: _mapScreen()),
                      Align(
                        alignment: Alignment(-0.9, -0.9),
                        child: FloatingActionButton(
                          heroTag: 'BackButton',
                          backgroundColor: kYellow,
                          onPressed: () {
                            SimplePip().enterPipMode();
                          },
                          child: Icon(
                            CupertinoIcons.back,
                            color: kBlue,
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment(0.85, -0.9),
                          child: HikeScreenWidget.shareButton(
                              context, widget.beacon.shortcode, widget.beacon)),
                      Align(
                          alignment: Alignment(1, -0.7),
                          child: HikeScreenWidget.showMapViewSelector(context)),
                      Align(
                          alignment: Alignment(0.85, -0.5),
                          child: HikeScreenWidget.sosButton(
                              widget.beacon.id!, context)),
                    ],
                  ));
                }
              },
            );
          },
          pipChild: _mapScreen()),
    );
  }

  Widget _mapScreen() {
    return BlocConsumer<LocationCubit, LocationState>(
      listener: (context, state) {
        if (state is LoadedLocationState) {
          state.message != null
              ? utils.showSnackBar(state.message!, context)
              : null;
        }
      },
      builder: (context, state) {
        if (state is InitialLocationState) {
          return SpinKitPianoWave(
            color: kYellow,
          );
        } else if (state is LoadedLocationState) {
          return GoogleMap(
              circles: state.geofence,
              polylines: state.polyline,
              mapType: state.mapType,
              compassEnabled: true,
              onTap: (latlng) {
                _panelController.close();
                HikeScreenWidget.showCreateLandMarkDialogueDialog(
                    context, widget.beacon.id!, latlng);
              },
              zoomControlsEnabled: true,
              onMapCreated: _locationCubit.onMapCreated,
              markers: state.locationMarkers,
              initialCameraPosition: CameraPosition(
                  zoom: 15, target: state.locationMarkers.first.position));
        }
        return Center(
          child: GestureDetector(
            onTap: () {
              appRouter.maybePop();
            },
            child: Text('Something went wrong please try again!'),
          ),
        );
      },
    );
  }

  Widget _collapsedWidget() {
    var beacon = widget.beacon;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: kBlue,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
          ),
        ),
        child: BlocBuilder<PanelCubit, SlidingPanelState>(
          builder: (context, state) {
            return state.when(
              initial: () {
                return SpinKitCircle(color: kYellow);
              },
              loaded: (
                isActive,
                expiringTime,
                leaderAddress,
                leader,
                followers,
                message,
              ) {
                followers = followers ?? [];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Container(
                        alignment: Alignment.center,
                        height: 0.8.h,
                        width: 18.w,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                    Gap(10),
                    Text(
                        isActive == true
                            ? 'Beacon expiring at ${expiringTime ?? '<>'}'
                            : 'Beacon is expired',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: '',
                            fontWeight: FontWeight.w700)),
                    Gap(2),
                    Text('Beacon leader at: ${leaderAddress ?? '<>'}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: '',
                            fontWeight: FontWeight.w600)),
                    Gap(1.5),
                    Text('Total followers: ${followers.length} ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: '',
                            fontWeight: FontWeight.w500)),
                    Gap(1),
                    Text('Share the pass key to join user: ${beacon.shortcode}',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontFamily: '',
                            fontWeight: FontWeight.w500))
                  ],
                );
              },
              error: (message) {
                return Text(message.toString());
              },
            );
          },
        ));
  }

  Widget _SlidingPanelWidget() {
    // return Container();
    return BlocBuilder<PanelCubit, SlidingPanelState>(
      builder: (context, state) {
        return state.when(
          initial: () {
            return CircularProgressIndicator();
          },
          loaded: (
            isActive,
            expiringTime,
            leaderAddress,
            leader,
            followers,
            message,
          ) {
            List<UserEntity> members = [];
            members.add(leader!);
            if (followers != null) {
              followers.forEach((element) {
                members.add(element!);
              });
            }

            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: members.length,
              itemBuilder: (context, index) {
                var member = members[index];
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Gap(10),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: kYellow,
                        child: Icon(
                          Icons.person_2_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      Gap(10),
                      Text(
                        member.name ?? 'Anonymous',
                        style: TextStyle(fontSize: 19),
                      ),
                      Spacer(),
                      Container(
                        height: 40,
                        width: 40,
                        child: FloatingActionButton(
                          backgroundColor: kYellow,
                          onPressed: () async {
                            _locationCubit
                                .changeCameraPosition(member.id ?? '');
                            _panelController.close();
                          },
                          child: Icon(Icons.location_city),
                        ),
                      ),
                      Gap(10),
                    ],
                  ),
                );
              },
            );
          },
          error: (message) {
            return Text(message.toString());
          },
        );
      },
    );
  }
}
