import 'dart:developer';

import 'package:beacon/Bloc/core/queries/beacon.dart';
import 'package:beacon/Bloc/core/resources/data_state.dart';
import 'package:beacon/Bloc/data/models/beacon/beacon_model.dart';
import 'package:beacon/Bloc/data/models/location/location_model.dart';
import 'package:beacon/locator.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class RemoteHikeApi {
  final GraphQLClient authClient;

  RemoteHikeApi(this.authClient);

  final beaconQueries = BeaconQueries();

  Future<DataState<BeaconModel>> fetchBeaconDetails(String? beaconId) async {
    bool isConnected = await utils.checkInternetConnectivity();
    if (!isConnected) {}

    final result = await authClient.mutate(MutationOptions(
        document: gql(beaconQueries.fetchBeaconDetail(beaconId))));

    if (result.isConcrete && result.data != null) {
      final beaconJson = result.data!['beacon'];

      final beacon = BeaconModel.fromJson(beaconJson);
      return DataSuccess(beacon);
    }
    return DataFailed(encounteredExceptionOrError(result.exception!));
  }

  Future<DataState<LocationModel>> updateBeaconLocation(
      String? beaconId, String lat, String lon) async {
    bool isConnected = await utils.checkInternetConnectivity();
    if (!isConnected) {}

    final result = await authClient.mutate(MutationOptions(
        document: gql(beaconQueries.updateBeaconLocation(beaconId, lat, lon))));

    log(result.toString());

    if (result.isConcrete && result.data != null) {
      final beaconJson = result.data!['updateBeaconLocation'];

      final location = LocationModel.fromJson(beaconJson);
      return DataSuccess(location);
    }
    return DataFailed(encounteredExceptionOrError(result.exception!));
  }

  Stream<DataState<LocationModel>> beaconLocationSubscription(
      String? beaconId) async* {
    bool isConnected = await utils.checkInternetConnectivity();
    if (!isConnected) {
      yield DataFailed("No internet connection");
      return;
    }

    try {
      final subscriptionOptions = SubscriptionOptions(
        document: beaconQueries.beaconLocationSubGql,
        variables: {
          'id': beaconId,
        },
      );

      final authClient = await graphqlConfig.authClient();

      final resultStream = authClient.subscribe(subscriptionOptions);

      await for (final result in resultStream) {
        log('subscription: ${result.toString()}');
        if (result.isConcrete &&
            result.data != null &&
            result.data!['beaconLocation'] != null) {
          final locationJson = result.data!['beaconLocation'];
          final location = LocationModel.fromJson(locationJson);
          yield DataSuccess(location);
        } else if (result.hasException) {
          yield DataFailed(encounteredExceptionOrError(result.exception!));
        }
      }
    } catch (e) {
      log('subscription error: $e');
      yield DataFailed('subscription error: $e');
    }
  }

  String encounteredExceptionOrError(OperationException exception) {
    if (exception.linkException != null) {
      return 'Server not running';
    } else {
      return exception.graphqlErrors[0].message.toString();
    }
  }
}
