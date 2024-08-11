// import 'dart:async';
// import 'dart:developer';
// import 'package:beacon/config/enviornment_config.dart';
// import 'package:beacon/core/resources/data_state.dart';
// import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
// import 'package:beacon/domain/entities/landmark/landmark_entity.dart';
// import 'package:beacon/domain/entities/location/location_entity.dart';
// import 'package:beacon/domain/entities/user/user_entity.dart';
// import 'package:beacon/domain/usecase/group_usecase.dart';
// import 'package:beacon/domain/usecase/hike_usecase.dart';
// import 'package:beacon/locator.dart';
// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animarker/flutter_map_marker_animation.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:intl/intl.dart';

// abstract class HikeState {
//   final LocationEntity? updatedLocation;
//   final BeaconEntity? updateBeacon;
//   final String? error;

//   HikeState({this.updatedLocation, this.error, this.updateBeacon});
// }

// class InitialHikeState extends HikeState {
//   InitialHikeState() : super();
// }

// class BeaconLoadingState extends HikeState {
//   BeaconLoadingState() : super();
// }

// class BeaconLocationLoaded extends HikeState {
//   final LocationEntity? updatedLocation;

//   BeaconLocationLoaded({required this.updatedLocation})
//       : super(updatedLocation: updatedLocation);
// }

// class BeaconUpdateLoaded extends HikeState {
//   final BeaconEntity? updateBeacon;

//   BeaconUpdateLoaded({required this.updateBeacon})
//       : super(updateBeacon: updateBeacon);
// }

// class BeaconErrorState extends HikeState {
//   final String error;

//   BeaconErrorState({required this.error}) : super(error: error);
// }

// class BeaconLocationError extends HikeState {
//   final String message;
//   BeaconLocationError({required this.message});
// }

// class BeaconReloadState extends HikeState {}

// class MapReloadState extends HikeState {}

// class HikeCubit extends Cubit<HikeState> {
//   final HikeUseCase hikeUsecase;
//   final GroupUseCase groupUseCase;
//   HikeCubit({required this.hikeUsecase, required this.groupUseCase})
//       : super(BeaconLoadingState());

//   bool? isActive;
//   String? time;
//   String? endsAt;
//   LatLng? beaconLeaderLocation;
//   Set<Marker> markers = Set<Marker>();
//   StreamSubscription<Position>? _positionStream;
//   Position? position;
//   Completer<GoogleMapController> mapController =
//       Completer<GoogleMapController>();
//   BeaconEntity? beacon;
//   StreamSubscription<DataState<LocationEntity>>? _locationSubscription;
//   List<UserEntity> members = [];
//   StreamSubscription<DataState<dynamic>>? beaconUpdateStream;
//   List<LatLng> routes = [];

//   Future<void> fetchBeaconDetails(String beaconId, BuildContext context) async {
//     emit(BeaconLoadingState());
//     DataState<BeaconEntity> state =
//         await hikeUsecase.fetchBeaconDetails(beaconId);

//     if (state is DataSuccess && state.data != null) {
//       beacon = state.data!;

//       createLeaderMarker(beacon!.location!);
//       currentAndPrevious.add(LatLng(double.parse(beacon!.location!.lat!),
//           double.parse(beacon!.location!.lon!)));

//       segregateBeaconData(beacon!);

//       beaconUpdateSubscription(beaconId, context);

//       print('landmark length: ${beacon!.landmarks!.length.toString()}');

//       for (var landmark in beacon!.landmarks!) {
//         createLandmarkMarker(landmark!);
//       }

//       // if leader
//       if (beacon!.leader!.id == localApi.userModel.id) {
//         await updateBeaconLocation(beaconId, context);
//       } else {
//         // if follower
//         await beaconLocationSubscription(beaconId, context);
//       }
//       emit(BeaconReloadState());
//     } else {
//       emit(BeaconErrorState(error: state.error!));
//     }
//   }

//   void createLeaderMarker(LocationEntity beaconlocation) {
//     // leader location variable
//     beaconLeaderLocation = LatLng(
//         double.parse(beaconlocation.lat!), double.parse(beaconlocation.lon!));

//     // ripple marker for leader
//     markers.add(RippleMarker(
//         infoWindow: InfoWindow(title: beacon?.leader?.name),
//         ripple: false,
//         markerId: MarkerId(beacon!.leader!.id!),
//         position: beaconLeaderLocation!,
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)));
//   }

//   List<LatLng> currentAndPrevious = [];

//   Future<void> updateBeaconLocation(
//       String beaconId, BuildContext context) async {
//     _positionStream?.cancel();
//     _positionStream = await Geolocator.getPositionStream(
//         locationSettings: LocationSettings(
//       accuracy: LocationAccuracy.high,
//       distanceFilter: 5,
//     )).listen((newPosition) async {
//       utils.showSnackBar('New Position: ', context, top: true, icon: true);

//       routes.add(LatLng(newPosition.latitude, newPosition.latitude));

//       setPolyline();

//       LatLng newCord = LatLng(newPosition.latitude, newPosition.longitude);
//       changeMarkerPosition(newCord);
//       emit(MapReloadState());
//       // await hikeUsecase.updateBeaconLocation(beaconId, newCord);
//     });
//   }

//   Future<void> beaconLocationSubscription(
//       String beaconId, BuildContext context) async {
//     _locationSubscription?.cancel();
//     _locationSubscription = await hikeUsecase
//         .beaconLocationSubscription(beaconId)
//         .listen((dataState) async {
//       if (dataState is DataSuccess && dataState.data != null) {
//         utils.showSnackBar('leader location updated', context);
//         LocationEntity newLocation = dataState.data!;
//         LatLng newPosition = LatLng(
//             double.parse(newLocation.lat!), double.parse(newLocation.lon!));

//         // changing marker position
//         changeMarkerPosition(newPosition);
//         // changing camera position

//         emit(MapReloadState());
//       } else if (dataState is DataFailed) {
//         // log('error while getting subscription: ${dataState.error}');
//       }
//     });
//   }

//   void changeMarkerPosition(LatLng newPosition) {
//     final leaderId = beacon!.leader!.id!;
//     final leaderMarker =
//         markers.firstWhere((element) => element.markerId == MarkerId(leaderId));
//     final updatedMarker = leaderMarker.copyWith(positionParam: newPosition);
//     markers.remove(leaderMarker);
//     markers.add(updatedMarker);
//   }

//   Future<void> segregateBeaconData(BeaconEntity beacon) async {
//     if (beacon.expiresAt! > DateTime.now().millisecondsSinceEpoch) {
//       // adding leaders and followers
//       members.add(beacon.leader!);
//       for (var follower in beacon.followers!) {
//         members.add(follower!);
//       }
//       isActive = true;
//       DateTime expireDate =
//           DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt!);
//       endsAt = DateFormat('hh:mm a, dd/MM/yyyy').format(expireDate);

//       // TODO: Implement address from location
//     } else {
//       isActive = false;
//     }
//   }

//   // creating address from coordinate
//   Future<void> corToAdd(String latitude, String longitude) async {}

//   Future<void> changeCameraPosition(LatLng newPosition) async {
//     // final GoogleMapController controller = await mapController.future;

//     // // new camera position
//     // final CameraPosition newCamera = CameraPosition(
//     //   target: newPosition,
//     //   zoom: 20,
//     // );
//     // await controller.animateCamera(CameraUpdate.newCameraPosition(newCamera));
//   }

//   Future<DataState<BeaconEntity>> joinBeacon(String shortcode) async {
//     return await groupUseCase.joinHike(shortcode);
//   }

//   Future<void> beaconUpdateSubscription(
//       String beaconId, BuildContext context) async {
//     beaconUpdateStream?.cancel();
//     beaconUpdateStream = await hikeUsecase
//         .beaconUpdateSubscription(beaconId)
//         .listen((dataState) {
//       if (dataState is DataSuccess) {
//         if (dataState.data is UserEntity) {
//           final user = dataState.data as UserEntity;
//           members.add(user);
//           utils.showSnackBar(
//               '${user.name} is now following the beacon!', context,
//               top: true, icon: true);

//           emit(BeaconReloadState());
//         } else if (dataState.data is LandMarkEntity) {
//           createLandmarkMarker(dataState.data!);
//           utils.showSnackBar('New landmark created', context);
//           emit(MapReloadState());
//         }
//       } else if (dataState is DataFailed) {}
//     });
//   }

//   void createLandmarkMarker(LandMarkEntity landMark) {
//     markers.add(Marker(
//         infoWindow: InfoWindow(title: landMark.title),
//         markerId: MarkerId(landMark.id!),
//         position: LatLng(double.parse(landMark.location!.lat!),
//             double.parse(landMark.location!.lon!)),
//         icon:
//             BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)));
//   }

//   Future<void> createLandMark(
//       String id, String title, String lat, String lon) async {
//     final state = await hikeUsecase.createLandMark(id, title, lat, lon);

//     if (state is DataSuccess) {
//       // log('new marker created');
//       // createLandmarkMarker(state.data!);
//       // emit(MapReloadState());
//     } else {
//       // showing error
//     }
//   }

//   @override
//   Future<void> close() {
//     _locationSubscription?.cancel();
//     _positionStream?.cancel();
//     return super.close();
//   }

//   List<LatLng> polylineCoordinates = [];
//   Set<Polyline> polylines = Set<Polyline>();

//   Future<void> setPolyline() async {
//     PolylinePoints polylinePoints = PolylinePoints();

//     PolylineResult? result = await polylinePoints.getRouteBetweenCoordinates(
//       EnvironmentConfig.googleMapApi!, // Google Maps API Key
//       PointLatLng(routes.first.latitude, routes.first.longitude),
//       PointLatLng(routes.last.latitude, routes.last.longitude),
//     );

//     log('result: ${result.points.length.toString()}');

//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     }

//     Polyline polyline = Polyline(
//       polylineId: PolylineId('poly'),
//       color: Colors.red,
//       points: polylineCoordinates,
//       width: 3,
//     );
//     polylines.add(polyline);
//   }

//   MapType mapType = MapType.normal;

//   void changeMapType(MapType newMapType) {
//     mapType = newMapType;
//     emit(MapReloadState());
//   }

//   clear() {
//     beaconUpdateStream?.cancel();
//     _locationSubscription?.cancel();
//     members.clear();
//     _positionStream?.cancel();
//     markers.clear();
//     beaconLeaderLocation = null;
//     isActive = null;
//     time = null;
//     endsAt = null;
//   }
// }

import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/domain/usecase/hike_usecase.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/presentation/hike/cubit/hike_cubit/hike_state.dart';
import 'package:beacon/presentation/hike/cubit/location_cubit/location_cubit.dart';
import 'package:beacon/presentation/hike/cubit/panel_cubit/panel_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';

class HikeCubit extends Cubit<HikeState> {
  final HikeUseCase _hikeUseCase;
  HikeCubit._internal(this._hikeUseCase) : super(LoadedHikeState());

  static HikeCubit? _instance;

  factory HikeCubit(HikeUseCase hikeUseCase) {
    return _instance ?? HikeCubit._internal(hikeUseCase);
  }

  BeaconEntity? _beacon;
  String? _beaconId;

  Future<void> startHike(String beaconId) async {
    emit(InitialHikeState());
    _beaconId = beaconId;
    final dataState = await _hikeUseCase.fetchBeaconDetails(beaconId);

    if (dataState is DataSuccess && dataState.data != null) {
      final beacon = dataState.data!;
      _beacon = beacon;

      locator<LocationCubit>().loadBeaconData(beacon);
      locator<PanelCubit>().loadBeaconData(beacon);
      emit(LoadedHikeState(beacon: _beacon, message: 'Welcome to hike!'));
    } else {
      emit(ErrorHikeState(errmessage: dataState.error));
    }
  }

  clear() {
    _beacon = null;
    _beaconId = null;
  }
}
