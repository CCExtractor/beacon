import 'dart:async';
import 'dart:ffi';

import 'package:beacon/api/queries.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/models/location/location.dart';
import 'package:beacon/services/navigation_service.dart';
import 'package:beacon/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:beacon/models/user/user_info.dart';
import '../locator.dart';

class DataBaseMutationFunctions {
  GraphQLClient clientNonAuth;
  GraphQLClient clientAuth;
  GraphQLClient webSocketClient;
  Queries _query;
  Stream<Location> _locationStream;
  init() {
    clientNonAuth = graphqlConfig.clientToQuery();
    clientAuth = graphqlConfig.authClient();
    webSocketClient = graphqlConfig.webSocketClient();
    _query = Queries();
  }

  Stream<Location> get locationStream => _locationStream;

  GraphQLError userNotFound = const GraphQLError(message: 'User not found');
  GraphQLError userNotAuthenticated =
      const GraphQLError(message: 'User is not authenticated');
  GraphQLError emailAccountPresent =
      const GraphQLError(message: 'Email address already exists');
  GraphQLError wrongCredentials =
      const GraphQLError(message: 'Invalid credentials');

  bool encounteredExceptionOrError(OperationException exception,
      {bool showSnackBar = true}) {
    if (exception.linkException != null) {
      debugPrint(exception.linkException.toString());
      if (showSnackBar) {
        debugPrint("Server not running/wrong url");
      }
      return false;
    } else {
      debugPrint(exception.graphqlErrors.toString());
      for (int i = 0; i < exception.graphqlErrors.length; i++) {
        if (exception.graphqlErrors[i].message ==
            userNotAuthenticated.message) {
          return true;
        } else if (exception.graphqlErrors[i].message == userNotFound.message) {
          if (showSnackBar) {
            navigationService
                .showSnackBar("No account registered with this email");
          }
          return false;
        } else if (exception.graphqlErrors[i].message ==
            wrongCredentials.message) {
          if (showSnackBar) {
            navigationService.showSnackBar("Enter a valid password");
          }
          return false;
        } else if (exception.graphqlErrors[i].message ==
            emailAccountPresent.message) {
          if (showSnackBar) {
            navigationService
                .showSnackBar("Account with this email already registered");
          }
          return false;
        }
      }
      print("Something went wrong");
      return false;
    }
  }

  Future<Map<String, dynamic>> gqlquery(String query) async {
    final QueryOptions options = QueryOptions(
      document: gql(query),
      variables: <String, dynamic>{},
    );

    final QueryResult result = await clientAuth.query(options);
    if (result.hasException) {
      final bool exception =
          encounteredExceptionOrError(result.exception, showSnackBar: false);
      if (exception) debugPrint("Exception Occured");
    } else if (result.data != null && result.isConcrete) {
      return result.data;
    }

    return result.data;
  }

  Future<bool> signup(String name, String email, String password) async {
    final QueryResult result = await clientNonAuth.mutate(MutationOptions(
        document: gql(_query.registerUser(name, email, password))));
    if (result.hasException) {
      final bool exception = encounteredExceptionOrError(result.exception);
      NavigationService().pop();
    } else if (result.data != null && result.isConcrete) {
      final User signedInUser =
          User.fromJson(result.data['register'] as Map<String, dynamic>);
      final bool userSaved = await userConfig.updateUser(signedInUser);
      final bool tokenRefreshed = await graphqlConfig.getToken() as bool;
      return userSaved && tokenRefreshed;
    }
    return false;
  }

  Future<bool> login(String email, String password) async {
    final QueryResult result = await clientNonAuth.mutate(
        MutationOptions(document: gql(_query.loginUser(email, password))));
    if (result.hasException) {
      final bool exception = encounteredExceptionOrError(result.exception);
      NavigationService().pop();
    } else if (result.data != null && result.isConcrete) {
      final User loggedInUser =
          User(authToken: result.data['login'], id: 'null');
      final bool userSaved = await userConfig.updateUser(loggedInUser);
      final bool fetchInfo = await databaseFunctions.fetchCurrentUserInfo();
      return userSaved && fetchInfo;
    }
    return false;
  }

  Future<bool> fetchCurrentUserInfo() async {
    final QueryResult result = await clientAuth
        .query(QueryOptions(document: gql(_query.fetchUserInfo())));
    if (result.hasException) {
      final bool exception =
          encounteredExceptionOrError(result.exception, showSnackBar: false);
      if (exception) {
        fetchCurrentUserInfo();
      } else {
        navigationService.pop();
      }
    } else if (result.data != null && result.isConcrete) {
      final User userInfo = User.fromJson(
        result.data['me'] as Map<String, dynamic>,
      );
      userInfo.authToken = userConfig.currentUser.authToken;
      userConfig.updateUser(userInfo);
      return true;
    }
    return false;
  }

  Future<Beacon> createBeacon(String title, int expiresAt) async {
    final QueryResult result = await clientAuth.mutate(
        MutationOptions(document: gql(_query.createBeacon(title, expiresAt))));
    if (result.hasException) {
      navigationService
          .showSnackBar("Something went wrong: ${result.exception}");
      print("Something went wrong: ${result.exception}");
      navigationService.pop();
    } else if (result.data != null && result.isConcrete) {
      final Beacon beacon = Beacon.fromJson(
        result.data['createBeacon'] as Map<String, dynamic>,
      );
      LatLng loc = await AppConstants.getLocation();
      final Location updateLeaderLoc =
          await databaseFunctions.updateLeaderLoc(beacon.id, loc);
      beacon.route.add(updateLeaderLoc);
      return beacon;
    }
    return null;
  }

  Future<Location> updateLeaderLoc(String id, LatLng latLng) async {
    final QueryResult result = await clientAuth.mutate(MutationOptions(
        document: gql(_query.updateLeaderLoc(
            id, latLng.latitude.toString(), latLng.longitude.toString()))));
    if (result.hasException) {
      print("Something went wrong: ${result.exception}");
      navigationService.showSnackBar(
          "Something went wrong in updating location: ${result.exception}");
      navigationService.pop();
    } else if (result.data != null && result.isConcrete) {
      final Location location = Location.fromJson(
        result.data['updateLocation'] as Map<String, dynamic>,
      );
      return location;
    }
    return null;
  }

  Future<Beacon> joinBeacon(String shortcode) async {
    final QueryResult result = await clientAuth
        .mutate(MutationOptions(document: gql(_query.joinBeacon(shortcode))));
    if (result.hasException) {
      navigationService
          .showSnackBar("Something went wrong: ${result.exception}");
      print("Something went wrong: ${result.exception}");
      navigationService.pop();
    } else if (result.data != null && result.isConcrete) {
      final Beacon beacon = Beacon.fromJson(
        result.data['joinBeacon'] as Map<String, dynamic>,
      );
      beacon.route.add(beacon.leader.location.last);
      final Stream<QueryResult> _loc = clientAuth.subscribe(SubscriptionOptions(
          document: gql(_query.fetchLocationUpdates(beacon.id))));
      _locationStream =
          _loc.map((event) => Location.fromJson(event.data['leaderLocation']));
      return beacon;
    }
    return null;
  }
}
