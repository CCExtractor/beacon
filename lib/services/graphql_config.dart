import 'package:beacon/locator.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class GraphQLConfig {
  static String token;
  static final HttpLink httpLink = HttpLink(
    "http://192.168.1.8:4000/graphql",
  );

  static final AuthLink authLink =
      AuthLink(getToken: () async => 'Bearer $token');

  static final WebSocketLink websocketLink =
      WebSocketLink('ws://192.168.1.8:4000/subscriptions/',
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
    final AuthLink authLink = AuthLink(getToken: () async => 'Bearer $token');
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
