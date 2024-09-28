import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/domain/entities/landmark/landmark_entity.dart';
import 'package:beacon/domain/entities/location/location_entity.dart';
import 'package:beacon/domain/entities/subscriptions/beacon_locations_entity/beacon_locations_entity.dart';
import 'package:beacon/domain/entities/subscriptions/join_leave_beacon_entity/join_leave_beacon_entity.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class HikeRepository {
  Future<DataState<LocationEntity>> updateBeaconLocation(
      String beaconId, LatLng position);
  Future<DataState<BeaconEntity>> fetchBeaconDetails(String beaconId);
  Future<DataState<LandMarkEntity>> createLandMark(
      String id, String title, String lat, String lon);
  Future<DataState<UserEntity>> changeUserLocation(String id, LatLng latLng);
  Future<DataState<UserEntity>> sos(String beaconId);
  Stream<DataState<BeaconLocationsEntity>> beaconLocationsSubscription(
      String beaconId);
  Stream<DataState<JoinLeaveBeaconEntity>> joinLeaveBeaconSubscription(
      String beaconId);
}
