import 'package:beacon/Bloc/core/queries/beacon.dart';
import 'package:beacon/Bloc/core/queries/group.dart';
import 'package:beacon/Bloc/core/resources/data_state.dart';
import 'package:beacon/Bloc/data/models/beacon/beacon_model.dart';
import 'package:beacon/locator.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class RemoteGroupApi {
  final GraphQLClient authClient;

  RemoteGroupApi({required this.authClient});

  final _groupqueries = GroupQueries();

  final _beaconQueries = BeaconQueries();

  Future<DataState<List<BeaconModel>>> fetchHikes(
      String groupId, int page, int pageSize) async {
    bool isConnected = await utils.checkInternetConnectivity();

    if (!isConnected) {
      return DataFailed('Please check your internet connection!');
    }

    final authClient = await graphqlConfig.authClient();
    final result = await authClient.query(QueryOptions(
        document: gql(_groupqueries.fetchHikes(groupId, page, pageSize))));

    if (result.data != null && result.isConcrete) {
      List<dynamic> hikesJson = result.data!['beacons'];

      List<BeaconModel> hikes = [];

      for (var hikeJson in hikesJson) {
        hikes.add(BeaconModel.fromJson(hikeJson));
      }

      return DataSuccess(hikes);
    }
    return DataFailed(encounteredExceptionOrError(result.exception!));
  }

  Future<DataState<BeaconModel>> createHike(String title, int startsAt,
      int expiresAt, String lat, String lon, String groupID) async {
    final authClient = await graphqlConfig.authClient();

    bool isConnected = await utils.checkInternetConnectivity();

    if (!isConnected) {
      return DataFailed('Please check your internet connection!');
    }
    final result = await authClient.mutate(MutationOptions(
        document: gql(_beaconQueries.createBeacon(
            title, startsAt, expiresAt, lat, lon, groupID))));

    if (result.data != null && result.isConcrete) {
      final hikeJson = result.data!['createBeacon'];

      final beacon = BeaconModel.fromJson(hikeJson);
      return DataSuccess(beacon);
    }
    return DataFailed(encounteredExceptionOrError(result.exception!));
  }

  Future<DataState<BeaconModel>> joinHike(String shortcode) async {
    bool isConnected = await utils.checkInternetConnectivity();

    if (!isConnected) {
      return DataFailed('Please check your internet connection!');
    }
    final authClient = await graphqlConfig.authClient();
    final result = await authClient.mutate(
        MutationOptions(document: gql(_beaconQueries.joinBeacon(shortcode))));

    if (result.data != null && result.isConcrete) {
      final hikeJosn = result.data!['joinBeacon'];

      final beacon = BeaconModel.fromJson(hikeJosn);

      return DataSuccess(beacon);
    }
    return DataFailed(encounteredExceptionOrError(result.exception!));
  }

  String encounteredExceptionOrError(OperationException exception) {
    if (exception.linkException != null) {
      return 'Server not running';
    } else {
      return exception.graphqlErrors[0].message.toString();
    }
  }
}
