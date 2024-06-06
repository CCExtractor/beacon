import 'package:beacon/Bloc/core/resources/data_state.dart';
import 'package:beacon/Bloc/data/datasource/remote/remote_home_api.dart';
import 'package:beacon/Bloc/data/models/group/group_model.dart';
import 'package:beacon/Bloc/domain/repositories/home_repository.dart';

class HomeRepostitoryImplementation extends HomeRepository {
  final RemoteHomeApi remoteHomeApi;

  HomeRepostitoryImplementation({required this.remoteHomeApi});

  @override
  Future<DataState<GroupModel>> createGroup(String title) {
    return remoteHomeApi.createGroup(title);
  }

  @override
  Future<DataState<List<GroupModel>>> fetchGroups(int page, int pageSize) {
    return remoteHomeApi.fetchUserGroups(page, pageSize);
  }

  @override
  Future<DataState<GroupModel>> joinGroup(String shortCode) {
    return remoteHomeApi.joinGroup(shortCode);
  }
}
