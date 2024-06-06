import 'dart:developer';

import 'package:beacon/Bloc/core/queries/group.dart';
import 'package:beacon/Bloc/core/resources/data_state.dart';
import 'package:beacon/Bloc/data/models/group/group_model.dart';
import 'package:beacon/locator.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class RemoteHomeApi {
  final GraphQLClient _clientAuth;
  RemoteHomeApi(this._clientAuth);

  final _groupQueries = GroupQueries();

  Future<DataState<List<GroupModel>>> fetchUserGroups(
      int page, int pageSize) async {
    final clientAuth = await graphqlConfig.authClient();
    log(_clientAuth.toString());
    final result = await clientAuth.query(QueryOptions(
        document: gql(_groupQueries.fetchUserGroups(page, pageSize))));

    if (result.data != null && result.isConcrete) {
      List<GroupModel> groups = [];
      List<dynamic> groupsData = result.data!['groups'];
      for (var groupData in groupsData) {
        final group = GroupModel.fromJson(groupData);
        groups.add(group);
      }
      return DataSuccess(groups);
    }

    return DataFailed(encounteredExceptionOrError(result.exception!));
  }

  Future<DataState<GroupModel>> createGroup(String title) async {
    final _clientAuth = await graphqlConfig.authClient();
    final result = await _clientAuth.mutate(
        MutationOptions(document: gql(_groupQueries.createGroup(title))));

    if (result.data != null && result.isConcrete) {
      GroupModel group = GroupModel.fromJson(
          result.data!['createGroup'] as Map<String, dynamic>);

      return DataSuccess(group);
    }

    return DataFailed(encounteredExceptionOrError(result.exception!));
  }

  Future<DataState<GroupModel>> joinGroup(String shortCode) async {
    final _clientAuth = await graphqlConfig.authClient();
    final result = await _clientAuth.mutate(
        MutationOptions(document: gql(_groupQueries.joinGroup(shortCode))));

    if (result.data != null && result.isConcrete) {
      GroupModel group =
          GroupModel.fromJson(result.data as Map<String, dynamic>);

      return DataSuccess(group);
    }

    return DataFailed(encounteredExceptionOrError(result.exception!));
  }

  GraphQLError tryAgainMessage = GraphQLError(message: 'Please try again!');
  GraphQLError groupNotExist =
      GraphQLError(message: 'No group exists with that shortcode!');
  GraphQLError alreadymember =
      GraphQLError(message: 'Already a member of the group!');
  GraphQLError leaderOfGroup =
      GraphQLError(message: 'You are the leader of the group!');

  String encounteredExceptionOrError(OperationException exception) {
    if (exception.linkException != null) {
      debugPrint(exception.linkException.toString());
      return 'Server not running';
    } else {
      return exception.graphqlErrors[0].message.toString();
    }
  }
}
