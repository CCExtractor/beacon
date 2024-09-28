import 'dart:io';
import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/presentation/hike/cubit/location_cubit/location_cubit.dart';
import 'package:beacon/presentation/widgets/hike_button.dart';
import 'package:beacon/core/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geocoder_alternative/flutter_geocoder_alternative.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';

class HikeScreenWidget {
  static copyPasskey(String? passkey) {
    Clipboard.setData(ClipboardData(text: passkey!));
    Fluttertoast.showToast(msg: 'PASSKEY: $passkey  COPIED');
  }

  static Geocoder geocoder = Geocoder();

  static generateUrl(String? shortcode) async {
    Uri url = Uri.parse('https://beacon.aadibajpai.com/?shortcode=$shortcode');
    Share.share('To join beacon follow this link: $url');
  }

  static Widget sosButton(String id, BuildContext context) {
    return FloatingActionButton(
      heroTag: 'sos',
      backgroundColor: kYellow,
      onPressed: () {
        locator<LocationCubit>().sendSOS(id, context);
      },
      child: Icon(Icons.sos),
    );
  }

  static Widget shareButton(
      BuildContext context, String? passkey, BeaconEntity beacon) {
    return FloatingActionButton(
      heroTag:
          'shareRouteTag', //had to pass this tag else we would get error since there will be two FAB in the same subtree with the same tag.
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              height: 100.h < 800 ? 40.h : 35.h,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          'Invite Friends',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 3.5.h,
                    ),
                    Flexible(
                      child: HikeButton(
                          buttonHeight: optbheight - 4,
                          textSize: 16,
                          text: 'Generate URL',
                          textColor: Colors.white,
                          buttonColor: kYellow,
                          onTap: () async {
                            generateUrl(passkey);
                          }),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Flexible(
                      child: HikeButton(
                        buttonHeight: optbheight - 4,
                        textSize: 16,
                        text: 'Copy Passkey',
                        textColor: Colors.white,
                        buttonColor: kYellow,
                        onTap: () {
                          copyPasskey(passkey);
                        },
                      ),
                    ),
                    Gap(2.h),
                    Flexible(
                      child: HikeButton(
                        buttonHeight: optbheight - 4,
                        textSize: 16,
                        text: 'Share Image',
                        textColor: Colors.white,
                        buttonColor: kYellow,
                        onTap: () async {
                          appRouter.maybePop();
                          var locationCubit = locator<LocationCubit>();
                          var controller = locationCubit.mapController!;

                          if (!await utils.checkInternetConnectivity()) {
                            utils.showSnackBar(
                                'Cannot share the route, please check your internet connection.',
                                context);
                            return;
                          }

                          // await mapController.showMarkerInfoWindow(MarkerId("1"));

                          final image = await (controller.takeSnapshot());
                          final appDir =
                              await getApplicationDocumentsDirectory();
                          File imageFile =
                              await File('${appDir.path}/shareImage.png')
                                  .create();
                          imageFile.writeAsBytesSync(image!);
                          await Share.shareXFiles([XFile(imageFile.path)],
                              text: 'Location of ${beacon.leader}',
                              subject:
                                  'Current coordinated: ( ${beacon.location?.lat!} ,${beacon.location?.lon} ) \n Address: ${locationCubit.address ?? ''}');
                          //hide after sharing.
                          // await controller.hideMarkerInfoWindow(MarkerId("1"));
                          return;
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
      backgroundColor: kYellow,
      child: Icon(Icons.share),
    );
  }

  static Widget shareRouteButton(
    BuildContext context,
    BeaconEntity? beacon,
    GoogleMapController mapController,
    List<LatLng> beaconRoute,
  ) {
    return FloatingActionButton(
      heroTag: 'shareRouteTag1',
      onPressed: () async {},
      backgroundColor: kYellow,
      child: Icon(
        Icons.share,
      ),
    );
  }

  static final Map<MapType, String> mapTypeNames = {
    MapType.hybrid: 'Hybrid',
    MapType.normal: 'Normal',
    MapType.satellite: 'Satellite',
    MapType.terrain: 'Terrain',
  };

  static MapType _selectedMapType = MapType.normal;

  static Widget showMapViewSelector(BuildContext context) {
    return DropdownButton<MapType>(
      icon: null,
      value: _selectedMapType,
      items: mapTypeNames.entries.map((entry) {
        return DropdownMenuItem(
          onTap: () {
            locator<LocationCubit>().changeMap(entry.key);
          },
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
      onChanged: (newValue) {},
      selectedItemBuilder: (BuildContext context) {
        return mapTypeNames.entries.map((entry) {
          return FloatingActionButton(
            backgroundColor: kYellow,
            onPressed: null,
            child: Icon(CupertinoIcons.map),
          );
        }).toList();
      },
    );
  }

  static TextEditingController _landMarkeController = TextEditingController();
  static GlobalKey<FormState> _landmarkFormKey = GlobalKey<FormState>();

  static void selectionButton(
      BuildContext context, String beaconId, LatLng loc) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: 100.h < 800 ? 33.h : 22.h,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Column(
              children: [
                Gap(10),
                Text(
                  'Create Landmark',
                  style: TextStyle(fontSize: 25),
                ),
                Gap(20),
                HikeButton(
                  text: 'Create Landmark',
                  onTap: () {
                    Navigator.pop(context);
                    showCreateLandMarkDialogueDialog(context, beaconId, loc);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // static GlobalKey<FormState> _geofenceKey = GlobalKey<FormState>();
  // static double _value = 0.1;

  // static void showCreateGeofenceDialogueDialog(
  //   BuildContext context,
  //   String beaconId,
  //   LatLng loc,
  // ) {
  //   bool isSmallSized = 100.h < 800;
  //   bool isGeofenceCreated = false;

  //   showModalBottomSheet(
  //     context: context,
  //     isDismissible: false,
  //     builder: (context) {
  //       return Stack(
  //         children: [
  //           Container(
  //             height: isSmallSized ? 30.h : 25.h,
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.only(
  //                 topLeft: Radius.circular(20),
  //                 topRight: Radius.circular(20),
  //               ),
  //             ),
  //             child: Padding(
  //               padding:
  //                   const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
  //               child: Form(
  //                 key: _geofenceKey,
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Container(
  //                       alignment: Alignment.topRight,
  //                       child: IconButton(
  //                           onPressed: () {
  //                             appRouter.maybePop().then((value) {
  //                               locator<LocationCubit>()
  //                                   .removeUncreatedGeofence();
  //                             });
  //                           },
  //                           icon: Icon(
  //                             Icons.cancel,
  //                             color: kBlue,
  //                           )),
  //                     ),
  //                     StatefulBuilder(
  //                       builder: (context, setState) {
  //                         return Stack(
  //                           children: [
  //                             Slider(
  //                               activeColor: kBlue,
  //                               inactiveColor: kYellow,
  //                               value: _value,
  //                               onChanged: (value) {
  //                                 setState(() {
  //                                   _value = value;
  //                                 });
  //                                 locator<LocationCubit>()
  //                                     .changeGeofenceRadius(_value * 1000, loc);
  //                               },
  //                             ),
  //                             Align(
  //                               alignment: Alignment(1, -1),
  //                               child: Text(
  //                                 '${(_value * 1000).toStringAsFixed(0)} meters',
  //                               ),
  //                             ),
  //                           ],
  //                         );
  //                       },
  //                     ),
  //                     Gap(10),
  //                     Flexible(
  //                       child: HikeButton(
  //                         buttonHeight: 15,
  //                         onTap: () async {
  //                           if (!_geofenceKey.currentState!.validate()) return;
  //                           locator<LocationCubit>()
  //                               .createGeofence(beaconId, loc, _value)
  //                               .then((onvalue) {
  //                             isGeofenceCreated = true;
  //                           });
  //                           appRouter.maybePop().then((onValue) {
  //                             if (isGeofenceCreated) {
  //                               locator<LocationCubit>()
  //                                   .removeUncreatedGeofence();
  //                             }
  //                           });
  //                         },
  //                         text: 'Create Geofence',
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  static void showCreateLandMarkDialogueDialog(
    BuildContext context,
    String beaconId,
    LatLng loc,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height < 800 ? 33.h : 25.h,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Form(
              key: _landmarkFormKey,
              child: Column(
                children: <Widget>[
                  Container(
                    height:
                        MediaQuery.of(context).size.height < 800 ? 14.h : 12.h,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        controller: _landMarkeController,
                        style: TextStyle(fontSize: 20.0),
                        onChanged: (key) {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter title for landmark";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          alignLabelWithHint: true,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Add title for the landmark',
                          hintStyle:
                              TextStyle(fontSize: hintsize, color: hintColor),
                          labelText: 'Title',
                          labelStyle:
                              TextStyle(fontSize: labelsize, color: kYellow),
                        ),
                      ),
                    ),
                    color: kLightBlue,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Flexible(
                    child: HikeButton(
                      text: 'Create Landmark',
                      textSize: 14.0,
                      textColor: Colors.white,
                      buttonColor: kYellow,
                      onTap: () {
                        if (!_landmarkFormKey.currentState!.validate()) return;
                        appRouter.maybePop();
                        locator<LocationCubit>().createLandmark(
                            beaconId, _landMarkeController.text, loc);
                        _landMarkeController.clear();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
