import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/data/datasource/remote/remote_group_api.dart';
import 'package:beacon/data/models/beacon/beacon_model.dart';
import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:beacon/domain/repositories/group_repository.dart';

class GroupRepostioryImplementation implements GroupRepository {
  final RemoteGroupApi remoteGroupApi;
  GroupRepostioryImplementation({required this.remoteGroupApi});
  @override
  Future<DataState<BeaconModel>> createHike(String title, int startsAt,
      int expiresAt, String lat, String lon, String groupID) async {
    return remoteGroupApi.createHike(
        title, startsAt, expiresAt, lat, lon, groupID);
  }

  @override
  Future<DataState<List<BeaconModel>>> fetchHikes(
      String groupID, int page, int pageSize) {
    return remoteGroupApi.fetchHikes(groupID, page, pageSize);
  }

  @override
  Future<DataState<BeaconModel>> joinHike(String shortcode) {
    return remoteGroupApi.joinHike(shortcode);
  }

  @override
  Future<DataState<List<BeaconModel>>> nearbyHikes(
      String groupId, String lat, String lon, double radius) {
    return remoteGroupApi.nearbyBeacons(groupId, lat, lon, radius);
  }

  @override
  Future<DataState<List<BeaconModel>>> filterHikes(
      String groupId, String type) {
    return remoteGroupApi.filterBeacons(groupId, type);
  }

  @override
  Future<DataState<bool>> deleteBeacon(String? beaconId) {
    return remoteGroupApi.deleteBeacon(beaconId);
  }

  @override
  Future<DataState<BeaconEntity>> rescheduleHike(
      int expiresAt, int startsAt, String beaconId) {
    return remoteGroupApi.rescheduleBeacon(expiresAt, startsAt, beaconId);
  }

  @override
  Future<DataState<UserEntity>> removeMember(String groupId, String memberId) {
    return remoteGroupApi.removeMember(groupId, memberId);
  }
}
