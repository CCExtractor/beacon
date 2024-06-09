import 'package:beacon/Bloc/core/resources/data_state.dart';
import 'package:beacon/Bloc/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/Bloc/domain/entities/location/location_entity.dart';
import 'package:beacon/Bloc/domain/repositories/hike_repository.dart';
import 'package:geolocator/geolocator.dart';

class HikeUseCase {
  final HikeRepository hikeRepository;

  HikeUseCase({required this.hikeRepository});

  Future<DataState<LocationEntity>> updateBeaconLocation(
      String beaconId, Position position) {
    return hikeRepository.updateBeaconLocation(beaconId, position);
  }

  Future<DataState<BeaconEntity>> fetchBeaconDetails(String beaconId) {
    return hikeRepository.fetchBeaconDetails(beaconId);
  }

  Stream<DataState<LocationEntity>> beaconLocationSubscription(
      String beaconId) {
    return hikeRepository.beaconLocationSubscription(beaconId);
  }
}
