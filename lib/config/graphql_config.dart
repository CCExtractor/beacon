// import 'dart:async';
// import 'package:beacon/config/enviornment_config.dart';
// import 'package:beacon/locator.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:beacon/config/enviornment_config.dart';
import 'package:beacon/locator.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfig {
  static String? token;
  WebSocketLink? _webSocketLink;
  static final HttpLink httpLink = HttpLink(
    EnvironmentConfig.httpEndpoint ??
        'https://beacon-backend-25.onrender.com/graphql',
  );

  Future<AuthLink> _loadAuthLink() async {
    // no need to load token, it will get load when _loadWebSocketLink
    return AuthLink(getToken: () async => token);
  }

  Future<WebSocketLink> _loadWebSocketLink() async {
    await _getToken();
    _webSocketLink = WebSocketLink(
        EnvironmentConfig.websocketEndpoint ??
            'ws://beacon-backend-25.onrender.com/graphql',
        config: SocketClientConfig(
          autoReconnect: true,
          initialPayload: {"Authorization": token},
        ));

    return _webSocketLink!;
  }

  _getToken() async {
    await localApi.init();
    await localApi.userloggedIn();
    token = localApi.userModel.authToken;
    return true;
  }

//   // for non auth clients
  GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );
  }

//   // for auth clients
  Future<GraphQLClient> authClient() async {
    await _getToken();
    final AuthLink authLink = AuthLink(getToken: () async => '$token');
    final Link finalAuthLink = authLink.concat(httpLink);
    print("link: $finalAuthLink");
    return GraphQLClient(
      cache: GraphQLCache(partialDataPolicy: PartialDataCachePolicy.accept),
      link: finalAuthLink,
    );
  }

  // for subscription
  Future<GraphQLClient> graphQlClient() async {
    final websocketLink = await _loadWebSocketLink();
    final authLink = await _loadAuthLink();

    return GraphQLClient(
      cache: GraphQLCache(
        partialDataPolicy: PartialDataCachePolicy.acceptForOptimisticData,
      ),
      link: Link.split(
        (request) => request.isSubscription,
        websocketLink,
        authLink.concat(httpLink),
      ),
    );
  }
}
