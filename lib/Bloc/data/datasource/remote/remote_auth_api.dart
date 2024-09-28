import 'package:beacon/Bloc/core/queries/auth.dart';
import 'package:beacon/Bloc/core/resources/data_state.dart';
import 'package:beacon/Bloc/data/models/user/user_model.dart';
import 'package:beacon/locator.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class RemoteAuthApi {
  final ValueNotifier<GraphQLClient> clientNonAuth;
  GraphQLClient clientAuth;

  RemoteAuthApi({
    required this.clientNonAuth,
    required this.clientAuth,
  });

  AuthQueries _authQueries = AuthQueries();

  Future<DataState<UserModel>> fetchUserInfo() async {
    clientAuth = await graphqlConfig.authClient();

    final isConnected = await utils.checkInternetConnectivity();

    if (!isConnected)
      return DataFailed('Beacon is trying to connect with internet...');

    // api call
    final result = await clientAuth
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

  Future<DataState<UserModel>> register(
      String name, String email, String password) async {
    try {
      final isConnected = await utils.checkInternetConnectivity();

      if (!isConnected)
        return DataFailed('Beacon is trying to connect with internet...');

      final result = await clientNonAuth.value.mutate(
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

  Future<DataState<UserModel>> login(String email, String password) async {
    try {
      final isConnected = await utils.checkInternetConnectivity();

      if (!isConnected) {
        return DataFailed('Beacon is trying to connect with internet...');
      }

      final QueryResult result = await clientNonAuth.value.mutate(
          MutationOptions(
              document: gql(_authQueries.loginUser(email, password))));

      if (result.data != null && result.isConcrete) {
        final token = "Bearer ${result.data!['login']}";

        // storing auth token in hive
        final user =
            UserModel(authToken: token, isGuest: (email == '') ? true : false);
        await localApi.saveUser(user);

        // fetching User Info

        final dataState = await fetchUserInfo();

        if (dataState is DataSuccess) {
          final updatedUser = dataState.data!
              .copyWithModel(authToken: user.authToken, isGuest: user.isGuest);

          // if(locator.isRegistered( ))

          // saving locally
          await localApi.saveUser(updatedUser);

          return dataState;
        }
        return dataState;
      } else if (result.hasException) {
        final message = encounteredExceptionOrError(result.exception!);

        return DataFailed(message);
      }

      return DataFailed('An unexpected error occured.');
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  String encounteredExceptionOrError(OperationException exception) {
    if (exception.linkException != null) {
      debugPrint(exception.linkException.toString());
      return 'Server not running';
    } else {
      return exception.graphqlErrors[0].message.toString();
    }
  }
}
