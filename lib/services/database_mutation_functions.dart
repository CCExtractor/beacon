import 'package:beacon/api/queries.dart';
import 'package:beacon/services/navigation_service.dart';
import 'package:beacon/services/user_config.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:beacon/models/user/user_info.dart';
import 'package:beacon/services/graphql_config.dart';

import '../locator.dart';

class DataBaseMutationFunctions {
  GraphQLClient clientNonAuth;
  GraphQLClient clientAuth;
  Queries _query;

  init() {
    clientNonAuth = graphqlConfig.clientToQuery();
    clientAuth = graphqlConfig.authClient();
    _query = Queries();
  }

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
      final bool userSaved = await UserConfig().updateUser(signedInUser);
      final bool tokenRefreshed = await GraphQLConfig().getToken() as bool;
      return userSaved && tokenRefreshed;
    }
    return false;
  }

  Future<bool> login(String id, String email, String password) async {
    final QueryResult result = await clientNonAuth.mutate(
        MutationOptions(document: gql(_query.loginUser(id, email, password))));
    if (result.hasException) {
      final bool exception = encounteredExceptionOrError(result.exception);
      NavigationService().pop();
    } else if (result.data != null && result.isConcrete) {
      final User loggedInUser =
          User.fromJson(result.data['login'] as Map<String, dynamic>);
      final bool userSaved = await UserConfig().updateUser(loggedInUser);
      final bool tokenRefreshed = await GraphQLConfig().getToken() as bool;
      return userSaved && tokenRefreshed;
    }
    return false;
  }

  Future<bool> fetchCurrentUserInfo() async {
    final QueryResult result = await clientAuth
        .query(QueryOptions(document: gql(_query.fetchUserInfo)));

    if (result.hasException) {
      final bool exception =
          encounteredExceptionOrError(result.exception, showSnackBar: false);
      if (exception) {
        fetchCurrentUserInfo();
      } else {
        // navigatorService.pop();
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
}
