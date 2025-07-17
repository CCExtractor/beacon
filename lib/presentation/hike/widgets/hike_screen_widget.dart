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

// Updated static method to show the dialog
  static void showCreateLandMarkDialogueDialog(
    BuildContext context,
    String beaconId,
    LatLng loc,
  ) {
    showDialog(
      context: context,
      builder: (context) => CreateLandmarkDialog(
        beaconId: beaconId,
        loc: loc,
      ),
    );
  }
}

class CreateLandmarkDialog extends StatefulWidget {
  final String beaconId;
  final LatLng loc;

  const CreateLandmarkDialog({
    Key? key,
    required this.beaconId,
    required this.loc,
  }) : super(key: key);

  @override
  State<CreateLandmarkDialog> createState() => _CreateLandmarkDialogState();
}

class _CreateLandmarkDialogState extends State<CreateLandmarkDialog> {
  final _landmarkFormKey = GlobalKey<FormState>();
  final _landMarkeController = TextEditingController();
  String? _selectedIcon;

  // List of available icons
  final List<String> _iconOptions = [
    'images/icons/camp.png',
    'images/icons/wind.png',
    'images/icons/location-marker.png',
    'images/icons/rain.png',
    'images/icons/forest.png',
    'images/icons/destination.png',
  ];

  @override
  void dispose() {
    _landMarkeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 800;

    return Dialog(
      backgroundColor: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: size.width * 0.85,
        height: isSmallScreen ? size.height * 0.45 : size.height * 0.4,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _landmarkFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Select an icon',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                ),
              ),

              // Icon selection row
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _iconOptions.map((iconPath) {
                  final isSelected = _selectedIcon == iconPath;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIcon = iconPath;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                          width: 2,
                        ),
                        color: isSelected
                            ? Theme.of(context).primaryColor.withOpacity(0.1)
                            : Colors.transparent,
                      ),
                      child: Image.asset(
                        iconPath,
                        width: 40,
                        height: 40,
                      ),
                    ),
                  );
                }).toList(),
              ),

              // Text input field
              Container(
                height: 60,
                margin: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  color: kLightBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextFormField(
                  controller: _landMarkeController,
                  style: const TextStyle(fontSize: 18.0),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter title for landmark";
                    }
                    if (_selectedIcon == null) {
                      return "Please select an icon";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter Landmark Title',
                    labelText: 'Title',
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).primaryColor,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                    alignLabelWithHint: true,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Create button
              HikeButton(
                buttonHeight: 5.5.h,
                buttonWidth: 50.w,
                textSize: 14.0,
                textColor: Colors.white,
                onTap: () {
                  if (!_landmarkFormKey.currentState!.validate()) return;
                  appRouter.maybePop();
                  locator<LocationCubit>().createLandmark(
                      widget.beaconId,
                      _landMarkeController.text.trim(),
                      widget.loc,
                      _selectedIcon!);
                  _landMarkeController.clear();
                },
                text: 'Create Landmark',
              )
            ],
          ),
        ),
      ),
    );
  }
}
