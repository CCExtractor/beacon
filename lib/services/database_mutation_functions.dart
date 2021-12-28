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

  Future<bool> signup({String name, String email, String password}) async {
    final QueryResult result = email != null
        ? await clientNonAuth.mutate(MutationOptions(
            document: gql(_authQuery.registerUser(name, email, password))))
        : await clientNonAuth.mutate(
            MutationOptions(document: gql(_authQuery.loginAsGuest(name))));
    if (result.hasException) {
      //commenting this since value of exception wasnt used.
      //final bool exception = encounteredExceptionOrError(result.exception);
      debugPrint('${result.exception.graphqlErrors}');
      return false;
    } else if (result.data != null && result.isConcrete) {
      final User signedInUser =
          User.fromJson(result.data['register'] as Map<String, dynamic>);
      final bool logIn = email != null
          ? await databaseFunctions.login(
              email: email, password: password, user: signedInUser)
          : await databaseFunctions.login(user: signedInUser);
      return logIn;
    }
    return false;
  }

  Future<bool> login({String email, String password, User user}) async {
    final QueryResult result = (email == null)
        ? await clientNonAuth.mutate(
            MutationOptions(document: gql(_authQuery.loginUsingID(user.id))))
        : await clientNonAuth.mutate(MutationOptions(
            document: gql(_authQuery.loginUser(email, password))));
    if (result.hasException) {
      navigationService
          .showSnackBar("${result.exception.graphqlErrors.first.message}");
      print("${result.exception.graphqlErrors}");
      return false;
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
      return userSaved && fetchInfo;
    }
    return false;
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
          beaconIds.add(i.id);
          beacons.add(i);
        }
      }
    }
    return beacons;
  }

  Future<Beacon> createBeacon(String title, int expiresAt) async {
    LatLng loc;
    try {
      loc = await AppConstants.getLocation();
    } catch (onErr) {
      navigationService
          .showSnackBar("$onErr : Allow location access to start beacon");
      return null;
    }
    final QueryResult result = await clientAuth.mutate(MutationOptions(
        document: gql(_beaconQuery.createBeacon(title, expiresAt,
            loc.latitude.toString(), loc.longitude.toString()))));
    if (result.hasException) {
      navigationService.showSnackBar(
          "Something went wrong: ${result.exception.graphqlErrors.first.message}");
      print("Something went wrong: ${result.exception}");
    } else if (result.data != null && result.isConcrete) {
      final Beacon beacon = Beacon.fromJson(
        result.data['createBeacon'] as Map<String, dynamic>,
      );
      return beacon;
    }
    return null;
  }

  Future<Location> updateLeaderLoc(String id, LatLng latLng) async {
    final QueryResult result = await clientAuth.mutate(MutationOptions(
        document: gql(_beaconQuery.updateLeaderLoc(
            id, latLng.latitude.toString(), latLng.longitude.toString()))));
    if (result.hasException) {
      print("Something went wrong: ${result.exception}");
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
      beacon.route.add(beacon.leader.location);
      return beacon;
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
      return _nearbyBeacons;
    }
    return _nearbyBeacons;
  }
}
