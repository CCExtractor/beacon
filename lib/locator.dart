import 'package:beacon/main.dart';
import 'package:beacon/services/connection_checker.dart';
import 'package:beacon/services/database_mutation_functions.dart';
import 'package:beacon/services/graphql_config.dart';
import 'package:beacon/services/hive_localdb.dart';
import 'package:beacon/services/local_notification.dart';
import 'package:beacon/services/navigation_service.dart';
import 'package:beacon/services/user_config.dart';
import 'package:beacon/view_model/auth_screen_model.dart';
import 'package:beacon/view_model/home_screen_view_model.dart';
import 'package:beacon/view_model/hike_screen_model.dart';
import 'package:beacon/view_model/group_screen_view_model.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;
final UserConfig? userConfig = locator<UserConfig>();
final NavigationService? navigationService = locator<NavigationService>();
final DataBaseMutationFunctions? databaseFunctions =
    locator<DataBaseMutationFunctions>();
final GraphQLConfig? graphqlConfig = locator<GraphQLConfig>();
final LocalNotification? localNotif = locator<LocalNotification>();
final HiveLocalDb? hiveDb = locator<HiveLocalDb>();
final ConnectionChecker? connectionChecker = locator<ConnectionChecker>();

void setupLocator() {
  //services
  locator.registerSingleton(NavigationService());

  //userConfig
  locator.registerSingleton(UserConfig());
  locator.registerSingleton(GraphQLConfig());

  //databaseMutationFunction
  locator.registerSingleton(DataBaseMutationFunctions());

  //Hive localdb
  locator.registerSingleton(HiveLocalDb());

  //Connection checker.
  locator.registerSingleton(ConnectionChecker());

  locator.registerFactory(() => DemoViewModel());
  locator.registerFactory(() => AuthViewModel());
  locator.registerFactory(() => HomeViewModel());
  locator.registerFactory(() => HikeScreenViewModel());
  locator.registerFactory(() => GroupViewModel());

  //local Notification
  locator.registerSingleton(LocalNotification());
}
