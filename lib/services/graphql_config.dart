import 'package:beacon/locator.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_config/flutter_config.dart';

class GraphQLConfig {
  static String token;
  static final HttpLink httpLink = HttpLink(
    "${FlutterConfig.get('HTTP_ENDPOINT')}",
  );

  static final AuthLink authLink = AuthLink(getToken: () async => token);

  static WebSocketLink websocketLink =
      WebSocketLink('${FlutterConfig.get('WEBSOCKET_ENDPOINT')}',
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
      cache: GraphQLCache(),
      link: Link.split(
        (request) => request.isSubscription,
        websocketLink,
        authLink.concat(httpLink),
      ),
    );
  }
}
