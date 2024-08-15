import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/domain/entities/landmark/landmark_entity.dart';
import 'package:beacon/domain/entities/location/location_entity.dart';
import 'package:beacon/domain/entities/subscriptions/beacon_locations_entity/beacon_locations_entity.dart';
import 'package:beacon/domain/entities/subscriptions/join_leave_beacon_entity/join_leave_beacon_entity.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:beacon/domain/repositories/hike_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HikeUseCase {
  final HikeRepository hikeRepository;

  HikeUseCase({required this.hikeRepository});

  Future<DataState<LocationEntity>> updateBeaconLocation(
      String beaconId, LatLng position) {
    return hikeRepository.updateBeaconLocation(beaconId, position);
  }

  Future<DataState<BeaconEntity>> fetchBeaconDetails(String beaconId) {
    return hikeRepository.fetchBeaconDetails(beaconId);
  }

  Future<DataState<LandMarkEntity>> createLandMark(
      String id, String title, String lat, String lon) {
    return hikeRepository.createLandMark(id, title, lat, lon);
  }

  Future<DataState<UserEntity>> changeUserLocation(String id, LatLng latlng) {
    return hikeRepository.changeUserLocation(id, latlng);
  }

  Stream<DataState<BeaconLocationsEntity>> beaconlocationsSubscription(
      String beaconId) {
    return hikeRepository.beaconLocationsSubscription(beaconId);
  }

  Stream<DataState<JoinLeaveBeaconEntity>> joinleavebeaconSubscription(
      String beaconId) {
    return hikeRepository.joinLeaveBeaconSubscription(beaconId);
  }

  Future<DataState<UserEntity>> sos(String id) {
    return hikeRepository.sos(id);
  }
}
