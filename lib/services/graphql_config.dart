import 'package:beacon/locator.dart';
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

  static final WebSocketLink websocketLink =
      WebSocketLink('ws://beacon.aadibajpai.com/subscriptions/',
          config: SocketClientConfig(
            autoReconnect: true,
          ));

  Future getToken() async {
    final _token = userConfig.currentUser.authToken;
    token = _token;
    return true;
  }

  static final Link link = authLink.concat(httpLink).concat(websocketLink);
  GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: GraphQLCache(partialDataPolicy: PartialDataCachePolicy.accept),
      link: httpLink.concat(websocketLink),
    );
  }

  GraphQLClient authClient() {
    final AuthLink authLink =
        AuthLink(getToken: () async => userConfig.currentUser.authToken);
    final Link finalAuthLink = authLink.concat(httpLink);
    return GraphQLClient(
      cache: GraphQLCache(),
      link: finalAuthLink,
    );
  }

  GraphQLClient webSocketClient() {
    return GraphQLClient(
      cache: GraphQLCache(),
      link:
          Link.split((request) => request.isSubscription, websocketLink, link),
    );
  }

  ValueNotifier<GraphQLClient> client = ValueNotifier(GraphQLClient(
    link: link,
    cache: GraphQLCache(),
  ));
}
