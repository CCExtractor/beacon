import 'package:beacon/Bloc/core/resources/data_state.dart';
import 'package:beacon/Bloc/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/Bloc/domain/usecase/group_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class GroupState {}

class ShrimmerGroupState extends GroupState {}

class GroupLoadingState extends GroupState {}

class GroupErrorState extends GroupState {
  final String error;

  GroupErrorState({required this.error});
}

class GroupReloadState extends GroupState {
  List<BeaconEntity>? beacons;
  BeaconEntity? beacon;

  GroupReloadState({this.beacon, this.beacons});
}

class GroupCubit extends Cubit<GroupState> {
  final GroupUseCase _groupUseCase;
  GroupCubit(this._groupUseCase) : super(ShrimmerGroupState());

  int page = 1;
  int pageSize = 4;
  bool isLoadingMore = false;
  bool isCompletelyFetched = false;
  List<BeaconEntity> _beacons = [];
  List<BeaconEntity> get beacons => _beacons;

  Future<void> createHike(String title, int startsAt, int expiresAt, String lat,
      String lon, String groupID) async {
    emit(GroupLoadingState());
    final state = await _groupUseCase.createHike(
        title, startsAt, expiresAt, lat, lon, groupID);

    if (state is DataFailed) {
      emit(GroupErrorState(error: state.error!));
    } else {
      BeaconEntity? newHike = state.data;
      newHike != null ? _beacons.insert(0, newHike) : null;
      emit(GroupReloadState());
    }
  }

  Future<void> joinHike(String shortcode) async {
    emit(GroupLoadingState());
    final state = await _groupUseCase.joinHike(shortcode);
    if (state is DataFailed) {
      emit(GroupErrorState(error: state.error!));
    } else {
      BeaconEntity? newHike = state.data;
      newHike != null ? _beacons.insert(0, newHike) : null;
      emit(GroupReloadState());
    }
  }

  Future<void> fetchGroupHikes(String groupID) async {
    if (isLoadingMore == true) return;

    if (page == 1) {
      emit(ShrimmerGroupState());
    }

    isLoadingMore = true;
    final state = await _groupUseCase.fetchHikes(groupID, page, pageSize);

    if (state is DataFailed) {
      isLoadingMore = false;
      emit(GroupErrorState(error: state.error!));
    } else {
      final hikes = state.data ?? [];
      isLoadingMore = false;
      page++;
      if (hikes.isEmpty) {
        isCompletelyFetched = true;
        emit(GroupReloadState());
        return;
      }
      for (var hike in hikes) {
        _beacons.add(hike);
      }
      emit(GroupReloadState());
    }
  }

  clear() {
    page = 1;
    pageSize = 4;
    _beacons.clear();
    isCompletelyFetched = false;
    emit(ShrimmerGroupState());
  }
}
