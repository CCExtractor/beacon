import 'package:beacon/Bloc/config/enviornment_config.dart';
import 'package:beacon/locator.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfig {
  static String? token;
  static final HttpLink httpLink = HttpLink(
    EnvironmentConfig.httpEndpoint!,
  );

  static final AuthLink authLink = AuthLink(getToken: () async => token);

  static WebSocketLink websocketLink =
      WebSocketLink(EnvironmentConfig.websocketEndpoint!,
          config: SocketClientConfig(
            autoReconnect: true,
            initialPayload: {
              "Authorization": '${userConfig!.currentUser!.authToken}'
            },
          ));

  Future getToken() async {
    await localApi.init();
    final user = await localApi.fetchUser();
    if (user != null) {
      token = user.authToken;
    }
    return true;
  }

  GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: GraphQLCache(partialDataPolicy: PartialDataCachePolicy.accept),
      link: httpLink,
    );
  }

  Future<GraphQLClient> authClient() async {
    await getToken();
    final AuthLink authLink = AuthLink(getToken: () async => '$token');
    final Link finalAuthLink = authLink.concat(httpLink);
    return GraphQLClient(
      cache: GraphQLCache(partialDataPolicy: PartialDataCachePolicy.accept),
      link: finalAuthLink,
    );
  }

  GraphQLClient graphQlClient() {
    return GraphQLClient(
      cache: GraphQLCache(partialDataPolicy: PartialDataCachePolicy.accept),
      link: Link.split(
        (request) => request.isSubscription,
        websocketLink,
        authLink.concat(httpLink),
      ),
    );
  }
}
