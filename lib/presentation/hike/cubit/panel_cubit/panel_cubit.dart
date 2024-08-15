import 'dart:convert';
import 'dart:developer';

import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/domain/entities/subscriptions/join_leave_beacon_entity/join_leave_beacon_entity.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:beacon/domain/usecase/hike_usecase.dart';
import 'package:beacon/presentation/hike/cubit/panel_cubit/panel_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

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

  String? _address;

  Future<void> getLeaderAddress(LatLng latlng) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
      };
      var response = await http.post(
          Uri.parse(
              'https://geocode.maps.co/reverse?lat=${latlng.latitude}&lon=${latlng.longitude}&api_key=6696ae9d4ebc2317438148rjq134731'),
          headers: headers);

      log(response.toString());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final addressString = data['address'];
        final city = addressString['city'];
        final county = addressString['county'];
        final stateDistrict = addressString['state_district'];
        final state = addressString['state'];
        final postcode = addressString['postcode'];
        final country = addressString['country'];

        _address =
            cleanAddress(city, county, stateDistrict, state, postcode, country);

        if (_address == null) return;

        emitAddressState(_address!);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  String? cleanAddress(String? city, String? county, String? stateDistrict,
      String? state, String? postcode, String? country) {
    List<String?> components = [
      city,
      county,
      stateDistrict,
      state,
      postcode,
      country
    ];

    List<String> filteredComponents = components
        .where((component) => component != null && component.isNotEmpty)
        .toList()
        .cast<String>();
    String _address = filteredComponents.join(', ');

    return _address.isNotEmpty ? _address : null;
  }

  emitAddressState(String leaderAddress) {
    var expiresAT = DateTime.fromMillisecondsSinceEpoch(_beacon!.expiresAt!);
    var isBeaconActive = expiresAT.isAfter(DateTime.now());
    String? expiringTime;
    if (isBeaconActive) {
      var expireTime = DateFormat('hh:mm a').format(expiresAT); // 02:37 PM
      var expireDate = DateFormat('dd/MM/yyyy').format(expiresAT); // 24/03/2023
      expiringTime = '$expireTime, $expireDate';
    }
    emit(LoadedPanelState(
        expiringTime: expiringTime,
        followers: _followers,
        isActive: isBeaconActive,
        leader: _beacon!.leader,
        leaderAddress: leaderAddress,
        message: 'leader address changed!'));
  }
}
