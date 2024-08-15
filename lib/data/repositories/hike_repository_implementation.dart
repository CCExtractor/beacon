import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/data/datasource/remote/remote_hike_api.dart';
import 'package:beacon/data/models/beacon/beacon_model.dart';
import 'package:beacon/data/models/landmark/landmark_model.dart';
import 'package:beacon/data/models/location/location_model.dart';
import 'package:beacon/domain/entities/subscriptions/beacon_locations_entity/beacon_locations_entity.dart';
import 'package:beacon/domain/entities/subscriptions/join_leave_beacon_entity/join_leave_beacon_entity.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:beacon/domain/repositories/hike_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HikeRepositoryImplementatioin implements HikeRepository {
  final RemoteHikeApi remoteHikeApi;

  HikeRepositoryImplementatioin({required this.remoteHikeApi});

  @override
  Future<DataState<BeaconModel>> fetchBeaconDetails(String beaconId) {
    return remoteHikeApi.fetchBeaconDetails(beaconId);
  }

  @override
  Future<DataState<LocationModel>> updateBeaconLocation(
      String beaconId, LatLng position) {
    return remoteHikeApi.updateBeaconLocation(
        beaconId, position.latitude.toString(), position.longitude.toString());
  }

  @override
  Future<DataState<LandMarkModel>> createLandMark(
      String id, String title, String lat, String lon) {
    return remoteHikeApi.createLandMark(id, lat, lon, title);
  }

  @override
  Stream<DataState<BeaconLocationsEntity>> beaconLocationsSubscription(
      String beaconId) {
    return remoteHikeApi.locationUpdateSubscription(beaconId);
  }

  @override
  Stream<DataState<JoinLeaveBeaconEntity>> joinLeaveBeaconSubscription(
      String beaconId) {
    return remoteHikeApi.LeaveJoinBeaconSubscription(beaconId);
  }

  @override
  Future<DataState<UserEntity>> changeUserLocation(String id, LatLng latLng) {
    return remoteHikeApi.changeUserLocation(id, latLng);
  }

  @override
  Future<DataState<UserEntity>> sos(String beaconId) {
    return remoteHikeApi.sos(beaconId);
  }
}
