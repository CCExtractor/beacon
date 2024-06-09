import 'package:beacon/Bloc/core/resources/data_state.dart';
import 'package:beacon/Bloc/data/datasource/remote/remote_hike_api.dart';
import 'package:beacon/Bloc/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/Bloc/domain/entities/location/location_entity.dart';
import 'package:beacon/Bloc/domain/repositories/hike_repository.dart';
import 'package:geolocator/geolocator.dart';

class HikeRepositoryImplementatioin extends HikeRepository {
  final RemoteHikeApi remoteHikeApi;

  HikeRepositoryImplementatioin({required this.remoteHikeApi});

  @override
  Stream<DataState<LocationEntity>> beaconLocationSubscription(
      String? beaconId) {
    return remoteHikeApi.beaconLocationSubscription(beaconId);
  }

  @override
  Future<DataState<BeaconEntity>> fetchBeaconDetails(String? beaconId) {
    return remoteHikeApi.fetchBeaconDetails(beaconId);
  }

  @override
  Future<DataState<LocationEntity>> updateBeaconLocation(
      String? beaconId, Position position) {
    return remoteHikeApi.updateBeaconLocation(
        beaconId, position.latitude.toString(), position.longitude.toString());
  }
}
