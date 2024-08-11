import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:beacon/domain/repositories/group_repository.dart';

class GroupUseCase {
  final GroupRepository _groupRepo;

  GroupUseCase(this._groupRepo);

  Future<DataState<List<BeaconEntity>>> fetchHikes(
      String groupID, int page, int pageSize) {
    return _groupRepo.fetchHikes(groupID, page, pageSize);
  }

  Future<DataState<BeaconEntity>> joinHike(String shortcode) {
    return _groupRepo.joinHike(shortcode);
  }

  Future<DataState<BeaconEntity>> createHike(String title, int startsAt,
      int expiresAt, String lat, String lon, String groupID) {
    return _groupRepo.createHike(title, startsAt, expiresAt, lat, lon, groupID);
  }

  Future<DataState<List<BeaconEntity>>> nearbyHikes(
      String groupId, String lat, String lon, double radius) {
    return _groupRepo.nearbyHikes(groupId, lat, lon, radius);
  }

  Future<DataState<List<BeaconEntity>>> filterHikes(
      String groupId, String type) {
    return _groupRepo.filterHikes(groupId, type);
  }

  Future<DataState<bool>> deleteBeacon(String? beaconId) {
    return _groupRepo.deleteBeacon(beaconId);
  }

  Future<DataState<BeaconEntity>> rescheduleHike(
      int newExpiresAt, int newStartsAt, String beaconId) {
    return _groupRepo.rescheduleHike(newExpiresAt, newStartsAt, beaconId);
  }

  Future<DataState<UserEntity>> removeMember(String groupId, String memberId) {
    return _groupRepo.removeMember(groupId, memberId);
  }
}
