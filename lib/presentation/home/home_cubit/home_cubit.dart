import 'dart:async';
import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/domain/entities/group/group_entity.dart';
import 'package:beacon/domain/entities/subscriptions/updated_group_entity/updated_group_entity.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:beacon/domain/usecase/home_usecase.dart';
import 'package:beacon/presentation/group/cubit/group_cubit/group_cubit.dart';
import 'package:beacon/presentation/home/home_cubit/home_state.dart';
import 'package:beacon/presentation/group/cubit/members_cubit/members_cubit.dart';
import 'package:beacon/locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeUseCase homeUseCase;
  static HomeCubit? _instance;

  HomeCubit._internal({required this.homeUseCase}) : super(InitialHomeState()) {
    _loadedhomeState = const LoadedHomeState(groups: [], message: null);
    _shimmerhomeState = const ShimmerHomeState();
    _loadinghomeState = const LoadingHomeState();
  }

  factory HomeCubit(HomeUseCase homeUseCase) {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = HomeCubit._internal(homeUseCase: homeUseCase);
      return _instance!;
    }
  }

  int _page = 1;
  int _pageSize = 4;
  bool _hasReachedEnd = false;
  List<GroupEntity> _totalGroups = [];
  late List<String> _groupIds;
  StreamSubscription<DataState<UpdatedGroupEntity>>? _groupUpdateSubscription;
  bool _isLoadingMore = false;
  // this will store the group that user is currently present
  String? _currentGroupId;

  late LoadedHomeState _loadedhomeState;
  late ShimmerHomeState _shimmerhomeState;
  late LoadingHomeState _loadinghomeState;

  Future<void> createGroup(String title) async {
    emit(_loadinghomeState);
    final dataState = await homeUseCase.createGroup(title);

    if (dataState is DataSuccess && dataState.data != null) {
      GroupEntity group = dataState.data!;
      List<GroupEntity> updatedGroups = List.from(_totalGroups)
        ..removeWhere((element) => element.id == group.id)
        ..insert(0, group);

      _totalGroups = updatedGroups;

      emit(_loadedhomeState.copyWith(
          groups: updatedGroups, message: 'New group created!'));

      // adding new id for setting subscription
      _groupIds.add(group.id!);

      _groupUpdateSubscription?.cancel();
      _groupSubscription();
    } else {
      emit(_loadedhomeState.copyWith(
          groups: _totalGroups, message: dataState.error));
    }
  }

  Future<void> joinGroup(String shortCode) async {
    emit(_loadinghomeState);
    DataState<GroupEntity> dataState = await homeUseCase.joinGroup(shortCode);

    if (dataState is DataSuccess && dataState.data != null) {
      GroupEntity? newGroup = dataState.data;

      if (newGroup != null) {
        _totalGroups.removeWhere((group) => group.id == newGroup.id);
        _totalGroups.insert(0, newGroup);
        _groupIds.add(newGroup.id!);

        emit(_loadedhomeState.copyWith(
            groups: _totalGroups,
            message: 'You are member of ${newGroup.title ?? 'group'}'));

        _groupUpdateSubscription?.cancel();
        _groupSubscription();
      }
    } else {
      emit(_loadedhomeState.copyWith(
          groups: _totalGroups, message: dataState.error));
    }
  }

  Future<void> changeShortCode(GroupEntity group) async {
    if (group.leader!.id! != localApi.userModel.id) {
      emit(_loadinghomeState);
      Future.delayed(Duration(milliseconds: 200), () {
        emit(_loadedhomeState.copyWith(
            groups: _totalGroups, message: 'You are not the leader of group'));
      });
      return;
    }
    emit(_loadinghomeState);

    final dataState = await homeUseCase.changeShortcode(group.id!);

    if (dataState is DataSuccess && dataState.data != null) {
      var updatedGroup = dataState.data!;
      int index =
          _totalGroups.indexWhere((group) => group.id == updatedGroup.id);

      if (index != -1) {
        _totalGroups[index] = updatedGroup;
      }
      emit(_loadedhomeState.copyWith(
          groups: _totalGroups, message: 'Short code changed!'));
    } else {
      emit(_loadedhomeState.copyWith(
          groups: _totalGroups, message: dataState.error));
    }
  }

  Future<void> fetchUserGroups() async {
    if (_hasReachedEnd || _isLoadingMore) return;

    if (_page == 1) {
      emit(_shimmerhomeState);
    } else {
      _isLoadingMore = true;
      emit(_loadedhomeState.copyWith(
          groups: _totalGroups, isLoadingmore: _isLoadingMore));
    }

    DataState<List<GroupEntity>> state =
        await homeUseCase.groups(_page, _pageSize);

    if (state is DataFailed) {
      emit(_loadedhomeState.copyWith(
          groups: _totalGroups, message: state.error!));
    } else if (state is DataSuccess && state.data != null) {
      List<GroupEntity> newGroups = state.data!;

      Map<String, GroupEntity> groupMap = {
        for (var group in _totalGroups) group.id!: group
      };

      for (var newGroup in newGroups) {
        groupMap[newGroup.id!] = newGroup;
      }
      _totalGroups = groupMap.values.toList();
      _page++;
      _isLoadingMore = false;
      if (newGroups.length < _pageSize) {
        _hasReachedEnd = true;
      }
      emit(_loadedhomeState.copyWith(
          groups: _totalGroups,
          hasReachedEnd: _hasReachedEnd,
          isLoadingmore: _isLoadingMore));
    }
  }

  Future<void> _groupSubscription() async {
    // getting all group ids for subscription
    if (_groupIds.isEmpty) return;

    var membersCubit = locator<MembersCubit>();
    var groupCubit = locator<GroupCubit>();

    // creating subscription
    _groupUpdateSubscription = await homeUseCase
        .groupUpdateSubscription(_groupIds)
        .listen((dataState) async {
      if (dataState is DataSuccess) {
        UpdatedGroupEntity updatedGroup = dataState.data!;
        String groupId = updatedGroup.id!;

        // first taking the group from list of total groups
        var group = await _getGroup(groupId);

        // something went wrong or maybe group don't exist now //

        if (group == null) {
          return;
        }

        if (updatedGroup.newUser != null) {
          UserEntity newUser = updatedGroup.newUser!;

          // _currentGroupId is the id of the Group that the user has opened
          // if it is null then it is in homeScreen
          // groupId is the group for which Group update has come

          var groups = addNewMember(groupId, updatedGroup.newUser!);
          if (_currentGroupId != groupId) {
            String message =
                '${newUser.name ?? 'Anonymous'} has joined the ${group.title ?? 'title'}';
            emit(LoadedHomeState(groups: groups, message: message));
            showNotification(message, '');
          } else {
            membersCubit.addMember(updatedGroup.newUser!);
          }
        } else if (updatedGroup.newBeacon != null) {
          var newBeacon = updatedGroup.newBeacon!;

          String message =
              'A new beacon is created in ${updatedGroup.newBeacon!.group!.title ?? 'group'}';
          var updatedgroups = await addBeaconInGroup(newBeacon, groupId);
          if (_currentGroupId != groupId) {
            emit(_loadedhomeState.copyWith(
                groups: updatedgroups, message: message));
            showNotification(message, '');
          } else {
            groupCubit.addBeacon(newBeacon, message);
          }
        } else if (updatedGroup.updatedBeacon != null) {
          BeaconEntity updatedBeacon = updatedGroup.updatedBeacon!;

          String message =
              '${updatedBeacon.title ?? 'Beacon'} is rescheduled by ${updatedBeacon.leader!.name ?? 'Anonymous'}';
          var updatedGroups = addBeaconInGroup(updatedBeacon, groupId);

          if (_currentGroupId != groupId) {
            emit(_loadedhomeState.copyWith(
                groups: updatedGroups, message: message));
            showNotification(message, '');
          } else {
            groupCubit.addBeacon(updatedBeacon, message);
          }

          // a new beacon is rescheduled ....
        } else if (updatedGroup.deletedBeacon != null) {
          BeaconEntity deletedBeacon = updatedGroup.deletedBeacon!;

          String message =
              '${deletedBeacon.title ?? 'Beacon'} is deleted by ${deletedBeacon.leader!.name ?? 'Anonymous'}';
          var updatedGroups =
              deleteBeaconFromGroup(updatedGroup.deletedBeacon!, groupId);
          if (_currentGroupId != groupId) {
            emit(_loadedhomeState.copyWith(
                groups: updatedGroups, message: message));
            showNotification(message, '');
          } else {
            groupCubit.removeBeacon(deletedBeacon, message);
          }
        }
      }
    });
  }

  Future<GroupEntity?> _getGroup(String groupId) async {
    var index = _totalGroups.indexWhere((group) => group.id == groupId);
    if (index == -1) {
      var dataState = await homeUseCase.group(groupId);
      if (dataState is DataSuccess) {
        _totalGroups.insert(0, dataState.data!);
        return dataState.data!;
      }
      return null;
    }
    return _totalGroups[index];
  }

  // this function is used for emitting state or reload the sate
  void resetGroupActivity({String? groupId}) {
    if (groupId != null) {
      for (int i = 0; i < _totalGroups.length; i++) {
        if (_totalGroups[i].id == groupId) {
          var group = _totalGroups[i];
          _totalGroups.removeAt(i);
          group =
              group.copywith(hasBeaconActiby: false, hasMemberActivity: false);
          _totalGroups.insert(i, group);
        }
      }
    }
    emit(_loadedhomeState.copyWith(groups: List.from(_totalGroups)));
  }

  void showNotification(String title, String body) {
    localNotif.showInstantNotification(title, body);
  }

  List<GroupEntity> addBeaconInGroup(BeaconEntity newBeacon, String groupId) {
    var groups = _totalGroups.where((group) => group.id! == groupId).toList();

    if (groups.isEmpty) return List.from(_totalGroups);

    var group = groups.first;

    // while adding we'll be already checking for duplicate groups
    var beacons = List<BeaconEntity>.from(group.beacons ?? []);
    beacons.removeWhere((beacon) => beacon.id! == newBeacon.id!);
    beacons.add(newBeacon);

    var updatedGroup = group.copywith(beacons: beacons, hasBeaconActiby: true);

    var updatedGroups = List<GroupEntity>.from(_totalGroups)
      ..removeWhere((group) => group.id == groupId);

    updatedGroups.insert(0, updatedGroup);
    _totalGroups = updatedGroups;

    return updatedGroups;
  }

  List<GroupEntity> deleteBeaconFromGroup(
      BeaconEntity deletedBeacon, String groupId) {
    var groups = _totalGroups.where((group) => group.id! == groupId).toList();

    if (groups.isEmpty) return List<GroupEntity>.from(_totalGroups);

    var updatedGroups = List<GroupEntity>.from(_totalGroups)
      ..removeWhere((group) => group.id! == groupId);

    var beacons = List<BeaconEntity>.from(groups.first.beacons ?? []);
    beacons.removeWhere((beacon) => beacon.id! == deletedBeacon.id!);
    var group = groups.first.copywith(beacons: beacons, hasBeaconActiby: true);

    updatedGroups.insert(0, group);
    _totalGroups = updatedGroups;

    return updatedGroups;
  }

  List<GroupEntity> addNewMember(String groupId, UserEntity newUser) {
    var updatedGroups = List<GroupEntity>.from(_totalGroups);
    int groupIndex = updatedGroups.indexWhere((group) => group.id == groupId);
    if (groupIndex == -1) {
      return updatedGroups;
    }
    var group = updatedGroups[groupIndex];
    var updatedMembers = List<UserEntity>.from(group.members ?? []);
    updatedMembers.removeWhere((member) => member.id == newUser.id);
    updatedMembers.add(newUser);
    var updatedGroup = group.copywith(
      members: updatedMembers,
      hasMemberActivity: true,
    );
    updatedGroups[groupIndex] = updatedGroup;
    _totalGroups = updatedGroups;
    return updatedGroups;
  }

  List<GroupEntity> removeMember(String groupId, UserEntity userToRemove) {
    var updatedGroups = List<GroupEntity>.from(_totalGroups);
    int groupIndex = updatedGroups.indexWhere((group) => group.id == groupId);
    if (groupIndex == -1) {
      return updatedGroups;
    }
    var group = updatedGroups[groupIndex];
    var updatedMembers = List<UserEntity>.from(group.members ?? []);
    updatedMembers.removeWhere((member) => member.id == userToRemove.id);
    var updatedGroup = group.copywith(
      members: updatedMembers,
      hasMemberActivity: true,
    );
    updatedGroups[groupIndex] = updatedGroup;
    _totalGroups = updatedGroups;
    return updatedGroups;
  }

  void updateCurrentGroupId(String? groupId) {
    _currentGroupId = groupId;
  }

  void init() async {
    var groups = localApi.userModel.groups ?? [];
    _groupIds = List.generate(groups.length, (index) => groups[index]!.id!);
    await _groupSubscription();
  }

  void clear() {
    _groupIds.clear();
    _groupUpdateSubscription?.cancel();
    _page = 1;
    _hasReachedEnd = false;
    _totalGroups.clear();
    emit(InitialHomeState());
  }
}
