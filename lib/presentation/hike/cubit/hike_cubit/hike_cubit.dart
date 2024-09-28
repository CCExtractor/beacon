import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/domain/usecase/hike_usecase.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/presentation/hike/cubit/hike_cubit/hike_state.dart';
import 'package:beacon/presentation/hike/cubit/location_cubit/location_cubit.dart';
import 'package:beacon/presentation/hike/cubit/panel_cubit/panel_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HikeCubit extends Cubit<HikeState> {
  final HikeUseCase _hikeUseCase;
  HikeCubit._internal(this._hikeUseCase) : super(LoadedHikeState());

  static HikeCubit? _instance;

  factory HikeCubit(HikeUseCase hikeUseCase) {
    return _instance ?? HikeCubit._internal(hikeUseCase);
  }

  BeaconEntity? _beacon;

  Future<void> startHike(
      String beaconId, TickerProvider vsync, BuildContext context) async {
    emit(InitialHikeState());
    final dataState = await _hikeUseCase.fetchBeaconDetails(beaconId);

    if (dataState is DataSuccess && dataState.data != null) {
      final beacon = dataState.data!;
      _beacon = beacon;

      locator<LocationCubit>().loadBeaconData(beacon, vsync, context);
      locator<PanelCubit>().loadBeaconData(beacon);
      emit(LoadedHikeState(beacon: _beacon, message: 'Welcome to hike!'));
    } else {
      emit(ErrorHikeState(errmessage: dataState.error));
    }
  }

  clear() {
    _beacon = null;
  }
}
