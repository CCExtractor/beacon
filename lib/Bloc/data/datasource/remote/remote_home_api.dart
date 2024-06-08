import 'package:beacon/Bloc/core/queries/group.dart';
import 'package:beacon/Bloc/core/resources/data_state.dart';
import 'package:beacon/Bloc/data/models/group/group_model.dart';
import 'package:beacon/Bloc/data/models/user/user_model.dart';
import 'package:beacon/locator.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class RemoteHomeApi {
  final GraphQLClient _clientAuth;
  RemoteHomeApi(this._clientAuth);

  final _groupQueries = GroupQueries();

  Future<DataState<List<GroupModel>>> fetchUserGroups(
      int page, int pageSize) async {
    final isConnected = await utils.checkInternetConnectivity();

    print(_clientAuth.toString());

    if (!isConnected) {
      // fetching the previous data stored
      // here taking all the ids of group from the user model and then fetching the groups locally from the ids
      // returning all groups in one go
      UserModel? usermodel = await localApi.fetchUser();

      if (usermodel != null && usermodel.groups != null) {
        // taking user groups

        int condition = (page - 1) * pageSize + pageSize;
        int groupLen = usermodel.groups!.length;

        if (condition > groupLen) {
          condition = groupLen;
        }

        List<GroupModel> groups = [];

        for (int i = (page - 1) * pageSize; i < condition; i++) {
          GroupModel? groupModel =
              await localApi.getGroup(usermodel.groups![i]!.id);
          groupModel != null ? groups.add(groupModel) : null;
        }

        return DataSuccess(groups);
      }
    }

    final clientAuth = await graphqlConfig.authClient();

    final result = await clientAuth.query(QueryOptions(
        document: gql(_groupQueries.fetchUserGroups(page, pageSize))));

    if (result.data != null && result.isConcrete) {
      List<GroupModel> groups = [];
      List<dynamic> groupsData = result.data!['groups'];
      for (var groupData in groupsData) {
        final group = GroupModel.fromJson(groupData);

        // saving locally
        await localApi.saveGroup(group);

        groups.add(group);
      }
      return DataSuccess(groups);
    }

    return DataFailed(encounteredExceptionOrError(result.exception!));
  }

  Future<DataState<GroupModel>> createGroup(String title) async {
    final isConnected = await utils.checkInternetConnectivity();

    if (!isConnected)
      return DataFailed('Beacon is trying to connect with internet...');
    final _clientAuth = await graphqlConfig.authClient();
    final result = await _clientAuth.mutate(
        MutationOptions(document: gql(_groupQueries.createGroup(title))));

    if (result.data != null && result.isConcrete) {
      GroupModel group = GroupModel.fromJson(
          result.data!['createGroup'] as Map<String, dynamic>);

      // storing group
      await localApi.saveGroup(group);

      return DataSuccess(group);
    }

    return DataFailed(encounteredExceptionOrError(result.exception!));
  }

  Future<DataState<GroupModel>> joinGroup(String shortCode) async {
    final isConnected = await utils.checkInternetConnectivity();

    if (!isConnected)
      return DataFailed('Beacon is trying to connect with internet...');
    final _clientAuth = await graphqlConfig.authClient();
    final result = await _clientAuth.mutate(
        MutationOptions(document: gql(_groupQueries.joinGroup(shortCode))));

    if (result.data != null && result.isConcrete) {
      GroupModel group =
          GroupModel.fromJson(result.data as Map<String, dynamic>);

      // storing group
      await localApi.saveGroup(group);

      return DataSuccess(group);
    }

    return DataFailed(encounteredExceptionOrError(result.exception!));
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
