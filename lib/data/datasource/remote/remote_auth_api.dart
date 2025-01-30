import 'dart:async';
import 'dart:developer';

import 'package:beacon/core/queries/auth.dart';
import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/data/datasource/remote/remote_group_api.dart';
import 'package:beacon/data/datasource/remote/remote_hike_api.dart';
import 'package:beacon/data/datasource/remote/remote_home_api.dart';
import 'package:beacon/data/models/user/user_model.dart';
import 'package:beacon/domain/entities/user/user_entity.dart';
import 'package:beacon/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class RemoteAuthApi {
  GraphQLClient clientNonAuth;
  late GraphQLClient _authClient;

  RemoteAuthApi(this._authClient, this.clientNonAuth);

  void loadClient(GraphQLClient newClient) {
    _authClient = newClient;
  }

  AuthQueries _authQueries = AuthQueries();

  Future<DataState<UserModel>> fetchUserInfo() async {
    final isConnected = await utils.checkInternetConnectivity();

    if (!isConnected)
      return DataFailed('Beacon is trying to connect with internet...');

    var _authClient = await graphqlConfig.authClient();
    // api call
    final result = await _authClient
        .mutate(MutationOptions(document: gql(_authQueries.fetchUserInfo())));

    if (result.data != null && result.isConcrete) {
      final json = result.data!['me'];
      final user = UserModel.fromJson(json);

      final currentUser = await localApi.fetchUser();

      // checking if user is login
      if (currentUser == null) return DataFailed('Please login first');
      final newUser = user.copyWithModel(
          authToken: currentUser.authToken,
          isGuest: user.email == '' ? true : false);

      // saving user details locally
      await localApi.saveUser(newUser);

      // returning
      return DataSuccess(newUser);
    }
    return DataFailed(encounteredExceptionOrError(result.exception!));
  }

  Future<DataState<UserEntity>> register(
      String name, String email, String password) async {
    try {
      final isConnected = await utils.checkInternetConnectivity();

      if (!isConnected)
        return DataFailed('Beacon is trying to connect with internet...');

      final result = await clientNonAuth.mutate(
        MutationOptions(
          document: gql(_authQueries.registerUser(name, email, password)),
        ),
      );

      if (result.data != null && result.isConcrete) {
        // LOGIN API CALL
        final dataState = await login(email, password);
        return dataState;
      } else if (result.hasException) {
        final message = encounteredExceptionOrError(result.exception!);
        return DataFailed(message);
      }

      return DataFailed('An unexpected error occurred during registration.');
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  Future<DataState<UserEntity>> gAuth(String name, String email) async {
    log('name: $name');
    log('email: $email');

    final isConnected = await utils.checkInternetConnectivity();

    if (!isConnected) {
      return DataFailed('Beacon is trying to connect with internet...');
    }

    final QueryResult result = await clientNonAuth.mutate(
        MutationOptions(document: gql(_authQueries.gAuth(name, email))));

    log(result.toString());

    if (result.data != null && result.isConcrete) {
      final token = "Bearer ${result.data!['oAuth']}";

      UserModel? user;

      user = UserModel(authToken: token, isGuest: false);

      // storing auth token in hive
      await localApi.saveUser(user);

      // loading clients
      final authClient = await graphqlConfig.authClient();
      final subscriptionClient = await graphqlConfig.graphQlClient();
      locator<RemoteAuthApi>().loadClient(authClient);
      locator<RemoteHomeApi>().loadClient(authClient, subscriptionClient);
      locator<RemoteGroupApi>().loadClient(authClient, subscriptionClient);
      locator<RemoteHikeApi>().loadClient(authClient, subscriptionClient);

      // fetching User Info

      final dataState = await fetchUserInfo();

      if (dataState is DataSuccess) {
        final updatedUser = dataState.data!
            .copyWithModel(authToken: user.authToken, isGuest: user.isGuest);

        // saving locally
        await localApi.saveUser(updatedUser);

        return DataSuccess(updatedUser);
      }
    } else if (result.hasException) {
      final message = encounteredExceptionOrError(result.exception!);

      return DataFailed(message);
    }

    return DataFailed('An unexpected error occured.');
  }

  Future<DataState<UserEntity>> login(String email, String password) async {
    log('calling login function $email');
    final isConnected = await utils.checkInternetConnectivity();

    if (!isConnected) {
      return DataFailed('Beacon is trying to connect with internet...');
    }

    final QueryResult result = await clientNonAuth.mutate(MutationOptions(
        document: gql(_authQueries.loginUser(email, password))));

    if (result.data != null && result.isConcrete) {
      final token = "Bearer ${result.data!['login']}";

      UserModel? user;

      // if (email.isEmpty) {
      //   user = UserModel(authToken: token, isGuest: true);
      // } else {
      user = UserModel(authToken: token, isGuest: false);
      // }

      // storing auth token in hive
      await localApi.saveUser(user);

      // loading clients
      final authClient = await graphqlConfig.authClient();
      final subscriptionClient = await graphqlConfig.graphQlClient();
      locator<RemoteAuthApi>().loadClient(authClient);
      locator<RemoteHomeApi>().loadClient(authClient, subscriptionClient);
      locator<RemoteGroupApi>().loadClient(authClient, subscriptionClient);
      locator<RemoteHikeApi>().loadClient(authClient, subscriptionClient);

      // fetching User Info

      final dataState = await fetchUserInfo();

      if (dataState is DataSuccess) {
        final updatedUser = dataState.data!
            .copyWithModel(authToken: user.authToken, isGuest: user.isGuest);

        // saving locally
        await localApi.saveUser(updatedUser);

        return DataSuccess(updatedUser);
      }
    } else if (result.hasException) {
      final message = encounteredExceptionOrError(result.exception!);

      return DataFailed(message);
    }

    return DataFailed('An unexpected error occured.');
  }

  Future<DataState<String>> sendVerificationCode() async {
    final isConnected = await utils.checkInternetConnectivity();

    if (!isConnected) {
      return DataFailed('Beacon is trying to connect with internet...');
    }
    final UserModel? user = await localApi.fetchUser();
    final QueryResult result = await _authClient.mutate(MutationOptions(
        document: gql(_authQueries.sendVerficationCode(
      user!.email,
    ))));

    if (result.data != null && result.isConcrete) {
      return DataSuccess(result.data!['sendVerificationCode'] as String);
    }
    return DataFailed(encounteredExceptionOrError(result.exception!));
  }

  Future<DataState<UserEntity>> completeVerification() async {
    final isConnected = await utils.checkInternetConnectivity();

    if (!isConnected) {
      return DataFailed('Beacon is trying to connect with internet...');
    }
    final UserModel? user = await localApi.fetchUser();
    var authClient = await graphqlConfig.authClient();

    final QueryResult result = await authClient.mutate(MutationOptions(
        document: gql(_authQueries.completeVerificationCode(user!.id))));

    if (result.data != null && result.isConcrete) {
      var user = UserModel.fromJson(result.data!['completeVerification']);
      var currentUser = await localApi.fetchUser();
      currentUser = currentUser!.copyWithModel(isVerified: user.isVerified);
      await localApi.saveUser(currentUser);
      return DataSuccess(user);
    }
    return DataFailed(encounteredExceptionOrError(result.exception!));
  }

  String encounteredExceptionOrError(OperationException exception) {
    if (exception.linkException != null) {
      debugPrint(exception.linkException.toString());
      return 'Something went wrong';
    } else {
      return exception.graphqlErrors[0].message.toString();
    }
  }
}
