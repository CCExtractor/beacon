import 'dart:async';
import 'package:beacon/config/local_notification.dart';
import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/domain/entities/group/group_entity.dart';
import 'package:beacon/domain/usecase/group_usecase.dart';
import 'package:beacon/domain/usecase/hike_usecase.dart';
import 'package:beacon/presentation/group/cubit/group_cubit/group_state.dart';
import 'package:beacon/presentation/home/home_cubit/home_cubit.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/config/router/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class GroupCubit extends Cubit<GroupState> {
  final GroupUseCase _groupUseCase;

  GroupCubit._internal(this._groupUseCase) : super(InitialGroupState()) {
    _initializeStates();
  }

  static GroupCubit? _instance;

  factory GroupCubit(GroupUseCase groupUseCase) {
    return _instance ?? GroupCubit._internal(groupUseCase);
  }

  int _page = 1;
  int _pageSize = 4;
  List<BeaconEntity> _beacons = [];
  List<BeaconEntity> _nearbyBeacons = [];
  List<BeaconEntity> _statusBeacons = [];

  double _radius = 1000.0;
  Position? _currentPosition;
  String? _groupId;

  // for all beacon state
  bool _isCompletelyFetched = false;
  bool _isLoadingMore = false;

  // for status beacon state

  filters _currentFilter = filters.ALL;

  late AllBeaconGroupState _allBeaconGroupState;
  late NearbyBeaconGroupState _nearbyBeaconGroupState;
  late StatusFilterBeaconGroupState _statusFilterBeaconGroupState;
  late ShrimmerGroupState _shrimmerGroupState;
  late LoadingGroupState _loadingGroupState;

  init(GroupEntity group) {
    _groupId = group.id!;
    _currentPosition = locationService.currentPosition;
  }

  _initializeStates() {
    _shrimmerGroupState = ShrimmerGroupState();
    _allBeaconGroupState = AllBeaconGroupState(beacons: []);

    _nearbyBeaconGroupState =
        NearbyBeaconGroupState(beacons: _nearbyBeacons, radius: _radius);

    _statusFilterBeaconGroupState =
        StatusFilterBeaconGroupState(beacons: [], type: _currentFilter);

    _loadingGroupState = LoadingGroupState();
  }

  clear() {
    _page = 1;
    _beacons.clear();
    _nearbyBeacons.clear();
    _statusBeacons.clear();
    _isLoadingMore = false;
    _isCompletelyFetched = false;
    _currentFilter = filters.ALL;
    _groupId = null;
    emit(InitialGroupState());
  }

  Future<void> createHike(String title, int startsAt, int expiresAt,
      String groupID, bool isInstant) async {
    emit(_loadingGroupState);

    bool isLocationEnabled = await fetchPosition();
    if (!isLocationEnabled) {
      emit(ErrorGroupState(
        message: 'To create a hike please enable your location!',
      ));
      return;
    }

    final dataState = await _groupUseCase.createHike(
        title,
        startsAt,
        expiresAt,
        _currentPosition!.latitude.toString(),
        _currentPosition!.longitude.toString(),
        groupID);

    // checking the current state of the screen to add the beacon in the same list of state

    if (dataState is DataSuccess && dataState.data != null) {
      BeaconEntity beacon = dataState.data!;

      // for adding beacons in group card
      locator<HomeCubit>().addBeaconInGroup(beacon, _groupId!);

      locator<LocalNotification>().scheduleNotification(beacon);

      _beacons.add(beacon);
      _beacons = sortHikes(_beacons);
      if (_currentFilter == filters.ALL) {
        if (isInstant) {
          appRouter.popAndPush(HikeScreenRoute(beacon: beacon, isLeader: true));
          return;
        }
        emit(_allBeaconGroupState.copyWith(
            beacons: _beacons, message: 'New Hike created'));
      }
      if (_currentFilter == filters.NEARBY) {
        if (isInstant) {
          appRouter.popAndPush(HikeScreenRoute(beacon: beacon, isLeader: true));
          return;
        }
        _nearbyBeacons.add(beacon);
        _nearbyBeacons = sortHikes(_nearbyBeacons);
        emit(_nearbyBeaconGroupState.copyWith(beacons: _nearbyBeacons));
      } else if (_currentFilter == filters.UPCOMING) {
        if (isInstant) {
          appRouter.popAndPush(HikeScreenRoute(beacon: beacon, isLeader: true));
          return;
        }
        _statusBeacons.add(beacon);
        _statusBeacons = sortHikes(_statusBeacons);
        emit(_statusFilterBeaconGroupState.copyWith(
            beacons: _statusBeacons, type: _currentFilter));
      }
    } else {
      _emitErrorState(dataState.error);
    }
  }

  _emitErrorState(String? message) {
    if (_currentFilter == filters.ALL) {
      emit(_allBeaconGroupState.copyWith(
        beacons: _beacons,
        message: message,
      ));
    } else if (_currentFilter == filters.NEARBY) {
      emit(_nearbyBeaconGroupState.copyWith(
        beacons: _nearbyBeacons,
        message: message,
      ));
    } else {
      emit(_statusFilterBeaconGroupState.copyWith(
          beacons: _statusBeacons, message: message, type: _currentFilter));
    }
  }

  // ALL HIKES
  Future<void> allHikes(String groupId) async {
    print('calling hikes');

    if (_isCompletelyFetched || _isLoadingMore) return;

    if (_page == 1) {
      emit((ShrimmerGroupState()));
    } else {
      _isLoadingMore = true;
      emit(AllBeaconGroupState(
          beacons: _beacons,
          isLoadingMore: _isLoadingMore,
          isCompletelyFetched: _isCompletelyFetched));
    }

    final dataState = await _groupUseCase.fetchHikes(groupId, _page, _pageSize);

    if (dataState is DataSuccess && dataState.data != null) {
      print(dataState.data!.length.toString());

      addBeaconList(dataState.data!);
      _beacons = sortHikes(_beacons);
      int length = dataState.data!.length;
      if (length < 4) {
        _isCompletelyFetched = true;
      }
      _page++;
      _isLoadingMore = false;
      emit(_allBeaconGroupState.copyWith(
          beacons: _beacons,
          isLoadingMore: _isLoadingMore,
          isCompletelyFetched: _isCompletelyFetched));
    } else {
      _isLoadingMore = false;
      emit(_allBeaconGroupState.copyWith(
          beacons: _beacons,
          isLoadingMore: _isLoadingMore,
          message: dataState.error,
          isCompletelyFetched: _isCompletelyFetched));
    }
  }

  void addBeaconList(List<BeaconEntity> newBeacons) {
    late bool isBeaconPresent;
    var beacons = newBeacons;
    for (int i = 0; i < beacons.length; i++) {
      var beacon = beacons[i];
      isBeaconPresent = false;
      for (int j = 0; j < _beacons.length; j++) {
        if (beacon.id! == _beacons[j].id!) {
          isBeaconPresent = true;
          _beacons.removeAt(j);
          _beacons.add(beacon);
        }
      }
      if (isBeaconPresent == false) {
        _beacons.add(beacon);
      }
    }
  }

  Future<bool> fetchPosition() async {
    _currentPosition = locationService.currentPosition;
    if (_currentPosition == null) {
      try {
        _currentPosition = await locationService.getCurrentLocation();
        return true;
      } catch (e) {
        print('error: $e');
        return false;
      }
    }
    return true;
  }

  // NEARBY HIKES
  Future<void> nearbyHikes(String groupId, {double radius = 1000.0}) async {
    _currentFilter = filters.NEARBY;

    emit(_shrimmerGroupState);
    bool isLocationEnabled = await fetchPosition();
    if (!isLocationEnabled) {
      emit(ErrorGroupState(
        message: 'To see nearby hikes Please give access to your location!',
      ));
      return;
    }
    _radius = radius;

    final dataState = await _groupUseCase.nearbyHikes(
        groupId,
        _currentPosition!.latitude.toString(),
        _currentPosition!.longitude.toString(),
        radius);

    if (dataState is DataSuccess && dataState.data != null) {
      _nearbyBeacons.clear();
      dataState.data!.forEach((beacon) {
        _nearbyBeacons.add(beacon);
      });
      _nearbyBeacons = sortHikes(_nearbyBeacons);
      emit(_nearbyBeaconGroupState.copyWith(
          beacons: _nearbyBeacons,
          radius: _radius,
          message: 'Beacons under $radius km..'));
    } else {
      emit(_nearbyBeaconGroupState.copyWith(
          beacons: _nearbyBeacons, radius: _radius, message: dataState.error));
    }
  }

  // ACTIVE UPCOMING INACTIVE HIKES
  Future<void> _filterHikes(String groupId, filters type) async {
    print('calling filter hikes');
    print(_currentFilter.toString());
    emit(ShrimmerGroupState());
    final dataState = await _groupUseCase.filterHikes(groupId, type.name);

    if (dataState is DataSuccess && dataState.data != null) {
      for (var beacon in dataState.data!) {
        _statusBeacons.add(beacon);
      }
      _statusBeacons = sortHikes(_statusBeacons);

      print('calling function inside: ${_statusBeacons.length.toString()}');

      emit(_statusFilterBeaconGroupState.copyWith(
          beacons: _statusBeacons, type: type));
    } else {
      emit(_statusFilterBeaconGroupState.copyWith(
          beacons: _statusBeacons, type: type, message: dataState.error));
    }
  }

  // DELETE BEACON
  Future<bool> deleteBeacon(BeaconEntity beacon) async {
    if (beacon.leader!.id != localApi.userModel.id) {
      // for showing the snackbar
      reloadState(message: 'You are not the leader of beacon!');
      return false;
    }
    var dataState = await _groupUseCase.deleteBeacon(beacon.id);
    if (dataState is DataSuccess && dataState.data != null) {
      // for removing beacons from group card
      locator<HomeCubit>().deleteBeaconFromGroup(beacon, _groupId!);

      _beacons.removeWhere((currentBeacon) => currentBeacon.id! == beacon.id!);
      _nearbyBeacons
          .removeWhere((currentBeacon) => currentBeacon.id! == beacon.id!);
      _statusBeacons
          .removeWhere((currentBeacon) => currentBeacon.id! == beacon.id!);

      return true;
    } else {
      return false;
    }
  }

  List<BeaconEntity> sortHikes(List<BeaconEntity> _beacons) {
    List<BeaconEntity> inactive = [];
    var now = DateTime.now();

    _beacons.sort((a, b) => a.startsAt!.compareTo(b.startsAt!));

    _beacons.removeWhere((beacon) {
      var expiresAt = DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt!);
      if (expiresAt.isBefore(now)) {
        inactive.add(beacon);
        return true;
      }
      return false;
    });

    _beacons.addAll(inactive);
    return _beacons;
  }

  void changeFilter(filters filter) {
    // emitting all loading state
    print(filter.toString());
    if (filter == filters.ALL) {
      _currentFilter = filters.ALL;
      emit(ShrimmerGroupState());
      Future.delayed(Duration(milliseconds: 500), () {
        emit(_allBeaconGroupState.copyWith(beacons: _beacons));
      });
    }
    // emitting active upcoming and active on the basis of filter chosen
    else if (filter == filters.ACTIVE ||
        filter == filters.INACTIVE ||
        filter == filters.UPCOMING) {
      _loadfilterBeacons(filter, _groupId!);
    }
  }

  void _loadfilterBeacons(filters type, String groupId) {
    if (type == _currentFilter) {
      emit(ShrimmerGroupState());
      Future.delayed(Duration(milliseconds: 500), () {
        emit(_statusFilterBeaconGroupState.copyWith(
            beacons: _statusBeacons, type: type));
      });
    } else {
      _currentFilter = type;
      _statusBeacons.clear();
      _filterHikes(groupId, type);
    }
  }

  void reloadState({String? message}) {
    emit(_loadingGroupState);
    String? _message = message;
    if (_currentFilter == filters.ALL) {
      emit(_allBeaconGroupState.copyWith(beacons: _beacons, message: _message));
    } else if (_currentFilter == filters.NEARBY) {
      emit(_nearbyBeaconGroupState.copyWith(
        beacons: _nearbyBeacons,
        message: _message,
      ));
    } else if (_currentFilter == filters.UPCOMING ||
        _currentFilter == filters.ACTIVE ||
        _currentFilter == filters.INACTIVE) {
      emit(_statusFilterBeaconGroupState.copyWith(
          beacons: _statusBeacons, message: _message, type: _currentFilter));
    }
  }

  Future<void> addBeacon(BeaconEntity newBeacon, String message) async {
    List<BeaconEntity> updatedBeacons = List<BeaconEntity>.from(_beacons)
      ..removeWhere((beacon) => beacon.id == newBeacon.id)
      ..add(newBeacon);
    _beacons = updatedBeacons;
    updatedBeacons = sortHikes(updatedBeacons);

    print('here is come');

    var newstate = _allBeaconGroupState.copyWith(
        beacons: updatedBeacons, message: message);
    print(newstate == _allBeaconGroupState);
    emit(_shrimmerGroupState);
    emit(_allBeaconGroupState.copyWith(
        beacons: updatedBeacons, message: message));

    if (state is NearbyBeaconGroupState) {
      // first checking that the distance it is searching is that

      double distance = await locationService.calculateDistance(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          LatLng(double.parse(newBeacon.location!.lat!),
              double.parse(newBeacon.location!.lon!)));

      if (distance > _radius) return null;

      List<BeaconEntity> updatedBeacons = List.from(_nearbyBeacons)
        ..removeWhere((beacon) => beacon.id! == newBeacon.id!)
        ..add(newBeacon);

      _nearbyBeacons = updatedBeacons;

      updatedBeacons = sortHikes(updatedBeacons);
      emit(_nearbyBeaconGroupState.copyWith(
          beacons: updatedBeacons, radius: _radius));
    } else if (state is StatusFilterBeaconGroupState) {
      List<BeaconEntity> updatedBeacons = List.from(_statusBeacons)
        ..removeWhere((beacon) => beacon.id! == newBeacon.id!)
        ..add(newBeacon);

      _statusBeacons = updatedBeacons;
      updatedBeacons = sortHikes(updatedBeacons);

      emit(_statusFilterBeaconGroupState.copyWith(
        beacons: updatedBeacons,
        message: message,
      ));
    }
  }

  Future<void> removeBeacon(BeaconEntity deletedBeacon, String message) async {
    for (int i = 0; i < _beacons.length; i++) {
      if (_beacons[i].id! == deletedBeacon.id!) {
        _beacons.removeAt(i);
        break;
      }
    }

    var updatedBeacons = List<BeaconEntity>.from(_beacons)
      ..removeWhere((beacon) => beacon.id! == deletedBeacon.id!);
    _beacons = updatedBeacons;

    emit(_allBeaconGroupState.copyWith(
      beacons: updatedBeacons,
      message: message,
    ));

    if (state is NearbyBeaconGroupState) {
      // first checking that the distance it is searching is that

      var updatedBeacons = List<BeaconEntity>.from(_nearbyBeacons)
        ..removeWhere((beacon) => beacon.id! == deletedBeacon.id!);
      _nearbyBeacons = updatedBeacons;
      emit(_nearbyBeaconGroupState.copyWith(
          beacons: updatedBeacons, radius: _radius, message: message));
    } else if (state is StatusFilterBeaconGroupState) {
      var updatedBeacons = List<BeaconEntity>.from(_statusBeacons)
        ..removeWhere((beacon) => beacon.id! == deletedBeacon.id!);
      _statusBeacons = updatedBeacons;
      emit(_statusFilterBeaconGroupState.copyWith(
        beacons: updatedBeacons,
        message: message,
      ));
    }
  }

  Future<void> rescheduleHike(
      int newExpiresAt, int newStartsAt, String beaconId) async {
    emit(ShrimmerGroupState());

    DataState<BeaconEntity> dataState =
        await _groupUseCase.rescheduleHike(newExpiresAt, newStartsAt, beaconId);

    if (dataState is DataSuccess && dataState.data != null) {
      BeaconEntity updatedBeacon = dataState.data!;
      // adding the beacon in list and loading again
      _beacons.removeWhere((beacon) => beacon.id! == updatedBeacon.id!);
      _beacons.add(updatedBeacon);
      _beacons = sortHikes(_beacons);
      if (_currentFilter == filters.ALL) {
        emit(_allBeaconGroupState.copyWith(
            beacons: _beacons, message: 'Hike Rescheduled'));
        return;
      }
      if (_currentFilter == filters.NEARBY) {
        _nearbyBeacons.removeWhere((beacon) => beacon.id! == updatedBeacon.id!);
        _nearbyBeacons.add(updatedBeacon);
        _nearbyBeacons = sortHikes(_nearbyBeacons);
        emit(_nearbyBeaconGroupState.copyWith(
            beacons: _nearbyBeacons, radius: _radius));
      } else if (_currentFilter == filters.UPCOMING) {
        _statusBeacons.removeWhere((beacon) => beacon.id! == updatedBeacon.id!);
        _statusBeacons.add(updatedBeacon);
        _statusBeacons = sortHikes(_statusBeacons);

        emit(_statusFilterBeaconGroupState.copyWith(
            beacons: _nearbyBeacons,
            message: 'Hike Rescheduled',
            type: _currentFilter));
      }
    } else {
      if (_currentFilter == filters.ALL) {
        emit(_allBeaconGroupState.copyWith(
            beacons: _beacons, message: dataState.error));
      } else if (_currentFilter == filters.NEARBY) {
        emit(_nearbyBeaconGroupState.copyWith(
            beacons: _nearbyBeacons,
            radius: _radius,
            message: dataState.error));
      } else if (_currentFilter == filters.UPCOMING) {
        emit(_statusFilterBeaconGroupState.copyWith(
            beacons: _nearbyBeacons,
            message: dataState.error,
            type: _currentFilter));
      }
    }
  }

  void emitState({
    String? allBeaconMessage,
    String? nearbyBeaconMessage,
    String? statusBeaconMessage,
  }) {
    // creating this version to emit two same states consecutively
    int version = DateTime.now().millisecondsSinceEpoch;
    if (_currentFilter == filters.ALL) {
      emit(_allBeaconGroupState.copyWith(
          beacons: _beacons,
          isCompletelyFetched: _isCompletelyFetched,
          isLoadingMore: _isLoadingMore,
          message: allBeaconMessage,
          type: _currentFilter,
          version: version));
    } else if (_currentFilter == filters.NEARBY) {
      emit(_nearbyBeaconGroupState.copyWith(
          beacons: _nearbyBeacons,
          message: nearbyBeaconMessage,
          type: _currentFilter,
          radius: _radius,
          version: version));
    } else {
      emit(_statusFilterBeaconGroupState.copyWith(
          beacons: _statusBeacons,
          message: statusBeaconMessage,
          type: _currentFilter,
          version: version));
    }
    return;
  }

  _updateUserLocation(String beaconId) async {
    var location = locationService.currentPosition;
    if (location != null) {
      // updating the current location before entering the map
      await locator<HikeUseCase>().changeUserLocation(
          beaconId, LatLng(location.latitude, location.longitude));
    } else {
      location = await locationService.getCurrentLocation();
      if (location == null) {
        emit(ErrorGroupState(message: 'Please enable your location!'));
        return;
      }
      await locator<HikeUseCase>().changeUserLocation(
          beaconId, LatLng(location.latitude, location.longitude));
    }
  }

  Future<void> joinBeacon(
      BeaconEntity beacon, bool hasEnded, bool hasStarted) async {
    if (hasEnded) {
      String message = 'Beacon is not active anymore!';
      // function for emitting state on the basis of filter
      if (beacon.leader!.id == localApi.userModel.id) {
        // will allow the leader to join the beacon

        emit(_loadingGroupState);

        await _updateUserLocation(beacon.id!);

        appRouter.popAndPush(HikeScreenRoute(
            beacon: beacon,
            isLeader: (beacon.leader!.id == localApi.userModel.id)));
      }
      emitState(
          allBeaconMessage: message,
          nearbyBeaconMessage: message,
          statusBeaconMessage: message);
      return;
    }
    if (!hasStarted) {
      String message =
          'Beacon has not yet started! \nPlease come back at ${DateFormat("hh:mm a, d/M/y").format(DateTime.fromMillisecondsSinceEpoch(beacon.startsAt!)).toString()}';
      emitState(
          allBeaconMessage: message,
          nearbyBeaconMessage: message,
          statusBeaconMessage: message);
      return;
    }
    bool isJoinee = false;
    for (var i in beacon.followers!) {
      if (i!.id == localApi.userModel.id) {
        isJoinee = true;
      }
    }
    if (hasStarted &&
        (beacon.leader!.id == localApi.userModel.id || isJoinee)) {
      emit(_loadingGroupState);

      await _updateUserLocation(beacon.id!);

      appRouter.popAndPush(HikeScreenRoute(
          beacon: beacon,
          isLeader: (beacon.leader!.id == localApi.userModel.id)));
    } else {
      emit(_loadingGroupState);
      await _updateUserLocation(beacon.id!);
      final dataState = await _groupUseCase.joinHike(beacon.shortcode!);
      if (dataState is DataFailed) return;
      appRouter.popAndPush(HikeScreenRoute(
          beacon: dataState.data!,
          isLeader: dataState.data!.leader!.id == localApi.userModel.id));
    }
  }

  Future<void> joinBeaconWithShortCode(String shortcode) async {
    _currentFilter = filters.ALL;
    emit(_allBeaconGroupState.copyWith(
        beacons: _beacons,
        isCompletelyFetched: _isCompletelyFetched,
        isLoadingMore: _isLoadingMore,
        type: _currentFilter));
    emit(_loadingGroupState);

    for (var beacon in _beacons) {
      if (beacon.shortcode == shortcode) {
        bool hasEnded = DateTime.now()
            .isAfter(DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt!));
        bool hasStarted = DateTime.now()
            .isAfter((DateTime.fromMillisecondsSinceEpoch(beacon.startsAt!)));
        await joinBeacon(beacon, hasEnded, hasStarted);
        emitState();
        return;
      }
    }

    final dataState = await _groupUseCase.joinHike(shortcode);

    if (dataState is DataSuccess) {
      var beacon = dataState.data!;
      if (_groupId != beacon.group!.id) {
        var message = 'The beacon is not the part of this group!';
        emitState(
            allBeaconMessage: message,
            nearbyBeaconMessage: message,
            statusBeaconMessage: message);
        return;
      }
      bool hasEnded = DateTime.now()
          .isAfter(DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt!));
      bool hasStarted = DateTime.now()
          .isAfter((DateTime.fromMillisecondsSinceEpoch(beacon.startsAt!)));

      _beacons.add(beacon);
      await joinBeacon(beacon, hasEnded, hasStarted);
    } else if (dataState is DataFailed) {
      emitState(allBeaconMessage: dataState.error);
    }
  }
}
