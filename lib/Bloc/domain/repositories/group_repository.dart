import 'package:beacon/Bloc/core/resources/data_state.dart';
import 'package:beacon/Bloc/domain/entities/beacon/beacon_entity.dart';

abstract class GroupRepository {
  Future<DataState<BeaconEntity>> createHike(String title, int startsAt,
      int expiresAt, String lat, String lon, String groupID);

  Future<DataState<BeaconEntity>> joinHike(String hikeId);

  Future<DataState<List<BeaconEntity>>> fetchHikes(
      String groupID, int page, int pageSize);
}
