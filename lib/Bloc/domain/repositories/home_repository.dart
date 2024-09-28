import 'package:beacon/Bloc/core/resources/data_state.dart';
import 'package:beacon/Bloc/domain/entities/group/group_entity.dart';

abstract class HomeRepository {
  Future<DataState<List<GroupEntity>>> fetchGroups(int page, int pageSize);
  Future<DataState<GroupEntity>> createGroup(String title);
  Future<DataState<GroupEntity>> joinGroup(String shortCode);
}
