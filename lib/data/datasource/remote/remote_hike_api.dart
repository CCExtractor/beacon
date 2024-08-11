import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:beacon/core/queries/beacon.dart';
import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/data/models/beacon/beacon_model.dart';
import 'package:beacon/data/models/geofence/geofence_model.dart';
import 'package:beacon/data/models/landmark/landmark_model.dart';
import 'package:beacon/data/models/location/location_model.dart';
import 'package:beacon/data/models/subscriptions/beacon_locations_model/beacon_locations_model.dart';
import 'package:beacon/data/models/subscriptions/join_leave_beacon_model/join_leave_beacon_model.dart';
import 'package:beacon/data/models/user/user_model.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:beacon/locator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;

class RemoteHikeApi {
  late GraphQLClient _authClient;
  late GraphQLClient _subscriptionClient;

  RemoteHikeApi(this._authClient, this._subscriptionClient);

  final beaconQueries = BeaconQueries();

  void loadClient(GraphQLClient authClient, GraphQLClient subscriptionClient) {
    this._authClient = authClient;
    this._subscriptionClient = subscriptionClient;
  }

  Future<DataState<BeaconModel>> fetchBeaconDetails(String beaconId) async {
    bool isConnected = await utils.checkInternetConnectivity();
    if (!isConnected) {}

    final result = await _authClient.mutate(MutationOptions(
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

    final result = await _authClient.mutate(MutationOptions(
        document: gql(beaconQueries.updateBeaconLocation(beaconId, lat, lon))));

    if (result.isConcrete && result.data != null) {
      final beaconJson = result.data!['updateBeaconLocation'];

      final location = LocationModel.fromJson(beaconJson);
      return DataSuccess(location);
    }
    return DataFailed(encounteredExceptionOrError(result.exception!));
  }

  Future<DataState<GeofenceModel>> createGeofence(
      String beaconId, LatLng latlng, double radius) async {
    bool isConnected = await utils.checkInternetConnectivity();
    if (!isConnected) {}

    final result = await _authClient.mutate(MutationOptions(
        document: gql(beaconQueries.createGeofence(beaconId,
            latlng.latitude.toString(), latlng.longitude.toString(), radius))));

;
    if (result.isConcrete && result.data != null) {
      final beaconJson = result.data!['createGeofence'];
      try {
        var geofence = GeofenceModel.fromJson(beaconJson);
        return DataSuccess(geofence);
      } catch (e) {
        log(e.toString());
      }
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

    final subscriptionOptions = SubscriptionOptions(
      document: beaconQueries.beaconLocationSubGql,
      variables: {
        'id': beaconId,
      },
    );

    final authClient = await graphqlConfig.graphQlClient();

    final resultStream = authClient.subscribe(subscriptionOptions);

    await for (final result in resultStream) {
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
  }

  Stream<DataState<UserModel>> beaconJoinedSubscription(
      String beaconId) async* {
    bool isConnected = await utils.checkInternetConnectivity();
    if (!isConnected) {
      yield DataFailed("No internet connection");
      return;
    }

    final subscriptionOptions = SubscriptionOptions(
      document: beaconQueries.beaconJoinedSubGql,
      variables: {
        'id': beaconId,
      },
    );

    final authClient = await graphqlConfig.graphQlClient();

    final resultStream = await authClient.subscribe(subscriptionOptions);

    await for (var result in resultStream) {
      if (result.isConcrete &&
          result.data != null &&
          result.data!['beaconJoined'] != null) {
        final newMember = UserModel.fromJson(result.data!['beaconJoined']);
        yield DataSuccess(newMember);
      }
      yield DataFailed(encounteredExceptionOrError(result.exception!));
    }
  }

  Stream<DataState<dynamic>> beaconUpdateSubscription(String beaconId) async* {
    final isConnected = await utils.checkInternetConnectivity();

    if (!isConnected) {
      yield DataFailed('No internet connection');
      return;
    }

    final subscriptionOptions = SubscriptionOptions(
        document: beaconQueries.beaconUpdateSubGql,
        variables: {'id': beaconId});

    final resultStream =
        await _subscriptionClient.subscribe(subscriptionOptions);

    await for (var result in resultStream) {
      if (result.isConcrete &&
          result.data != null &&
          result.data!['updateBeacon'] != null) {
        Map<String, dynamic> beaconJson =
            result.data!['updateBeacon'] as Map<String, dynamic>;

        if (beaconJson['user'] != null) {
          UserModel newUser = UserModel.fromJson(beaconJson['user']);

          yield DataSuccess(newUser);
          // return user
        }
        if (beaconJson['landmark'] != null) {
          LandMarkModel newLandmark =
              LandMarkModel.fromJson(beaconJson['landmark']);

          yield DataSuccess(newLandmark);
          // return landmark
        }
      } else {
        yield DataFailed(encounteredExceptionOrError(result.exception!));
      }
    }
  }

  Future<DataState<UserEntity>> changeUserLocation(
      String beaconId, LatLng latlng) async {
    bool isConnected = await utils.checkInternetConnectivity();

    if (!isConnected) {
      return DataFailed('No internet connection');
    }

    final result = await _authClient.mutate(MutationOptions(
        document: gql(beaconQueries.changeUserLocation(beaconId,
            latlng.latitude.toString(), latlng.longitude.toString()))));



    if (result.isConcrete &&
        result.data != null &&
        result.data!['updateUserLocation'] != null) {
      final user = UserModel.fromJson(result.data!['updateUserLocation']);
      return DataSuccess(user);
    } else {
      return DataFailed(encounteredExceptionOrError(result.exception!));
    }
  }

  Future<DataState<LandMarkModel>> createLandMark(
      String id, String lat, String lon, String title) async {
    bool isConnected = await utils.checkInternetConnectivity();

    if (!isConnected) {
      return DataFailed('No internet connection');
    }

    final result = await _authClient.mutate(MutationOptions(
        document: gql(beaconQueries.createLandmark(id, lat, lon, title))));

    if (result.isConcrete &&
        result.data != null &&
        result.data!['createLandmark'] != null) {
      final newLandMark =
          LandMarkModel.fromJson(result.data!['createLandmark']);
      return DataSuccess(newLandMark);
    } else {
      return DataFailed(encounteredExceptionOrError(result.exception!));
    }
  }

  Stream<DataState<BeaconLocationsModel>> locationUpdateSubscription(
      String beaconId) async* {
    bool isConnected = await utils.checkInternetConnectivity();

    if (!isConnected) {
      yield DataFailed('No internet connection');
    }

    final subscriptionOptions = SubscriptionOptions(
        document: beaconQueries.locationUpdateGQL, variables: {'id': beaconId});

    final resultStream =
        await _subscriptionClient.subscribe(subscriptionOptions);

    await for (var stream in resultStream) {
      if (stream.hasException) {
        yield DataFailed('Something went wrong');
      } else {
        var locations =
            BeaconLocationsModel.fromJson(stream.data!['beaconLocations']);
        yield DataSuccess(locations);
      }
    }
  }

  Stream<DataState<JoinLeaveBeaconModel>> LeaveJoinBeaconSubscription(
      String beaconId) async* {
    bool isConnected = await utils.checkInternetConnectivity();

    if (!isConnected) {
      yield DataFailed('No internet connection');
    }

    final subscriptionOptions = SubscriptionOptions(
        document: beaconQueries.joinleaveBeaconSubGql,
        variables: {'id': beaconId});

    final resultStream =
        await _subscriptionClient.subscribe(subscriptionOptions);

    await for (var stream in resultStream) {
      if (stream.hasException) {
        yield DataFailed('Something went wrong');
      } else {
        var locations =
            JoinLeaveBeaconModel.fromJson(stream.data!['JoinLeaveBeacon']);
        yield DataSuccess(locations);
      }
    }
  }

  Future<DataState<bool>> addRoute(String id, LatLng latlng) async {
    bool isConnected = await utils.checkInternetConnectivity();

    if (!isConnected) {
      return DataFailed('No internet connection');
    }

    final result = await _authClient.mutate(
        MutationOptions(document: gql(beaconQueries.addRoute(id, latlng))));

    if (result.isConcrete &&
        result.data != null &&
        result.data!['addRoute'] != null) {
      return DataSuccess(result.data!['addRoute']);
    } else {
      return DataSuccess(false);
    }
  }

  Future<DataState<UserEntity>> sos(String id) async {
    bool isConnected = await utils.checkInternetConnectivity();

    if (!isConnected) {
      return DataFailed('No internet connection');
    }

    final result = await _authClient
        .mutate(MutationOptions(document: gql(beaconQueries.sos(id))));

    if (result.isConcrete &&
        result.data != null &&
        result.data!['sos'] != null) {
      return DataSuccess(UserModel.fromJson(result.data!['sos']));
    } else {
      return DataFailed(utils.filterException(result.exception!));
    }
  }

  Future<DataState<List<LatLng>>> getRoute(List<LatLng> latlng) async {
    bool isConnected = await utils.checkInternetConnectivity();

    if (!isConnected) {
      return DataFailed('No internet connection');
    }

    List<List<double>> coordinates = [];

    for (var coord in latlng) {
      coordinates.add([coord.latitude, coord.longitude]);
    }

    final response = await http.post(
        Uri.parse(
            'https://api.openrouteservice.org/v2/directions/foot-hiking/gpx'),
        headers: {
          "Authorization":
              "5b3ce3597851110001cf6248873a3b4f20c445c98808378287166ec0",
          "Content-Type": "application/json"
        },
        body: jsonEncode({"coordinates": coordinates}));


    if (response.statusCode == 200) {
      return DataSuccess([]);
    }
    return DataSuccess([]);
  }

  String encounteredExceptionOrError(OperationException exception) {
    if (exception.linkException != null) {
      return 'Server not running';
    } else {
      return exception.graphqlErrors[0].message.toString();
    }
  }
}
