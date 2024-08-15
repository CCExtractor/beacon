import 'dart:async';

import 'package:beacon/core/queries/beacon.dart';
import 'package:beacon/core/queries/group.dart';
import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/data/models/beacon/beacon_model.dart';
import 'package:beacon/data/models/group/group_model.dart';
import 'package:beacon/data/models/user/user_model.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:beacon/locator.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class RemoteGroupApi {
  late GraphQLClient _authClient;

  RemoteGroupApi(this._authClient);

  void loadClient(GraphQLClient authClient, GraphQLClient subscriptionClient) {
    this._authClient = authClient;
  }

  final _groupqueries = GroupQueries();

  final _beaconQueries = BeaconQueries();

  Future<DataState<List<BeaconModel>>> fetchHikes(
      String groupId, int page, int pageSize) async {
    bool isConnected = await utils.checkInternetConnectivity();

    if (!isConnected) {
      GroupModel? group = await localApi.getGroup(groupId);

      if (group != null && group.beacons != null) {
        int condition = (page - 1) * pageSize + pageSize;
        int beaconLen = group.beacons!.length;

        if (condition > beaconLen) {
          condition = beaconLen;
        }

        List<BeaconModel> beacons = [];

        for (int i = (page - 1) * pageSize; i < condition; i++) {
          BeaconModel? beaconModel =
              await localApi.getBeacon(group.beacons![i]!.id);

          beaconModel != null ? beacons.add(beaconModel) : null;
        }

        return DataSuccess(beacons);
      }

      return DataFailed('Please check your internet connection!');
    }

    final result = await _authClient.query(QueryOptions(
        document: gql(_groupqueries.fetchHikes(groupId, page, pageSize)),
        fetchPolicy: FetchPolicy.networkOnly));

    if (result.data != null && result.isConcrete) {
      List<dynamic> hikesJson = result.data!['beacons'];

      List<BeaconModel> hikes = [];

      for (var hikeJson in hikesJson) {
        BeaconModel hike = BeaconModel.fromJson(hikeJson);
        hikes.add(hike);
        // storing beacon
        await localApi.saveBeacon(hike);
      }

      return DataSuccess(hikes);
    }
    return DataFailed(encounteredExceptionOrError(result.exception!));
  }

  Future<DataState<BeaconModel>> createHike(String title, int startsAt,
      int expiresAt, String lat, String lon, String groupID) async {
    bool isConnected = await utils.checkInternetConnectivity();

    if (!isConnected) {
      return DataFailed('Please check your internet connection!');
    }
    final result = await _authClient.mutate(MutationOptions(
        document: gql(_beaconQueries.createBeacon(
            title, startsAt, expiresAt, lat, lon, groupID))));

    if (result.data != null && result.isConcrete) {
      final hikeJson = result.data!['createBeacon'];

      final beacon = BeaconModel.fromJson(hikeJson);

      // storing beacon
      await localApi.saveBeacon(beacon);
      return DataSuccess(beacon);
    }
    return DataFailed(encounteredExceptionOrError(result.exception!));
  }

  Future<DataState<BeaconModel>> joinHike(String shortcode) async {
    bool isConnected = await utils.checkInternetConnectivity();

    if (!isConnected) {
      return DataFailed('Please check your internet connection!');
    }
    final result = await _authClient.mutate(
        MutationOptions(document: gql(_beaconQueries.joinBeacon(shortcode))));

    if (result.data != null && result.isConcrete) {
      final hikeJosn = result.data!['joinBeacon'];

      final beacon = BeaconModel.fromJson(hikeJosn);

      // storing beacon
      await localApi.saveBeacon(beacon);

      return DataSuccess(beacon);
    }
    return DataFailed(encounteredExceptionOrError(result.exception!));
  }

  Future<DataState<List<BeaconModel>>> nearbyBeacons(
      String id, String lat, String lon, double radius) async {
    bool isConnected = await utils.checkInternetConnectivity();

    if (!isConnected) {
      return DataFailed('Please check your internet connection!');
    }
    final result = await _authClient.mutate(MutationOptions(
        document:
            gql(_beaconQueries.fetchNearbyBeacons(id, lat, lon, radius))));

    if (result.data != null &&
        result.isConcrete &&
        result.data!['nearbyBeacons'] != null) {
      List<dynamic> nearbyBeaconJson = result.data!['nearbyBeacons'];

      List<BeaconModel> nearbyBeacons = nearbyBeaconJson
          .map((beaconJson) => BeaconModel.fromJson(beaconJson))
          .toList();

      // storing beacons
      for (var beacon in nearbyBeacons) {
        await localApi.savenearbyBeacons(beacon);
      }

      return DataSuccess(nearbyBeacons);
    }
    return DataFailed(encounteredExceptionOrError(result.exception!));
  }

  Future<DataState<List<BeaconModel>>> filterBeacons(
      String groupId, String type) async {
    bool isConnected = await utils.checkInternetConnectivity();

    if (!isConnected) {
      return DataFailed('Please check your internet connection!');
    }
    final result = await _authClient.mutate(MutationOptions(
        document: gql(_beaconQueries.filterBeacons(groupId, type))));

    if (result.data != null &&
        result.isConcrete &&
        result.data!['filterBeacons'] != null) {
      List<dynamic> beaconsJson = result.data!['filterBeacons'];

      List<BeaconModel> beacons = beaconsJson
          .map((beaconJson) => BeaconModel.fromJson(beaconJson))
          .toList();

      return DataSuccess(beacons);
    } else {
      return DataFailed(encounteredExceptionOrError(result.exception!));
    }
  }

  Future<DataState<bool>> deleteBeacon(String? beaconId) async {
    bool isConnected = await utils.checkInternetConnectivity();

    if (!isConnected) {
      return DataFailed('Please check your internet connection!');
    }
    final result = await _authClient.mutate(
        MutationOptions(document: gql(_beaconQueries.deleteBeacon(beaconId))));

    if (result.data != null &&
        result.isConcrete &&
        result.data!['deleteBeacon'] != null) {
      bool isDeleted = result.data!['deleteBeacon'];

      return DataSuccess(isDeleted);
    } else {
      return DataFailed(encounteredExceptionOrError(result.exception!));
    }
  }

  Future<DataState<BeaconModel>> rescheduleBeacon(
      int newExpiresAt, int newStartsAt, String beaconId) async {
    bool isConnected = await utils.checkInternetConnectivity();

    if (!isConnected) {
      return DataFailed('Please check your internet connection!');
    }
    final result = await _authClient.mutate(MutationOptions(
        document: gql(_beaconQueries.rescheduleHike(
            newExpiresAt, newStartsAt, beaconId))));

    if (result.data != null &&
        result.isConcrete &&
        result.data!['rescheduleHike'] != null) {
      return DataSuccess(BeaconModel.fromJson(result.data!['rescheduleHike']));
    } else {
      return DataFailed(encounteredExceptionOrError(result.exception!));
    }
  }

  Future<DataState<UserEntity>> removeMember(
      String groupId, String memberId) async {
    bool isConnected = await utils.checkInternetConnectivity();

    if (!isConnected) {
      return DataFailed('Please check your internet connection!');
    }
    final result = await _authClient.mutate(MutationOptions(
        document: gql(_groupqueries.removeMember(groupId, memberId))));

    if (result.data != null &&
        result.isConcrete &&
        result.data!['removeMember'] != null) {
      return DataSuccess(UserModel.fromJson(result.data!['removeMember']));
    } else {
      return DataFailed(encounteredExceptionOrError(result.exception!));
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
