import 'package:beacon/Bloc/core/resources/data_state.dart';
import 'package:beacon/Bloc/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/Bloc/domain/repositories/group_repository.dart';

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
}
