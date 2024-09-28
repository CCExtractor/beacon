import 'package:beacon/core/queries/group.dart';
import 'package:beacon/core/resources/data_state.dart';
import 'package:beacon/data/models/group/group_model.dart';
import 'package:beacon/data/models/subscriptions/updated_group_model/updated_group_model.dart';
import 'package:beacon/data/models/user/user_model.dart';
import 'package:beacon/domain/entities/group/group_entity.dart';
import 'package:beacon/locator.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class RemoteHomeApi {
  late GraphQLClient _authClient;
  late GraphQLClient _subscriptionClient;
  RemoteHomeApi(this._authClient, this._subscriptionClient);

  final _groupQueries = GroupQueries();

  void loadClient(GraphQLClient authClient, GraphQLClient subscriptionClient) {
    this._authClient = authClient;
    this._subscriptionClient = subscriptionClient;
  }

  Future<DataState<List<GroupModel>>> fetchUserGroups(
      int page, int pageSize) async {
    final isConnected = await utils.checkInternetConnectivity();

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

    final result = await _authClient.query(QueryOptions(
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

  Future<DataState<GroupEntity>> fetchGroup(String id) async {
    final isConnected = await utils.checkInternetConnectivity();

    if (!isConnected)
      return DataFailed('Beacon is trying to connect with internet...');
    final result = await _authClient
        .mutate(MutationOptions(document: gql(_groupQueries.groupDetail(id))));

    if (result.data != null && result.isConcrete) {
      GroupModel group = GroupModel.fromJson(result.data!['group']);

      // storing group
      await localApi.saveGroup(group);

      return DataSuccess(group);
    }

    return DataFailed(encounteredExceptionOrError(result.exception!));
  }

  Future<DataState<GroupModel>> createGroup(String title) async {
    final isConnected = await utils.checkInternetConnectivity();

    if (!isConnected)
      return DataFailed('Beacon is trying to connect with internet...');
    final result = await _authClient.mutate(
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

    final result = await _authClient.mutate(
        MutationOptions(document: gql(_groupQueries.joinGroup(shortCode))));

    if (result.data != null && result.isConcrete) {
      GroupModel group = GroupModel.fromJson(
          result.data!['joinGroup'] as Map<String, dynamic>);

      // storing group
      await localApi.saveGroup(group);

      return DataSuccess(group);
    }

    return DataFailed(encounteredExceptionOrError(result.exception!));
  }

  SubscriptionOptions<Object?>? groupsSubscription;

  Stream<DataState<UpdatedGroupModel>> groupUpdateSubscription(
      List<String> groupIds) async* {
    // Check for internet connectivity
    final isConnected = await utils.checkInternetConnectivity();

    if (!isConnected) {
      yield DataFailed('Beacon is trying to connect with internet...');
      return;
    }

    // Initialize GraphQL client
    final subscriptionOptions = SubscriptionOptions(
      document: _groupQueries.groupUpdateSubGql,
      variables: {'groupIds': groupIds},
    );
    final resultStream =
        await _subscriptionClient.subscribe(subscriptionOptions);

    // Listen to the subscription stream
    await for (var result in resultStream) {
      if (result.hasException) {
        yield DataFailed(result.exception.toString());
        continue;
      }

      if (result.data == null ||
          !result.isConcrete ||
          result.data!['groupUpdate'] == null) {
        continue;
      }

      final groupUpdateJson =
          result.data!['groupUpdate'] as Map<String, dynamic>;

      UpdatedGroupModel updatedGroup =
          UpdatedGroupModel.fromJson(groupUpdateJson);

      yield DataSuccess(updatedGroup);
    }
  }

  Future<DataState<GroupModel>> changeShortCode(String groupId) async {
    final isConnected = await utils.checkInternetConnectivity();

    if (!isConnected)
      return DataFailed('Beacon is trying to connect with internet...');

    final result = await _authClient.mutate(
        MutationOptions(document: gql(_groupQueries.changeShortCode(groupId))));

    if (result.data != null &&
        result.isConcrete &&
        result.data!['changeShortcode'] != null) {
      return DataSuccess(GroupModel.fromJson(result.data!['changeShortcode']));
    } else {
      return DataFailed(encounteredExceptionOrError(result.exception!));
    }
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
