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
import 'package:sliding_up_panel/sliding_up_panel.dart';

@RoutePage()
class HikeScreen extends StatefulWidget {
  final BeaconEntity beacon;
  final bool? isLeader;
  const HikeScreen({super.key, required this.beacon, required this.isLeader});

  @override
  State<HikeScreen> createState() => _HikeScreenState();
}

class _HikeScreenState extends State<HikeScreen> with WidgetsBindingObserver {
  HikeCubit _hikeCubit = locator<HikeCubit>();
  LocationCubit _locationCubit = locator();
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    PIPMode.switchPIPMode();
    _hikeCubit.startHike(widget.beacon.id!);
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

  bool isSmallsized = 100.h < 800;
  PanelController _panelController = PanelController();

  bool _isPipMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isPipMode
          ? Container()
          : BlocBuilder<HikeCubit, HikeState>(
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
                          controller: _panelController,
                          maxHeight: 60.h,
                          minHeight: isSmallsized ? 22.h : 18.h,
                          panel: _SlidingPanelWidget(),
                          collapsed: _collapsedWidget(),
                          body: BlocConsumer<LocationCubit, LocationState>(
                            listener: (context, state) {
                              if (state is LoadedLocationState) {
                                state.message != null
                                    ? utils.showSnackBar(
                                        state.message!, context)
                                    : null;
                              }
                            },
                            builder: (context, state) {
                              if (state is InitialLocationState) {
                                return SpinKitPianoWave();
                              } else if (state is LoadedLocationState) {
                                return GoogleMap(
                                    polylines: state.polyline,
                                    mapType: state.mapType,
                                    compassEnabled: true,
                                    onTap: (latlng) {
                                      HikeScreenWidget.selectionButton(
                                          context, widget.beacon.id!, latlng);
                                    },
                                    zoomControlsEnabled: true,
                                    onMapCreated: _locationCubit.onMapCreated,
                                    markers: state.locationMarkers,
                                    initialCameraPosition: CameraPosition(
                                        zoom: 15,
                                        target: state
                                            .locationMarkers.first.position));
                              }
                              return Container();
                            },
                          )),
                      Align(
                        alignment: Alignment(-0.9, -0.9),
                        child: FloatingActionButton(
                          heroTag: 'BackButton',
                          backgroundColor: kYellow,
                          onPressed: () {
                            PIPMode.enterPIPMode();
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
                              context, widget.beacon.shortcode)),
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
            ),
    );
  }

  Widget _collapsedWidget() {
    var beacon = widget.beacon;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          color: kBlue,
        ),
        child: BlocBuilder<PanelCubit, SlidingPanelState>(
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
                followers = followers ?? [];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Container(
                        alignment: Alignment.center,
                        height: 0.5.h,
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
                    Text('Beacon leader at: <>',
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: '',
                            fontWeight: FontWeight.w600)),
                    Text('Total followers: ${followers.length} ',
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontFamily: '',
                            fontWeight: FontWeight.w500)),
                    Text('Share the pass key to join user: ${beacon.shortcode}',
                        style: TextStyle(
                            fontSize: 16,
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
            return Column(
              children: [
                Gap(10),
                Container(
                  height: 1.h,
                  width: 20.w,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                Gap(10),
                Expanded(
                  child: ListView.builder(
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
                                onPressed: () async {},
                                child: Icon(Icons.location_city),
                              ),
                            ),
                            Gap(10),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
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
