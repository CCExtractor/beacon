import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/core/utils/constants.dart';
import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/domain/entities/landmark/landmark_entity.dart';
import 'package:beacon/domain/entities/location/location_entity.dart';
import 'package:beacon/domain/entities/subscriptions/beacon_locations_entity/beacon_locations_entity.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:beacon/domain/usecase/hike_usecase.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/presentation/hike/cubit/location_cubit/location_state.dart';
import 'package:beacon/presentation/hike/cubit/panel_cubit/panel_cubit.dart';
import 'package:beacon/presentation/widgets/custom_label_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animarker/core/ripple_marker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:vibration/vibration.dart';

class LocationCubit extends Cubit<LocationState> {
  final HikeUseCase _hikeUseCase;
  LocationCubit._internal(this._hikeUseCase) : super(InitialLocationState());

  static LocationCubit? _instance;

  factory LocationCubit(HikeUseCase hikeUseCase) {
    return _instance ?? LocationCubit._internal(hikeUseCase);
  }

  String? _beaconId;
  BeaconEntity? _beacon;
  GoogleMapController? mapController;
  Set<Marker> _hikeMarkers = {};
  UserEntity? _currentUser;
  UserEntity? _leader;
  List<UserEntity?> _followers = [];
  Set<Polyline> _polyline = {};
  String? _currentUserId;
  List<LatLng> _points = [];
  String? address;
  LocationData? _lastLocation;
  Set<Circle> _geofence = {};
  MapType _mapType = MapType.normal;

  StreamSubscription<DataState<BeaconLocationsEntity>>?
      _beaconlocationsSubscription;
  StreamSubscription<LocationData>? _streamLocaitonData;

  late AnimationController? _controller;
  late Animation<double>? _animation;
  BuildContext? context;
  TickerProvider? vsync;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> loadBeaconData(
      BeaconEntity beacon, TickerProvider vsync, BuildContext context) async {
    this.vsync = vsync;
    this.context = context;
    emit(InitialLocationState());
    _beaconId = beacon.id!;
    _beacon = beacon;

    _currentUserId = localApi.userModel.id!;

    getLeaderAddress(locationToLatLng(beacon.leader!.location!));

    // // adding leader location
    if (beacon.leader != null) {
      _leader = beacon.leader!;

      // creating leader location

      if (_currentUserId == _leader!.id) {
        _currentUser = _leader;
      }
      if (_leader!.location != null) {
        _hikeMarkers.add(RippleMarker(
            markerId: MarkerId(_leader!.id!),
            position: locationToLatLng(_leader!.location!),
            ripple: false,
            infoWindow: InfoWindow(
              title: '${_beacon!.leader?.name ?? 'Anonymous'}}',
            ),
            onTap: () {
              log('${beacon.leader?.name}');
            }));
      }
    }
    // adding members location
    if (beacon.followers != null) {
      for (var follower in beacon.followers!) {
        if (_currentUserId == follower!.id) {
          _currentUser = follower;
        }
        _followers.add(follower);
        if (follower.location != null) {
          _createUserMarker(follower);
        }
      }
    }

    if (beacon.route != null) {
      var marker = Marker(
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          markerId: MarkerId('leader initial position'),
          position: locationToLatLng(beacon.route!.first!));

      _hikeMarkers.add(marker);

      // handling polyline here
      for (var point in beacon.route!) {
        _points.add(locationToLatLng(point!));
      }
      _polyline.add(Polyline(
          polylineId: PolylineId('leader path'),
          color: kYellow,
          width: 5,
          points: _points));
    }

    // // adding landmarks
    if (beacon.landmarks != null) {
      for (var landmark in beacon.landmarks!) {
        await _createLandMarkMarker(landmark!);
      }
    }

    await locationUpdateSubscription(beacon.id!);
    await _getlocation();

    emit(LoadedLocationState(
        polyline: _polyline,
        geofence: _geofence,
        locationMarkers: _hikeMarkers,
        mapType: _mapType,
        message: 'Welcome to hike!'));
  }

  Future<void> _getlocation() async {
    if (_streamLocaitonData != null) {
      _streamLocaitonData!.cancel();
    }

    Location location = new Location();
    location.changeSettings(
        interval: 5000, accuracy: LocationAccuracy.high, distanceFilter: 0);

    _streamLocaitonData =
        location.onLocationChanged.listen((LocationData newPosition) async {
      var latLng = locationDataToLatLng(newPosition);

      if (_lastLocation == null) {
        _lastLocation = newPosition;
        _points.add(latLng);
      } else {
        final distance = await locationService.calculateDistance(
          latLng,
          locationDataToLatLng(_lastLocation!),
        );

        if (distance < 10) {
          return;
        }
        // is Leader

        if (_beacon!.leader!.id == localApi.userModel.id) {
          _lastLocation = newPosition;
          var updatedUser = _currentUser!
              .copywith(location: locationDataToLocationEntity(newPosition));
          _currentUser = updatedUser;
          _points.add(latLng);
          var newPolyline = await setPolyline();
          log('existes: $newPolyline');
          if (newPolyline == false) return;

          getLeaderAddress(latLng);
          _hikeUseCase.changeUserLocation(_beaconId!, latLng);
        }
        // is follower
        else {
          _lastLocation = newPosition;
          var updatedUser = _currentUser!
              .copywith(location: locationDataToLocationEntity(newPosition));
          _currentUser = updatedUser;
          // updating location of marker
          _createUserMarker(_currentUser!);

          _hikeUseCase.changeUserLocation(_beaconId!, latLng);
        }

        emit(LoadedLocationState(
          geofence: _geofence,
          locationMarkers: _hikeMarkers,
          polyline: _polyline,
          version: DateTime.now().millisecondsSinceEpoch,
          mapType: _mapType,
        ));
      }
    });
  }

  Future<bool> setPolyline() async {
    PolylinePoints polylinePoints = PolylinePoints();
    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          'AIzaSyBdIpiEfBE5DohHgBvwPTljZQAcNWcKwCs',
          PointLatLng(_points.first.latitude, _points.first.longitude),
          PointLatLng(_points.last.longitude, _points.last.longitude));

      log(result.toString());

      if (result.points.isNotEmpty) {
        _polyline.clear();
        _polyline.add(Polyline(
            polylineId: PolylineId('leader path'),
            points: pointLatLngToLatLng(result.points),
            width: 5,
            color: kYellow));

        emit(LoadedLocationState(
          geofence: _geofence,
          locationMarkers: _hikeMarkers,
          polyline: _polyline,
          version: DateTime.now().millisecondsSinceEpoch,
          mapType: _mapType,
        ));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log('plyresult: $e');
      return false;
    }
  }

  List<LatLng> pointLatLngToLatLng(List<PointLatLng> pointLatLngs) {
    List<LatLng> newpoints = [];

    for (var pointLatLng in pointLatLngs) {
      newpoints.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
    }

    return newpoints;
  }

  void changeCameraPosition(String id) {
    var marker = _hikeMarkers.where((marker) => marker.markerId.value == id);
    if (marker.isEmpty) return;
    mapController!.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: marker.first.position, zoom: 15)));
  }

  void focusUser(String userId) {
    LatLng? latlng;
    if (userId == _leader!.id) {
      latlng = locationToLatLng(_leader!.location!);
    } else {
      _followers.forEach((element) {
        if (element!.id == userId) {
          latlng = locationToLatLng(element.location!);
        }
      });
    }

    mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latlng!, zoom: 100)));
  }

  LatLngBounds calculateMapBoundsFromListOfLatLng(List<LatLng> pointsList,
      {double padding = 0.0005}) {
    double southWestLatitude = 90;
    double southWestLongitude = 90;
    double northEastLatitude = -180;
    double northEastLongitude = -180;
    pointsList.forEach((point) {
      if (point.latitude < southWestLatitude) {
        southWestLatitude = point.latitude;
      }
      if (point.longitude < southWestLongitude) {
        southWestLongitude = point.longitude;
      }
      if (point.latitude > northEastLatitude) {
        northEastLatitude = point.latitude;
      }
      if (point.longitude > northEastLongitude) {
        northEastLongitude = point.longitude;
      }
    });
    southWestLatitude = southWestLatitude - padding;
    southWestLongitude = southWestLongitude - padding;
    northEastLatitude = northEastLatitude + padding;
    northEastLongitude = northEastLongitude + padding;
    LatLngBounds bound = LatLngBounds(
        southwest: LatLng(southWestLatitude, southWestLongitude),
        northeast: LatLng(northEastLatitude, northEastLongitude));
    return bound;
  }

  Future<void> locationUpdateSubscription(String beaconId) async {
    _beaconlocationsSubscription?.cancel();

    _beaconlocationsSubscription = _hikeUseCase
        .beaconlocationsSubscription(beaconId)
        .listen((dataState) async {
      if (dataState is DataSuccess && dataState.data != null) {
        BeaconLocationsEntity beaconLocationsEntity = dataState.data!;

        // when new landmark is created
        if (beaconLocationsEntity.landmark != null) {
          LandMarkEntity newLandMark = beaconLocationsEntity.landmark!;

          await _createLandMarkMarker(newLandMark);

          emit(LoadedLocationState(
              polyline: _polyline,
              locationMarkers: _hikeMarkers,
              mapType: _mapType,
              geofence: _geofence,
              version: DateTime.now().millisecond,
              message:
                  'A landmark is created by ${beaconLocationsEntity.landmark!.createdBy!.name ?? 'Anonymous'}'));
        }
        // when new position of user detected
        else if (beaconLocationsEntity.user != null) {
          // location of follower
          UserEntity userlocation = beaconLocationsEntity.user!;

          _createUserMarker(userlocation);

          emit(LoadedLocationState(
              polyline: _polyline,
              geofence: _geofence,
              locationMarkers: _hikeMarkers,
              mapType: _mapType,
              version: DateTime.now().microsecond));
          // add marker for user
        }

        // when new route recieved

        else if (beaconLocationsEntity.route != null) {
          log('getting new route');
          _points.clear();
          for (var route in beaconLocationsEntity.route!) {
            if (route == null) {
              log('route is null');
            } else {
              _points.add(locationToLatLng(route));
            }
          }

          log('points len: ${_points.length.toString()}');

          _polyline.add(Polyline(
              polylineId: PolylineId('leader path'),
              points: _points,
              width: 5,
              color: kYellow));

          var markers = _hikeMarkers
              .where((marker) => marker.markerId.value == _leader!.id)
              .toList();

          if (markers.isEmpty) {
            _hikeMarkers.add(Marker(
                markerId: MarkerId(_beacon!.leader!.id.toString()),
                position: _points.last));
          }
          var leaderRipplingMarker = markers.first;

          _hikeMarkers.remove(leaderRipplingMarker);

          var newMarker =
              leaderRipplingMarker.copyWith(positionParam: _points.last);

          _hikeMarkers.add(newMarker);

          // finding initial position marker of route

          var initialMarkers = _hikeMarkers.where(
              (marker) => marker.markerId.value == 'leader initial position');

          if (initialMarkers.isEmpty) {
            _hikeMarkers.add(RippleMarker(
                markerId: MarkerId('leader initial position'),
                ripple: false,
                infoWindow: InfoWindow(title: 'Leader initial position'),
                position: _points.first));
          }

          mapController!.animateCamera(CameraUpdate.newLatLngBounds(
              calculateMapBoundsFromListOfLatLng(_points), 50));

          emit(LoadedLocationState(
              geofence: _geofence,
              locationMarkers: _hikeMarkers,
              mapType: _mapType,
              polyline: _polyline,
              version: DateTime.now().millisecondsSinceEpoch));
        } else if (beaconLocationsEntity.userSOS != null) {
          var user = beaconLocationsEntity.userSOS!;

          ScaffoldMessenger.of(context!).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 5),
              content: Row(
                children: [
                  Image.asset(
                    'images/male_avatar.png',
                    height: 35,
                  ),
                  Gap(10),
                  Text(
                    '${user.name ?? 'Anonymous'} might be in trouble!',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        mapController?.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                                target: locationToLatLng(user.location!),
                                zoom: 15)));
                      },
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ))
                ],
              ),
              backgroundColor: kLightBlue.withValues(alpha: 0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              margin:
                  EdgeInsets.only(top: 0, right: 10, left: 10, bottom: 85.h),
              behavior: SnackBarBehavior.floating,
              elevation: 5,
            ),
          );
          var sosUser = beaconLocationsEntity.userSOS!;
          startAnimation(sosUser);

          vibrateWithPattern();

          // var marker = _hikeMarkers
          //     .firstWhere((marker) => marker.markerId.value == user!.id);

          // _hikeMarkers
          //     .removeWhere((hmarker) => hmarker.markerId == marker.markerId);
        }
      }
    });
  }

  void vibrateWithPattern() async {
    if (await Vibration.hasVibrator() == true) {
      Vibration.vibrate(
        pattern: [500, 1000, 500, 2000], // Vibration pattern
        intensities: [128, 255, 128, 255], // Optional intensities
      );
    }
  }

  void startAnimation(UserEntity user) {
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: vsync!,
    );

    // Define the radius animation with CurvedAnimation
    _animation = Tween<double>(begin: 10, end: 100).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        _updateCircleRadius(user);

        emit(LoadedLocationState(
            geofence: circles,
            locationMarkers: _hikeMarkers,
            mapType: _mapType,
            polyline: _polyline,
            version: DateTime.now().microsecondsSinceEpoch));
      });

    // Start the animation
    _controller!.repeat(reverse: true);
    Future.delayed((Duration(seconds: 10)), () {
      circles.clear();
      _controller?.stop();
      emit(LoadedLocationState(
          geofence: circles,
          locationMarkers: _hikeMarkers,
          mapType: _mapType,
          polyline: _polyline,
          version: DateTime.now().microsecond));
    });
  }

  void _updateCircleRadius(UserEntity user) {
    circles = _buildRipplingCircles(user).toSet();
  }

  Set<Circle> circles = {};
  List<Circle> _buildRipplingCircles(UserEntity user) {
    var circleList = List.generate(3, (index) {
      final double radius = _animation!.value - (index * 8);
      return Circle(
        circleId: CircleId('rippleCircle$index'),
        center: locationToLatLng(user.location!),
        radius: radius < 0 ? 0 : radius,
        fillColor: Colors.red.withValues(alpha: (0.5).clamp(0.0, 1.0)),
        strokeColor: Colors.red.withValues(alpha: 0.5),
        strokeWidth: 2,
      );
    });

    circleList.add(Circle(
      circleId: CircleId('rippleCirclex'),
      center: locationToLatLng(user.location!),
      radius: 10,
      fillColor: Colors.red,
      strokeColor: Colors.red,
      strokeWidth: 2,
    ));
    return circleList;
  }

  stopAnimation() {
    _controller?.stop();
    circles.clear();
    emit(LoadedLocationState(
        geofence: _geofence,
        locationMarkers: _hikeMarkers,
        mapType: _mapType,
        polyline: _polyline,
        version: DateTime.now().microsecondsSinceEpoch));
  }

  Future<void> getLeaderAddress(LatLng latlng) async {
    try {
      log('leader func');
      var headers = {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
      };
      var response = await http.post(
          Uri.parse(
              'https://geocode.maps.co/reverse?lat=${latlng.latitude}&lon=${latlng.longitude}&api_key=6696ae9d4ebc2317438148rjq134731'),
          headers: headers);

      log(response.toString());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final addressString = data['address'];
        final city = addressString['city'];
        final county = addressString['county'];
        final stateDistrict = addressString['state_district'];
        final state = addressString['state'];
        final postcode = addressString['postcode'];
        final country = addressString['country'];

        address =
            cleanAddress(city, county, stateDistrict, state, postcode, country);

        if (address == null) return;

        locator<PanelCubit>().emitAddressState(address!);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  String? cleanAddress(String? city, String? county, String? stateDistrict,
      String? state, String? postcode, String? country) {
    List<String?> components = [
      city,
      county,
      stateDistrict,
      state,
      postcode,
      country
    ];

    List<String> filteredComponents = components
        .where((component) => component != null && component.isNotEmpty)
        .toList()
        .cast<String>();
    String _address = filteredComponents.join(', ');

    return _address.isNotEmpty ? _address : null;
  }

  Future<void> createLandmark(
      String beaconId, String title, LatLng latlng) async {
    var dataState = await _hikeUseCase.createLandMark(beaconId, title,
        latlng.latitude.toString(), latlng.longitude.toString());

    if (dataState is DataSuccess && dataState.data != null) {
      await _createLandMarkMarker(dataState.data!);
      emit(LoadedLocationState(
          polyline: _polyline,
          geofence: _geofence,
          mapType: _mapType,
          locationMarkers: Set<Marker>.from(_hikeMarkers),
          message: 'New marker created by ${dataState.data!.createdBy!.name}'));
    }
  }

  Future<void> sendSOS(String id, BuildContext context) async {
    final dataState = await _hikeUseCase.sos(id);

    if (dataState is DataSuccess) {
      log('data coming from sos: ${dataState.data.toString()}');
      // // Ensure _hikeMarkers is a Set of marker objects

      var userId = localApi.userModel.id;
      var marker =
          _hikeMarkers.firstWhere((marker) => marker.markerId.value == userId);

      _hikeMarkers.removeWhere(
        (hmarker) => hmarker.markerId.value == marker.markerId.value,
      );

      _hikeMarkers.add(RippleMarker(
        markerId: marker.mapsId,
        position: marker.position,
        infoWindow: marker.infoWindow,
        ripple: true,
      ));

      startAnimation(dataState.data!);

      emit(LoadedLocationState(
        geofence: _geofence,
        locationMarkers: _hikeMarkers,
        mapType: _mapType,
        message: 'SOS is send with your current\ location!',
        polyline: _polyline,
        version: DateTime.now().millisecond,
      ));
    } else {
      utils.showSnackBar('Beacon is not active anymore!', context);
    }
  }

  Future<void> _createLandMarkMarker(LandMarkEntity landMark) async {
    final markerId = MarkerId(landMark.id!);
    final markerPosition = locationToLatLng(landMark.location!);

    final existingMarkers =
        _hikeMarkers.where((element) => element.markerId == markerId);

    if (existingMarkers.isEmpty) {
      var newMarker = await createMarker(landMark);
      _hikeMarkers.add(newMarker);
    } else {
      // If the marker exists, update its position
      final updatedMarker = existingMarkers.first.copyWith(
        positionParam: markerPosition,
      );
      _hikeMarkers
        ..remove(existingMarkers.first)
        ..add(updatedMarker);
    }
  }

  void _createUserMarker(UserEntity user, {bool isLeader = false}) async {
    final markerId = MarkerId(user.id!);
    final markerPosition = locationToLatLng(user.location!);

    // final bitmap = await _createCustomMarkerBitmap();

    final existingMarkers =
        _hikeMarkers.where((element) => element.markerId == markerId);

    if (existingMarkers.isEmpty) {
      // If the marker does not exist, create and add a new one
      final newMarker = Marker(
          markerId: markerId,
          position: markerPosition,
          infoWindow: InfoWindow(title: user.name ?? 'Anonymous'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              isLeader ? BitmapDescriptor.hueRed : BitmapDescriptor.hueOrange));
      _hikeMarkers.add(newMarker);
    } else {
      // If the marker exists, update its position
      final updatedMarker = existingMarkers.first.copyWith(
        positionParam: markerPosition,
      );
      _hikeMarkers
        ..remove(existingMarkers.first)
        ..add(updatedMarker);
    }
  }

  Future<Marker> createMarker(LandMarkEntity landmark) async {
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final customMarker = CustomMarker(text: landmark.title!);
    customMarker.paint(canvas, Size(100, 100));
    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(100, 100);
    final bytes = await image.toByteData(format: ImageByteFormat.png);

    return Marker(
      markerId: MarkerId(landmark.id!.toString()),
      position: locationToLatLng(landmark.location!),
      icon: BitmapDescriptor.bytes(bytes!.buffer.asUint8List()),
      infoWindow: InfoWindow(
        title: 'Created by: ${landmark.createdBy?.name ?? 'Anonymous'}',
      ),
    );
  }

  void changeGeofenceRadius(double radius, LatLng center) {
    var index = _geofence
        .toList()
        .indexWhere((element) => element.circleId.value == 'geofence');

    if (index >= 0) {
      var newGeofence = _geofence.toList()[index].copyWith(radiusParam: radius);
      _geofence.removeWhere((element) => element.circleId.value == 'geofence');
      _geofence.add(newGeofence);
    } else {
      _geofence.add(Circle(
        circleId: CircleId('geofence'),
        center: center,
        radius: radius,
        strokeColor: Colors.blue,
        strokeWidth: 2,
        fillColor: Colors.blue.withValues(alpha: 0.1),
      ));
    }
    emit(LoadedLocationState(
        polyline: _polyline,
        locationMarkers: _hikeMarkers,
        geofence: _geofence,
        mapType: _mapType,
        version: DateTime.now().microsecond));
  }

  void removeUncreatedGeofence() {
    _geofence.removeWhere((geofence) {
      return geofence.circleId.value == 'geofence';
    });

    emit(LoadedLocationState(
        polyline: _polyline,
        locationMarkers: _hikeMarkers,
        geofence: _geofence,
        mapType: _mapType,
        version: DateTime.now().microsecond));
  }

  LatLng locationToLatLng(LocationEntity location) {
    return LatLng(stringTodouble(location.lat!), stringTodouble(location.lon!));
  }

  double stringTodouble(String coord) {
    return double.parse(coord);
  }

  void changeMap(MapType mapType) {
    if (mapType == _mapType) return;
    _mapType = mapType;

    emit(LoadedLocationState(
      polyline: _polyline,
      locationMarkers: _hikeMarkers,
      geofence: _geofence,
      mapType: mapType,
    ));
  }

  LatLng locationDataToLatLng(LocationData locationData) {
    return LatLng(locationData.latitude!, locationData.longitude!);
  }

  LocationEntity locationDataToLocationEntity(LocationData locationData) {
    return LocationEntity(
        lat: locationData.latitude.toString(),
        lon: locationData.longitude.toString());
  }

  clear() {
    _points.clear();
    _polyline.clear();
    _geofence.clear();
    _followers.clear();
    context = null;
    vsync = null;
    _leader = null;
    _beacon = null;
    _beaconId = null;
    _mapType = MapType.normal;
    _beaconlocationsSubscription?.cancel();
    _streamLocaitonData?.cancel();
    mapController?.dispose();
    _hikeMarkers.clear();
  }
}
