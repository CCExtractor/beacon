import 'package:beacon/Bloc/core/resources/data_state.dart';
import 'package:beacon/Bloc/domain/entities/group/group_entity.dart';
import 'package:beacon/Bloc/domain/repositories/home_repository.dart';

class HomeUseCase {
  final HomeRepository homeRepository;

  HomeUseCase({required this.homeRepository});

  Future<DataState<List<GroupEntity>>> groups(int page, int pageSize) {
    return homeRepository.fetchGroups(page, pageSize);
  }

  Future<DataState<GroupEntity>> createGroup(String title) {
    return homeRepository.createGroup(title);
  }

  Future<DataState<GroupEntity>> joinGroup(String shortCode) {
    return homeRepository.joinGroup(shortCode);
  }
}
