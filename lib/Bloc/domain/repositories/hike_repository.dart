import 'package:beacon/Bloc/core/resources/data_state.dart';
import 'package:beacon/Bloc/domain/entities/beacon/beacon_entity.dart';
import 'package:beacon/Bloc/domain/entities/location/location_entity.dart';
import 'package:geolocator/geolocator.dart';

abstract class HikeRepository {
  Future<DataState<LocationEntity>> updateBeaconLocation(
      String? beaconId, Position position);
  Future<DataState<BeaconEntity>> fetchBeaconDetails(String? beaconId);
  Stream<DataState<LocationEntity>> beaconLocationSubscription(
      String? beaconId);
}
