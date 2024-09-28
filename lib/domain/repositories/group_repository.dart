import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';

abstract class GroupRepository {
  Future<DataState<BeaconEntity>> createHike(String title, int startsAt,
      int expiresAt, String lat, String lon, String groupID);

  Future<DataState<BeaconEntity>> joinHike(String hikeId);

  Future<DataState<List<BeaconEntity>>> fetchHikes(
      String groupID, int page, int pageSize);

  Future<DataState<List<BeaconEntity>>> nearbyHikes(
      String groupId, String lat, String lon, double radius);

  Future<DataState<List<BeaconEntity>>> filterHikes(
      String groupId, String type);

  Future<DataState<bool>> deleteBeacon(String? beaconId);

  Future<DataState<BeaconEntity>> rescheduleHike(
      int expiresAt, int startsAt, String beaconId);

  Future<DataState<UserEntity>> removeMember(String groupId, String memberId);
}
