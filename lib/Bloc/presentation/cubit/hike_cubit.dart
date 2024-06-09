import 'dart:async';
import 'dart:developer';
import 'package:beacon/Bloc/core/resources/data_state.dart';
import 'package:beacon/Bloc/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/Bloc/domain/entities/location/location_entity.dart';
import 'package:beacon/Bloc/domain/usecase/hike_usecase.dart';
import 'package:beacon/locator.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

abstract class HikeState {
  final LocationEntity? location;
  final String? error;

  HikeState({this.location, this.error});
}

class InitialHikeState extends HikeState {}

class BeaconLocationLoaded extends HikeState {
  final LocationEntity location;
  BeaconLocationLoaded({required this.location});
}

class BeaconLocationError extends HikeState {
  final String message;
  BeaconLocationError({required this.message});
}

class HikeCubit extends Cubit<HikeState> {
  final HikeUseCase hikeUsecase;
  HikeCubit({required this.hikeUsecase}) : super(InitialHikeState());

  StreamSubscription<DataState<LocationEntity>>? _locationSubscription;

  Future<DataState<BeaconEntity>> fetchBeaconDetails(String beaconId) async {
    DataState<BeaconEntity> state =
        await hikeUsecase.fetchBeaconDetails(beaconId);

    if (state is DataSuccess) {
      return DataSuccess(state.data!);
    }
    return DataFailed(state.error!);
  }

  void beaconLocationSubscription(String beaconId) {
    _locationSubscription?.cancel();
    _locationSubscription =
        hikeUsecase.beaconLocationSubscription(beaconId).listen((dataState) {
      if (dataState is DataSuccess<LocationEntity>) {
        log(dataState.data!.toString());
        emit(BeaconLocationLoaded(location: dataState.data!));
      } else if (dataState is DataFailed) {
        log(dataState.error.toString());
        emit(BeaconLocationError(message: dataState.error!));
      }
    });
  }

  StreamSubscription<Position>? _positionStream;
  Position? position;

  updateBeaconLocation(String beaconId, BuildContext context) async {
    _positionStream?.cancel();
    _positionStream = await Geolocator.getPositionStream(
        locationSettings: LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    )).listen((newPosition) async {
      position = newPosition;
      utils.showSnackBar(
          'Updating location! ${newPosition.latitude} ${newPosition.longitude}',
          context);
      await hikeUsecase.updateBeaconLocation(beaconId, newPosition);
    });
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    _positionStream?.cancel();
    return super.close();
  }
}
