import 'dart:developer';
import 'package:beacon/Bloc/core/resources/data_state.dart';
import 'package:beacon/Bloc/domain/entities/group/group_entity.dart';
import 'package:beacon/Bloc/domain/usecase/home_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HomeState {}

class InitialHomeState extends HomeState {}

class ReloadState extends HomeState {}

class ShrimmerState extends HomeState {}

class LoadingMoreGroups extends HomeState {}

class NewGroupLoadingState extends HomeState {}

class ErrorHomeState extends HomeState {
  String error;
  ErrorHomeState({required this.error});
}

class HomeCubit extends Cubit<HomeState> {
  final HomeUseCase homeUseCase;
  HomeCubit({required this.homeUseCase}) : super(InitialHomeState());

  int page = 1;
  int pageSize = 4;
  bool isLoadingMore = false;
  bool isCompletelyFetched = false;
  List<GroupEntity> _totalGroups = [];
  List<GroupEntity> get totalGroups => _totalGroups;

  Future<void> createGroup(String title) async {
    emit(NewGroupLoadingState());
    final dataState = await homeUseCase.createGroup(title);
    if (dataState is DataFailed) {
      emit(ErrorHomeState(error: dataState.error!));
    } else {
      GroupEntity? group = dataState.data;
      group != null ? _totalGroups.insert(0, group) : null;
      emit(ReloadState());
    }
  }

  Future<void> joinGroup(String shortCode) async {
    emit(NewGroupLoadingState());
    DataState<GroupEntity> state = await homeUseCase.joinGroup(shortCode);

    if (state is DataFailed) {
      emit(ErrorHomeState(error: state.error!));
    } else {
      GroupEntity? group = state.data;
      group != null ? _totalGroups.insert(0, group) : null;
      emit(ReloadState());
    }
  }

  Future<void> fetchUserGroups() async {
    // if already loading then return
    if (isCompletelyFetched == true || isLoadingMore == true) return;

    if (page != 1) log('fetching next set of groups');

    if (page == 1) {
      emit(ShrimmerState());
    } else {
      isLoadingMore = true;
      emit(LoadingMoreGroups());
    }

    DataState<List<GroupEntity>> state =
        await homeUseCase.groups(page, pageSize);

    if (state is DataFailed) {
      isLoadingMore = false;
      emit(ErrorHomeState(error: state.error!));
    } else {
      List<GroupEntity> newGroups = state.data ?? [];
      if (newGroups.isEmpty) {
        isCompletelyFetched = true;
        emit(ReloadState());
        return;
      }
      for (var newGroup in newGroups) {
        _totalGroups.add(newGroup);
      }
      page++;
      isLoadingMore = false;
      emit(ReloadState());
    }
  }

  clear() {
    page = 1;
    isLoadingMore = false;
    isCompletelyFetched = false;
    _totalGroups.clear();
    emit(InitialHomeState());
  }
}
