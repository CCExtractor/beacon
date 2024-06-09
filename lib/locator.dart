import 'package:beacon/Bloc/core/services/shared_prefrence_service.dart';
import 'package:beacon/Bloc/core/utils/utils.dart';
import 'package:beacon/Bloc/data/datasource/local/local_api.dart';
import 'package:beacon/Bloc/data/datasource/remote/remote_auth_api.dart';
import 'package:beacon/Bloc/data/datasource/remote/remote_group_api.dart';
import 'package:beacon/Bloc/data/datasource/remote/remote_hike_api.dart';
import 'package:beacon/Bloc/data/datasource/remote/remote_home_api.dart';
import 'package:beacon/Bloc/data/repositories/auth_repository_implementation.dart';
import 'package:beacon/Bloc/data/repositories/group_repository_implementation.dart';
import 'package:beacon/Bloc/data/repositories/hike_repository_implementation.dart';
import 'package:beacon/Bloc/data/repositories/home_repository_implementation.dart';
import 'package:beacon/Bloc/domain/repositories/auth_repository.dart';
import 'package:beacon/Bloc/domain/repositories/group_repository.dart';
import 'package:beacon/Bloc/domain/repositories/hike_repository.dart';
import 'package:beacon/Bloc/domain/repositories/home_repository.dart';
import 'package:beacon/Bloc/domain/usecase/auth_usecase.dart';
import 'package:beacon/Bloc/domain/usecase/group_usecase.dart';
import 'package:beacon/Bloc/domain/usecase/hike_usecase.dart';
import 'package:beacon/Bloc/domain/usecase/home_usecase.dart';
import 'package:beacon/main.dart';
import 'package:beacon/old/components/services/connection_checker.dart';
import 'package:beacon/old/components/services/database_mutation_functions.dart';
import 'package:beacon/Bloc/config/graphql_config.dart';
import 'package:beacon/old/components/services/hive_localdb.dart';
import 'package:beacon/old/components/services/local_notification.dart';
import 'package:beacon/old/components/services/navigation_service.dart';
import 'package:beacon/old/components/services/user_config.dart';
import 'package:beacon/old/components/view_model/auth_screen_model.dart';
import 'package:beacon/old/components/view_model/home_screen_view_model.dart';
import 'package:beacon/old/components/view_model/hike_screen_model.dart';
import 'package:beacon/old/components/view_model/group_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;
final UserConfig? userConfig = locator<UserConfig>();
final NavigationService? navigationService = locator<NavigationService>();
final DataBaseMutationFunctions? databaseFunctions =
    locator<DataBaseMutationFunctions>();
final GraphQLConfig graphqlConfig = locator<GraphQLConfig>();
final LocalNotification? localNotif = locator<LocalNotification>();
final HiveLocalDb? hiveDb = locator<HiveLocalDb>();
final ConnectionChecker? connectionChecker = locator<ConnectionChecker>();
final sharedPrefrenceService = locator<SharedPreferenceService>();
final localApi = locator<LocalApi>();
final remoteAuthApi = locator<RemoteAuthApi>();
final remoteHomeApi = locator<RemoteHomeApi>();
final utils = locator<Utils>();

void setupLocator() async {
  // shared prefrence services
  locator.registerSingleton(SharedPreferenceService());

  //services
  locator.registerSingleton(NavigationService());

  //userConfig
  locator.registerSingleton(UserConfig());

  locator.registerSingleton<GraphQLConfig>(GraphQLConfig());

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

  // hive localDb
  locator.registerSingleton<LocalApi>(LocalApi());

  final authClient = await graphqlConfig.authClient();

  // Remote Api
  locator.registerSingleton<RemoteAuthApi>(
    RemoteAuthApi(
      clientAuth: authClient,
      clientNonAuth: ValueNotifier(graphqlConfig.clientToQuery()),
    ),
  );

  locator.registerSingleton<RemoteHomeApi>(
    RemoteHomeApi(authClient),
  );

  locator.registerSingleton<RemoteGroupApi>(
      RemoteGroupApi(authClient: authClient));

  locator.registerSingleton<RemoteHikeApi>(RemoteHikeApi(authClient));

  // registering auth reporitory of domain
  locator.registerSingleton<AuthRepository>(
      AuthRepositoryImplementation(remoteAuthApi: locator<RemoteAuthApi>()));
  locator.registerSingleton<HomeRepository>(
      HomeRepostitoryImplementation(remoteHomeApi: locator<RemoteHomeApi>()));
  locator.registerSingleton<GroupRepository>(
      GroupRepostioryImplementation(remoteGroupApi: locator<RemoteGroupApi>()));
  locator.registerSingleton<HikeRepository>(
      HikeRepositoryImplementatioin(remoteHikeApi: locator<RemoteHikeApi>()));

  // use case
  locator.registerSingleton(
      AuthUseCase(authRepository: locator<AuthRepository>()));
  locator.registerSingleton<HomeUseCase>(
      HomeUseCase(homeRepository: locator<HomeRepository>()));
  locator.registerSingleton<GroupUseCase>(
      GroupUseCase(locator<GroupRepository>()));
  locator.registerSingleton<HikeUseCase>(
      HikeUseCase(hikeRepository: locator<HikeRepository>()));

  // // cubit
  // locator.registerFactory<HomeCubit>(() => HomeCubit(homeUseCase: locator()));

  // registering utils
  locator.registerSingleton<Utils>(Utils());
}
