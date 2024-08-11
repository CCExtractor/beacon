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
import 'package:beacon/presentation/widgets/custom_label_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationCubit extends Cubit<LocationState> {
  final HikeUseCase _hikeUseCase;
  LocationCubit._internal(this._hikeUseCase) : super(InitialLocationState());

  static LocationCubit? _instance;

  factory LocationCubit(HikeUseCase hikeUseCase) {
    return _instance ?? LocationCubit._internal(hikeUseCase);
  }

  String? _beaconId;
  BeaconEntity? _beacon;
  GoogleMapController? _mapController;
  Set<Marker> _hikeMarkers = {};
  UserEntity? _currentUser;
  UserEntity? _leader;
  List<UserEntity?> _followers = [];
  Set<Polyline> _polyline = {};
  String? _currentUserId;
  List<LatLng> _points = [];
  String? _address;
  LocationData? _lastLocation;
  Set<Circle> _geofence = {};
  MapType _mapType = MapType.normal;

  StreamSubscription<DataState<BeaconLocationsEntity>>?
      _beaconlocationsSubscription;
  StreamSubscription<LocationData>? _streamLocaitonData;

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> loadBeaconData(BeaconEntity beacon) async {
    emit(InitialLocationState());
    _beaconId = beacon.id!;
    _beacon = beacon;

    _currentUserId = localApi.userModel.id!;

    // // adding leader location
    if (beacon.leader != null) {
      _leader = beacon.leader!;
      // creating leader location

      if (_currentUserId == _leader!.id) {
        _currentUser = _leader;
      }
      if (_leader!.location != null) {
        _createUserMarker(_leader!, isLeader: true);
        getLeaderAddress(locationToLatLng(_leader!.location!));
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
      // handling polyline here
      for (var point in beacon.route!) {
        _points.add(locationToLatLng(point!));
      }
      _polyline.add(Polyline(
          polylineId: PolylineId('leader path'),
          color: kYellow,
          width: 1,
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
        address: _address,
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
          address: _address,
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
          address: _address,
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

  void changeCameraPosition(LatLng latLng) {
    _mapController!.moveCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: latLng)));
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

    _mapController!.animateCamera(CameraUpdate.newCameraPosition(
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

        if (beaconLocationsEntity.geofence != null) {
          // geofence recieved
        } else if (beaconLocationsEntity.landmark != null) {
          LandMarkEntity newLandMark = beaconLocationsEntity.landmark!;

          await _createLandMarkMarker(newLandMark);

          emit(LoadedLocationState(
              polyline: _polyline,
              locationMarkers: _hikeMarkers,
              address: _address,
              mapType: _mapType,
              geofence: _geofence,
              message:
                  'A landmark is created by ${beaconLocationsEntity.landmark!.createdBy!.name ?? 'Anonymous'}'));
        } else if (beaconLocationsEntity.user != null) {
          // location of follower or leader changing

          UserEntity userlocation = beaconLocationsEntity.user!;

          _createUserMarker(userlocation);

          emit(LoadedLocationState(
              polyline: _polyline,
              geofence: _geofence,
              locationMarkers: _hikeMarkers,
              address: _address,
              mapType: _mapType,
              version: DateTime.now().microsecond));
          // add marker for user
        } else if (beaconLocationsEntity.route != null) {
          var routes = beaconLocationsEntity.route;
          _points.clear();
          for (var route in routes!) {
            _points.add(locationToLatLng(route!));
          }
          _polyline.clear();

          _polyline.add(Polyline(
              polylineId: PolylineId(''),
              points: _points,
              width: 5,
              color: kYellow));

          emit(LoadedLocationState(
              address: _address,
              geofence: _geofence,
              locationMarkers: _hikeMarkers,
              mapType: _mapType,
              polyline: _polyline,
              version: DateTime.now().millisecondsSinceEpoch));
        } else if (beaconLocationsEntity.userSOS != null) {
          var user = beaconLocationsEntity.userSOS;

          // TODO: will update ui to ripple the marker

          // var marker = _hikeMarkers
          //     .firstWhere((marker) => marker.markerId.value == user!.id);

          // _hikeMarkers
          //     .removeWhere((hmarker) => hmarker.markerId == marker.markerId);
        }
      }
    });
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

        _address =
            '$city, $county, $stateDistrict, $state, $postcode, $country';

        log('got address: $_address');

        emit(LoadedLocationState(
          geofence: _geofence,
          locationMarkers: _hikeMarkers,
          polyline: _polyline,
          version: DateTime.now().millisecondsSinceEpoch,
          address: _address,
          mapType: _mapType,
        ));
      }
    } catch (e) {
      log(e.toString());
    }
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
          address: _address,
          mapType: _mapType,
          locationMarkers: Set<Marker>.from(_hikeMarkers),
          message: 'New marker created by ${dataState.data!.createdBy!.name}'));
    }
  }

  Future<void> sendSOS(String id, BuildContext context) async {
    final dataState = await _hikeUseCase.sos(id);

    if (dataState is DataSuccess) {
      // // Ensure _hikeMarkers is a Set of marker objects

      var userId = localApi.userModel.id;
      var marker =
          _hikeMarkers.firstWhere((marker) => marker.markerId.value == userId);

      _hikeMarkers.removeWhere(
        (hmarker) => hmarker.markerId.value == marker.markerId.value,
      );

      _hikeMarkers.add(Marker(
          markerId: marker.mapsId,
          position: marker.position,
          infoWindow: marker.infoWindow));

      emit(LoadedLocationState(
        address: _address,
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
        fillColor: Colors.blue.withOpacity(0.1),
      ));
    }
    emit(LoadedLocationState(
        polyline: _polyline,
        locationMarkers: _hikeMarkers,
        geofence: _geofence,
        address: _address,
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
        address: _address,
        mapType: _mapType,
        version: DateTime.now().microsecond));
  }

  LatLng locationToLatLng(LocationEntity location) {
    return LatLng(stringTodouble(location.lat!), stringTodouble(location.lon!));
  }

  double stringTodouble(String coord) {
    return double.parse(coord);
  }

  Future<void> createGeofence(
      String beaconId, LatLng latlng, double radius) async {
    var dataState = await _hikeUseCase.createGeofence(beaconId, latlng, radius);

    if (dataState is DataSuccess && dataState.data != null) {
      _geofence.clear();

      var geofence = dataState.data!;

      _geofence.add(Circle(
        circleId: CircleId(DateTime.now().millisecondsSinceEpoch.toString()),
        center: locationToLatLng(geofence.center!),
        radius: (geofence.radius! * 1000),
        strokeColor: kYellow,
        strokeWidth: 2,
        fillColor: kYellow.withOpacity(0.2),
      ));

      emit(LoadedLocationState(
          polyline: _polyline,
          locationMarkers: _hikeMarkers,
          geofence: _geofence,
          address: _address,
          mapType: _mapType,
          message: 'New geofence created!',
          version: DateTime.now().microsecond));
    }
  }

  void changeMap(MapType mapType) {
    if (mapType == _mapType) return;
    _mapType = mapType;

    emit(LoadedLocationState(
      polyline: _polyline,
      locationMarkers: _hikeMarkers,
      geofence: _geofence,
      address: _address,
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
    _leader = null;
    _beacon = null;
    _beaconId = null;
    _mapType = MapType.normal;
    _beaconlocationsSubscription?.cancel();
    _streamLocaitonData?.cancel();
    _mapController?.dispose();
    _hikeMarkers.clear();
  }
}
