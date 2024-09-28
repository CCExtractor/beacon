import 'package:beacon/Bloc/core/resources/data_state.dart';
import 'package:beacon/Bloc/data/datasource/remote/remote_group_api.dart';
import 'package:beacon/Bloc/data/models/beacon/beacon_model.dart';
import 'package:beacon/Bloc/domain/repositories/group_repository.dart';

class GroupRepostioryImplementation extends GroupRepository {
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
}
