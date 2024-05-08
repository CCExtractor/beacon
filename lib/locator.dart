import 'package:beacon/main.dart';
import 'package:beacon/old/components/services/connection_checker.dart';
import 'package:beacon/old/components/services/database_mutation_functions.dart';
import 'package:beacon/Bloc/config/graphql_config.dart';
import 'package:beacon/old/components/services/hive_localdb.dart';
import 'package:beacon/old/components/services/local_notification.dart';
import 'package:beacon/old/components/services/navigation_service.dart';
import 'package:beacon/old/components/services/shared_preference_service.dart';
import 'package:beacon/old/components/services/user_config.dart';
import 'package:beacon/old/components/view_model/auth_screen_model.dart';
import 'package:beacon/old/components/view_model/home_screen_view_model.dart';
import 'package:beacon/old/components/view_model/hike_screen_model.dart';
import 'package:beacon/old/components/view_model/group_screen_view_model.dart';
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
final sharedPrefrenceService = locator<SharedPreferenceService>();

void setupLocator() {
  // shared prefrence services
  locator.registerSingleton(SharedPreferenceService());

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
