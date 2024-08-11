import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/domain/entities/group/group_entity.dart';
import 'package:beacon/domain/entities/subscriptions/updated_group_entity/updated_group_entity.dart';
import 'package:beacon/domain/repositories/home_repository.dart';

class HomeUseCase {
  final HomeRepository homeRepository;

  HomeUseCase({required this.homeRepository});

  Future<DataState<List<GroupEntity>>> groups(int page, int pageSize) {
    return homeRepository.fetchGroups(page, pageSize);
  }

  Future<DataState<GroupEntity>> group(String groupId) {
    return homeRepository.fetchGroup(groupId);
  }

  Future<DataState<GroupEntity>> createGroup(String title) {
    return homeRepository.createGroup(title);
  }

  Future<DataState<GroupEntity>> joinGroup(String shortCode) {
    return homeRepository.joinGroup(shortCode);
  }

  Stream<DataState<UpdatedGroupEntity>> groupUpdateSubscription(
      List<String> groupIds) {
    return homeRepository.groupUpdateSubscription(groupIds);
  }

  Future<DataState<GroupEntity>> changeShortcode(String groupId) {
    return homeRepository.changeShortcode(groupId);
  }
}
