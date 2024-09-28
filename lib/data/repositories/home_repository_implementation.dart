import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/data/datasource/remote/remote_home_api.dart';
import 'package:beacon/data/models/group/group_model.dart';
import 'package:beacon/data/models/subscriptions/updated_group_model/updated_group_model.dart';
import 'package:beacon/domain/entities/group/group_entity.dart';
import 'package:beacon/domain/repositories/home_repository.dart';

class HomeRepostitoryImplementation implements HomeRepository {
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

  @override
  Stream<DataState<UpdatedGroupModel>> groupUpdateSubscription(
      List<String> groupIds) {
    return remoteHomeApi.groupUpdateSubscription(groupIds);
  }

  @override
  Future<DataState<GroupEntity>> fetchGroup(String groupId) {
    return remoteHomeApi.fetchGroup(groupId);
  }

  @override
  Future<DataState<GroupEntity>> changeShortcode(String groupId) {
    return remoteHomeApi.changeShortCode(groupId);
  }
}
