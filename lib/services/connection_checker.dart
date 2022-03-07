import 'package:data_connection_checker/data_connection_checker.dart';

class ConnectionChecker {
  Future<bool> checkForInternetConnection() async {
    return await DataConnectionChecker().hasConnection;
  }
}
