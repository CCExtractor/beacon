import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/domain/entities/group/group_entity.dart';
import 'package:beacon/domain/entities/subscriptions/updated_group_entity/updated_group_entity.dart';

abstract class HomeRepository {
  Future<DataState<List<GroupEntity>>> fetchGroups(int page, int pageSize);
  Future<DataState<GroupEntity>> fetchGroup(String groupId);
  Future<DataState<GroupEntity>> createGroup(String title);
  Future<DataState<GroupEntity>> joinGroup(String shortCode);
  Stream<DataState<UpdatedGroupEntity>> groupUpdateSubscription(
      List<String> groupIds);
  Future<DataState<GroupEntity>> changeShortcode(String groupId);
}
