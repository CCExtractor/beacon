import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:beacon/Bloc/core/constants/location.dart';
import 'package:beacon/Bloc/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/Bloc/domain/usecase/hike_usecase.dart';
import 'package:beacon/Bloc/presentation/cubit/hike_cubit.dart';
import 'package:beacon/old/components/loading_screen.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/old/components/view_model/hike_screen_model.dart';
import 'package:beacon/old/components/views/base_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'package:beacon/old/components/hike_screen_widget.dart';
import 'package:beacon/old/components/models/beacon/beacon.dart';

import 'package:beacon/old/components/utilities/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:sizer/sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// @RoutePage()
// class HikeScreen extends StatefulWidget {
//   final Beacon? beacon;
//   final bool? isLeader;
//   HikeScreen(this.beacon, {this.isLeader});
//   @override
//   _HikeScreenState createState() => _HikeScreenState();
// }

// class _HikeScreenState extends State<HikeScreen> {
//   late double screenHeight, screenWidth;
//   @override
//   Widget build(BuildContext context) {
//     screenHeight = MediaQuery.of(context).size.height;
//     screenWidth = MediaQuery.of(context).size.width;
//     return BaseView<HikeScreenViewModel>(
//       onModelReady: (m) {
//         m.initialise(widget.beacon!, widget.isLeader);
//       },
//       builder: (ctx, model, child) {
//         if (!model.modelIsReady) {
//           return Scaffold(
//             body: Center(
//               child: LoadingScreen(),
//             ),
//           );
//         }
//         // ignore: deprecated_member_use
//         return WillPopScope(
//           onWillPop: () => model.onWillPop(context),
//           child: Scaffold(
//             body: SafeArea(
//               child: ModalProgressHUD(
//                 inAsyncCall: model.isGeneratingLink || model.isBusy,
//                 child: SlidingUpPanel(
//                   maxHeight: 60.h,
//                   minHeight: 20.h,
//                   borderRadius: BorderRadius.only(
//                     topRight: Radius.circular(10),
//                     topLeft: Radius.circular(10),
//                   ),
//                   controller: model.panelController,
//                   collapsed: Container(
//                     decoration: BoxDecoration(
//                       color: kBlue,
//                       borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(10),
//                         topLeft: Radius.circular(10),
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         SizedBox(
//                           height: 1.5.h,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             Container(
//                               width: 65,
//                               height: 5,
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[300],
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(12.0),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 1.5.h,
//                         ),
//                         Container(
//                           width: double.infinity,
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 15),
//                             child: RichText(
//                               text: TextSpan(
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                                 children: [
//                                   TextSpan(
//                                     text: model.isBeaconExpired
//                                         ? 'Beacon has been expired\n'
//                                         : 'Beacon expiring at ${widget.beacon!.expiresAt == null ? '<Fetching data>' : DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(widget.beacon!.expiresAt!)).toString()}\n',
//                                     style: TextStyle(fontSize: 18),
//                                   ),
//                                   TextSpan(
//                                     text:
//                                         'Beacon holder at: ${model.address}\n',
//                                     style: TextStyle(fontSize: 14),
//                                   ),
//                                   TextSpan(
//                                     text:
//                                         'Total Followers: ${model.hikers.length - 1} (Swipe up to view the list of followers)\n',
//                                     style: TextStyle(fontSize: 12),
//                                   ),
//                                   TextSpan(
//                                     text: model.isBeaconExpired
//                                         ? ''
//                                         : 'Share this passkey to add user: ${widget.beacon!.shortcode}\n',
//                                     style: TextStyle(fontSize: 12),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           height: 15.h,
//                         ),
//                       ],
//                     ),
//                   ),
//                   panel: HikeScreenWidget.panel(
//                       model.scrollController, model, context, widget.isLeader!),
//                   body: Stack(
//                     alignment: Alignment.topCenter,
//                     children: <Widget>[
//                       Animarker(
//                         rippleColor: Colors.redAccent,
//                         rippleRadius: 0.01,
//                         useRotation: true,
//                         mapId: model.mapController.future.then<int>(
//                           (value) => value.mapId,
//                         ),
//                         markers: model.markers.toSet(),
//                         // child: Text('hello'),
//                         child: GoogleMap(
//                             compassEnabled: true,
//                             mapType: MapType.terrain,
//                             polylines: model.polylines,
//                             initialCameraPosition: CameraPosition(
//                                 target: LatLng(
//                                   double.parse(widget.beacon!.location!.lat!),
//                                   double.parse(widget.beacon!.location!.lon!),
//                                 ),
//                                 zoom: CAMERA_ZOOM,
//                                 tilt: CAMERA_TILT,
//                                 bearing: CAMERA_BEARING),
//                             onMapCreated: (GoogleMapController controller) {
//                               setState(() {
//                                 model.mapController.complete(controller);
//                               });
//                               // setPolyline();
//                             },
//                             onTap: (loc) async {
//                               // if (model.panelController.isPanelOpen)
//                               //   model.panelController.close();
//                               // else {
//                               //   String? title;
//                               //   HikeScreenWidget
//                               //       .showCreateLandMarkDialogueDialog(
//                               //     context,
//                               //     model.landmarkFormKey,
//                               //     title,
//                               //     loc,
//                               //     model.createLandmark,

//                               //   );
//                               // }
//                             }),
//                       ),
//                       Align(
//                           alignment: Alignment(0.9, -0.98),
//                           child: model.isBeaconExpired
//                               ? Container()
//                               : HikeScreenWidget.shareButton(
//                                   context, widget.beacon!.shortcode)),
//                       Align(
//                         alignment: Alignment(-0.9, -0.98),
//                         child: FloatingActionButton(
//                           onPressed: () {
//                             navigationService!.pop();
//                           },
//                           backgroundColor: kYellow,
//                           child: Icon(
//                             Icons.arrow_back,
//                             size: 35,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       if (!model.isBeaconExpired)
//                         //show the routeSharebutton only when beacon is active(?) and mapcontroller is ready.
//                         Align(
//                           alignment: screenHeight > 800
//                               ? Alignment(0.9, -0.8)
//                               : Alignment(0.9, -0.77),
//                           child: AnimatedOpacity(
//                             duration: Duration(milliseconds: 500),
//                             opacity:
//                                 model.mapController.isCompleted ? 1.0 : 0.0,
//                             child: HikeScreenWidget.shareRouteButton(context,
//                                 model.beacon, model.mapController, model.route),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // void relayBeacon(User newHolder) {
//   //   Fluttertoast.showToast(msg: 'Beacon handed over to $newHolder');
//   // }
// }

@RoutePage()
class HikeScreen extends StatefulWidget {
  final BeaconEntity beacon;
  final bool? isLeader;
  const HikeScreen({super.key, required this.beacon, required this.isLeader});

  @override
  State<HikeScreen> createState() => _HikeScreenState();
}

class _HikeScreenState extends State<HikeScreen> {
  late HikeCubit _hikeCubit;

  @override
  void initState() {
    _hikeCubit = context.read<HikeCubit>();
    _hikeCubit.updateBeaconLocation(widget.beacon.id!, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: SafeArea(
    //     child: SlidingUpPanel(
    //         panel: Center(
    //           child: Text("This is the sliding Widget"),
    //         ),
    //         collapsed: Container(
    //           decoration: BoxDecoration(
    //               color: kBlue,
    //               borderRadius: BorderRadius.only(
    //                   topLeft: Radius.circular(10),
    //                   topRight: Radius.circular(10))),
    //           child: Column(
    //             children: [
    //               SizedBox(
    //                 height: 1.5.h,
    //               ),
    //               Container(
    //                 height: 0.7.h,
    //                 width: 20.w,
    //                 decoration: BoxDecoration(
    //                     color: Colors.blueGrey,
    //                     borderRadius: BorderRadius.all(Radius.circular(10))),
    //               ),
    //               SizedBox(
    //                 height: 1.5.h,
    //               ),
    //               Container(
    //                 width: double.infinity,
    //                 child: Padding(
    //                   padding: const EdgeInsets.symmetric(horizontal: 15),
    //                   child: RichText(
    //                     text: TextSpan(
    //                       style: TextStyle(fontWeight: FontWeight.bold),
    //                       children: [],
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         // body: Center(
    //         //   child: GoogleMap(
    //         //       initialCameraPosition: CameraPosition(target: LatLng(1, 2))),
    //         // ),
    //         borderRadius: BorderRadius.only(
    //             topLeft: Radius.circular(10), topRight: Radius.circular(10))),
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(
          title: IconButton(
              onPressed: () async {
                //  await  _hikeCubit.updateBeaconLocation(widget.beacon.id!, context);

                locator<HikeUseCase>().updateBeaconLocation(widget.beacon.id!,
                    await LocationService.getCurrentLocation());
              },
              icon: Icon(Icons.add))),
      body: BlocBuilder<HikeCubit, HikeState>(
        builder: (context, state) {
          return Text(
              'location: ${state.location.toString()}: eroor: ${state.error.toString()}');
        },
      ),
    );
  }
}
