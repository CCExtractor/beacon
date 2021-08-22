import 'package:beacon/locator.dart';
import 'package:beacon/models/user/user_info.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class GraphQLConfig {
  static String token;
  static final HttpLink httpLink = HttpLink(
    "https://beacon.aadibajpai.com/graphql",
  );

  static final AuthLink authLink = AuthLink(getToken: () async => token);

  static WebSocketLink websocketLink =
      WebSocketLink('wss://beacon.aadibajpai.com/subscriptions',
          config: SocketClientConfig(
            autoReconnect: true,
            initialPayload: {
              "Authorization": '${userConfig.currentUser.authToken}'
            },
          ));

  Future getToken() async {
    final _token = userConfig.currentUser.authToken;
    token = _token;
    return true;
  }

  GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: GraphQLCache(partialDataPolicy: PartialDataCachePolicy.accept),
      link: httpLink,
    );
  }

  GraphQLClient graphQlClient() {
    return GraphQLClient(
      cache: GraphQLCache(),
      link: Link.split(
        (request) => request.isSubscription,
        websocketLink,
        authLink.concat(httpLink),
      ),
    );
  }
}
