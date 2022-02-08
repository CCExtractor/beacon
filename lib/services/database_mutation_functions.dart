import 'dart:async';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/models/landmarks/landmark.dart';
import 'package:beacon/models/location/location.dart';
import 'package:beacon/queries/auth.dart';
import 'package:beacon/queries/beacon.dart';
import 'package:beacon/utilities/constants.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:beacon/models/user/user_info.dart';
import '../locator.dart';

class DataBaseMutationFunctions {
  GraphQLClient clientNonAuth;
  GraphQLClient clientAuth;
  AuthQueries _authQuery;
  BeaconQueries _beaconQuery;
  init() async {
    clientNonAuth = graphqlConfig.clientToQuery();
    clientAuth = await graphqlConfig.authClient();
    _authQuery = AuthQueries();
    _beaconQuery = BeaconQueries();
  }

  GraphQLError userNotFound = const GraphQLError(message: 'User not found');
  GraphQLError userNotAuthenticated = const GraphQLError(
      message: 'Authentication required to perform this action.');
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

  Future<String> signup({String name, String email, String password}) async {
    final QueryResult result = email != null
        ? await clientNonAuth.mutate(MutationOptions(
            document: gql(_authQuery.registerUser(name, email, password))))
        : await clientNonAuth.mutate(
            MutationOptions(document: gql(_authQuery.loginAsGuest(name))));
    if (result.hasException) {
      navigationService
          .showSnackBar("${result.exception.graphqlErrors.first.message}");
      //commenting this since value of exception wasnt used.
      //final bool exception = encounteredExceptionOrError(result.exception);
      debugPrint('${result.exception.graphqlErrors}');
      return exceptionError;
    } else if (result.data != null && result.isConcrete) {
      final User signedInUser =
          User.fromJson(result.data['register'] as Map<String, dynamic>);
      final String logIn = email != null
          ? await databaseFunctions.login(
              email: email, password: password, user: signedInUser)
          : await databaseFunctions.login(user: signedInUser);
      return logIn;
    }
    return otherError;
  }

  Future<String> login({String email, String password, User user}) async {
    final QueryResult result = (email == null)
        ? await clientNonAuth.mutate(
            MutationOptions(document: gql(_authQuery.loginUsingID(user.id))))
        : await clientNonAuth.mutate(MutationOptions(
            document: gql(_authQuery.loginUser(email, password))));
    if (result.hasException) {
      navigationService
          .showSnackBar("${result.exception.graphqlErrors.first.message}");
      print("${result.exception.graphqlErrors}");
      return exceptionError;
    } else if (result.data != null && result.isConcrete) {
      bool userSaved = false;
      if (email == null) {
        user.isGuest = true;
        user.authToken = "Bearer ${result.data['login']}";
        userSaved = await userConfig.updateUser(user);
      } else {
        User loggedInUser =
            User(authToken: "Bearer ${result.data['login']}", isGuest: false);
        userSaved = await userConfig.updateUser(loggedInUser);
      }
      final bool fetchInfo = await databaseFunctions.fetchCurrentUserInfo();
      if (userSaved && fetchInfo)
        return logSuccess;
      else
        return otherError;
    }
    return otherError;
  }

  Future<bool> fetchCurrentUserInfo() async {
    await databaseFunctions.init();
    final QueryResult result = await clientAuth
        .query(QueryOptions(document: gql(_authQuery.fetchUserInfo())));
    if (result.hasException) {
      final bool exception =
          encounteredExceptionOrError(result.exception, showSnackBar: false);
      if (exception) {
        await userConfig.currentUser.delete();
        navigationService.pushReplacementScreen('/auth');
      }
    } else if (result.data != null && result.isConcrete) {
      User userInfo = User.fromJson(
        result.data['me'] as Map<String, dynamic>,
      );
      userInfo.authToken = userConfig.currentUser.authToken;
      userInfo.isGuest = userConfig.currentUser.isGuest;
      await userConfig.updateUser(userInfo);
      return true;
    }
    return false;
  }

  Future<Beacon> fetchBeaconInfo(String id) async {
    final QueryResult result = await clientAuth
        .query(QueryOptions(document: gql(_beaconQuery.fetchBeaconDetail(id))));
    if (result.hasException) {
      final bool exception =
          encounteredExceptionOrError(result.exception, showSnackBar: false);
      if (exception) {
        print('Exception: ${result.exception}');
      }
    } else if (result.data != null && result.isConcrete) {
      final Beacon beacon = Beacon.fromJson(
        result.data['beacon'] as Map<String, dynamic>,
      );
      return beacon;
    }
    return null;
  }

  Future<List<Beacon>> fetchUserBeacons() async {
    List<Beacon> beacons = [];
    Set<String> beaconIds = {};
    List<Beacon> expiredBeacons = [];
    if (!await connectionChecker.checkForInternetConnection()) {
      final userBeacons = hiveDb.getAllUserBeacons();
      if (userBeacons == null) {
        //snackbar has already been shown in getAllUserBeacons;
        return beacons;
      }
      for (Beacon i in userBeacons) {
        if (DateTime.fromMillisecondsSinceEpoch(i.expiresAt)
            .isBefore(DateTime.now()))
          expiredBeacons.add(i);
        else
          beacons.add(i);
      }
      beacons.addAll(expiredBeacons);
      return beacons;
    }

    //if connected to internet take from internet.
    final QueryResult result = await clientAuth
        .query(QueryOptions(document: gql(_authQuery.fetchUserInfo())));
    if (result.hasException) {
      final bool exception =
          encounteredExceptionOrError(result.exception, showSnackBar: false);
      if (exception) {
        print('$exception');
      }
    } else if (result.data != null && result.isConcrete) {
      final User userInfo = User.fromJson(
        result.data['me'] as Map<String, dynamic>,
      );
      for (var i in userInfo.beacon) {
        if (!beaconIds.contains(i.id)) {
          if (!hiveDb.beaconsBox.containsKey(i.id)) {
            //This only happens if a someone else adds user to their beacon (which currently is not possible).
            //beacons are put in box when creating or joining.
            await hiveDb.putBeaconInBeaconBox(i.id, i);
          }
          beaconIds.add(i.id);
          if (DateTime.fromMillisecondsSinceEpoch(i.expiresAt)
              .isBefore(DateTime.now())) {
            expiredBeacons.insert(0, i);
            expiredBeacons.sort((a, b) => a.expiresAt.compareTo(b.expiresAt));
            expiredBeacons = expiredBeacons.reversed.toList();
          } else {
            beacons.add(i);
            beacons.sort((a, b) => a.startsAt.compareTo(b.startsAt));
          }
        }
      }
    }
    beacons.addAll(expiredBeacons);
    return beacons;
  }

  Future<Beacon> createBeacon(String title, int startsAt, int expiresAt) async {
    LatLng loc;
    try {
      loc = await AppConstants.getLocation();
    } catch (onErr) {
      navigationService
          .showSnackBar("$onErr : Allow location access to start beacon");
      return null;
    }
    final QueryResult result = await clientAuth.mutate(MutationOptions(
        document: gql(_beaconQuery.createBeacon(title, startsAt, expiresAt,
            loc.latitude.toString(), loc.longitude.toString()))));
    if (result.hasException) {
      navigationService.showSnackBar(
          "Something went wrong: ${result.exception.graphqlErrors.first.message}");
      print("Something went wrong: ${result.exception}");
    } else if (result.data != null && result.isConcrete) {
      final Beacon beacon = Beacon.fromJson(
        result.data['createBeacon'] as Map<String, dynamic>,
      );
      hiveDb.putBeaconInBeaconBox(beacon.id, beacon);
      return beacon;
    }
    return null;
  }

  Future<Location> updateLeaderLoc(String id, LatLng latLng) async {
    final QueryResult result = await clientAuth.mutate(MutationOptions(
        document: gql(_beaconQuery.updateLeaderLoc(
            id, latLng.latitude.toString(), latLng.longitude.toString()))));
    if (result.hasException) {
      print(
        "Something went wrong: ${result.exception}",
      );
      navigationService.showSnackBar(
          "Something went wrong: ${result.exception.graphqlErrors.first.message}");
    } else if (result.data != null && result.isConcrete) {
      final Location location = Location.fromJson(
        result.data['updateBeaconLocation']['location'] as Map<String, dynamic>,
      );
      print('location update successful');
      return location;
    }
    return null;
  }

  Future<Beacon> joinBeacon(String shortcode) async {
    final QueryResult result = await clientAuth.mutate(
        MutationOptions(document: gql(_beaconQuery.joinBeacon(shortcode))));
    if (result.hasException) {
      navigationService.showSnackBar(
          "Something went wrong: ${result.exception.graphqlErrors.first.message}");
      print("Something went wrong: ${result.exception}");
      navigationService.removeAllAndPush('/main', '/');
    } else if (result.data != null && result.isConcrete) {
      final Beacon beacon = Beacon.fromJson(
        result.data['joinBeacon'] as Map<String, dynamic>,
      );
      if (DateTime.fromMillisecondsSinceEpoch(beacon.expiresAt)
          .isBefore(DateTime.now())) {
        navigationService.showSnackBar(
          "Looks like the beacon you are trying join has expired",
        );
        return null;
      }
      beacon.route.add(beacon.leader.location);
      hiveDb.putBeaconInBeaconBox(beacon.id, beacon);
      return beacon;
    } else {
      navigationService.showSnackBar(
        "Something went wrong while trying to join Beacon",
      );
    }
    return null;
  }

  Future<Landmark> createLandmark(String title, LatLng loc, String id) async {
    await clientAuth
        .mutate(MutationOptions(
            document: gql(_beaconQuery.createLandmark(
                id, loc.latitude.toString(), loc.longitude.toString(), title))))
        .then((value) {
      if (value.hasException) {
        navigationService.showSnackBar(
            "Something went wrong: ${value.exception.graphqlErrors.first.message}");
        print("Something went wrong: ${value.exception}");
      } else if (value.data != null && value.isConcrete) {
        final Landmark landmark = Landmark.fromJson(
          value.data['createLandmark'] as Map<String, dynamic>,
        );
        return landmark;
      }
      return null;
    });
    return null;
  }

  Future<List<Beacon>> fetchNearbyBeacon() async {
    await databaseFunctions.init();
    List<Beacon> _nearbyBeacons = [];
    LatLng loc;
    try {
      loc = await AppConstants.getLocation();
    } catch (onErr) {
      return null;
    }
    final QueryResult result = await clientAuth.query(QueryOptions(
        document: gql(_beaconQuery.fetchNearbyBeacons(
            loc.latitude.toString(), loc.longitude.toString()))));
    if (result.hasException) {
      final bool exception =
          encounteredExceptionOrError(result.exception, showSnackBar: false);
      if (exception) {
        print('${result.exception}');
        return null;
      }
    } else if (result.data != null && result.isConcrete) {
      _nearbyBeacons = (result.data['nearbyBeacons'] as List<dynamic>)
          .map((e) => Beacon.fromJson(e as Map<String, dynamic>))
          .toList();
      _nearbyBeacons.sort((a, b) => a.startsAt.compareTo(b.startsAt));
      return _nearbyBeacons;
    }
    return _nearbyBeacons;
  }
}
