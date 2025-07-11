import 'package:auto_route/auto_route.dart';
import 'package:beacon/config/pip_manager.dart';
import 'package:beacon/core/utils/constants.dart';
import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/presentation/auth/auth_cubit/auth_cubit.dart';
import 'package:beacon/presentation/hike/cubit/hike_cubit/hike_cubit.dart';
import 'package:beacon/presentation/hike/cubit/hike_cubit/hike_state.dart';
import 'package:beacon/presentation/hike/cubit/location_cubit/location_cubit.dart';
import 'package:beacon/presentation/hike/cubit/location_cubit/location_state.dart';

import 'package:beacon/presentation/hike/widgets/hike_screen_widget.dart';
import 'package:beacon/presentation/hike/widgets/search_places.dart';
import 'package:beacon/presentation/widgets/hike_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
                      appBar: AppBar(
                        backgroundColor: Colors.grey[50],
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back_ios_new,
                              size: 20, color: Colors.grey),
                          onPressed: () {
                            _panelController.close();
                            appRouter.maybePop();
                          },
                        ),
                        centerTitle: true,
                        title: Image.asset(
                          'images/beacon_logo.png',
                          height: 28,
                        ),
                        actions: [
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
                                        title: Text('Logout',
                                            style: Style.heading),
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
                      body: Stack(
                        children: [
                          _mapScreen(),
                          LocationSearchWidget(widget.beacon.id!),
                          Positioned(
                            bottom: 200,
                            right: 10,
                            child: Column(
                              children: [
                                FloatingActionButton(
                                  backgroundColor: Colors.white,
                                  mini: true,
                                  onPressed: () => _locationCubit.zoomIn(),
                                  child: Icon(Icons.add),
                                ),
                                //SizedBox(height: 2),
                                FloatingActionButton(
                                  backgroundColor: Colors.white,
                                  mini: true,
                                  onPressed: () => _locationCubit.zoomOut(),
                                  child: Icon(Icons.remove),
                                ),
                                SizedBox(height: 2),
                                FloatingActionButton(
                                  backgroundColor: Colors.white,
                                  mini: true,
                                  onPressed: () => _locationCubit.centerMap(),
                                  child: Icon(Icons.map),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 100,
                              child: Container(
                                height: 100,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Left Circular Icon Button
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 4,
                                            ),
                                          ],
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://media.istockphoto.com/id/1253926432/vector/flashlight-warning-alarm-light-and-siren-light-flat-design-vector-design.jpg?s=612x612&w=0&k=20&c=yOj6Jpu7XDrPJCTfUIpQm-LWI9q9RWQB91s-N7CgQDQ="))),
                                    ),

                                    const SizedBox(width: 10),

                                    // Right Red SOS Button
                                    HikeButton(
                                      buttonWidth: 70.w,
                                      buttonHeight: 50,
                                      text: 'Send SOS',
                                      onTap: () {
                                        locator<LocationCubit>().sendSOS(
                                            widget.beacon.id!, context);
                                      },
                                      textSize: 18.0,
                                      buttonColor: Colors.red,
                                      textColor: Colors.white,
                                    )
                                  ],
                                ),
                              )),
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
          print('Location State: ${state.locationMarkers.length}');
          return GoogleMap(
            circles: state.geofence,
            polylines: state.polyline,
            trafficEnabled: true,
            mapType: MapType.normal,
            onLongPress: (latlng) {
              HikeScreenWidget.showCreateLandMarkDialogueDialog(
                context,
                widget.beacon.id!,
                latlng,
              );
            },
            onMapCreated: _locationCubit.onMapCreated,
            markers: state.locationMarkers,
            initialCameraPosition: CameraPosition(
              zoom: 15,
              target: state.locationMarkers.first.position,
            ),
          );
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
}
