import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/domain/entities/subscriptions/join_leave_beacon_entity/join_leave_beacon_entity.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:beacon/domain/usecase/hike_usecase.dart';
import 'package:beacon/presentation/hike/cubit/panel_cubit/panel_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PanelCubit extends Cubit<SlidingPanelState> {
  final HikeUseCase _hikeUseCase;
  static PanelCubit? _instance;

  PanelCubit._internal(this._hikeUseCase) : super(SlidingPanelState.initial());

  factory PanelCubit(HikeUseCase hikeUseCase) {
    return _instance ??= PanelCubit._internal(hikeUseCase);
  }

  BeaconEntity? _beacon;
  String? _beaconId;
  List<UserEntity?> _followers = [];
  UserEntity? _leader;

  loadCollapsedPanel() {
    _beacon!.startsAt;
  }

  void loadBeaconData(BeaconEntity beacon) async {
    _beacon = beacon;
    _beaconId = beacon.id!;

    _followers = beacon.followers ?? [];
    _leader = beacon.leader;

    beaconJoinLeaveSubscription();

    var expiresAT = DateTime.fromMillisecondsSinceEpoch(_beacon!.expiresAt!);
    var isBeaconActive = expiresAT.isAfter(DateTime.now());

    String? expiringTime;
    if (isBeaconActive) {
      var expireTime = DateFormat('hh:mm a').format(expiresAT); // 02:37 PM
      var expireDate = DateFormat('dd/MM/yyyy').format(expiresAT); // 24/03/2023
      expiringTime = '$expireTime, $expireDate';
    }

    emit(SlidingPanelState.loaded(
      expiringTime: expiringTime,
      isActive: isBeaconActive,
      followers: _followers,
      leader: _leader,
    ));
  }

  Future<void> beaconJoinLeaveSubscription() async {
    await _hikeUseCase
        .joinleavebeaconSubscription(_beaconId!)
        .listen((dataState) {
      if (dataState is DataSuccess) {
        JoinLeaveBeaconEntity joinLeaveBeacon = dataState.data!;
        if (joinLeaveBeacon.newfollower != null) {
          var newFollower = joinLeaveBeacon.newfollower!;
          addUser(newFollower);
          emit(SlidingPanelState.loaded(
              followers: _followers,
              leader: _leader,
              message: '${newFollower.name} is now following the beacon!'));
        } else if (joinLeaveBeacon.inactiveuser != null) {}
      }
    });
  }

  void addUser(UserEntity user) {
    if (user.id == _beacon!.leader!.id) {
      _leader = user;
    } else {
      _followers.removeWhere((element) => element!.id == user.id);
      _followers.add(user);
    }
  }

  // void removeUser(UserEntity user){
  //   if(user.id==_beacon)
  // }
}
