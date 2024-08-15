import 'package:beacon/core/services/location_services.dart';
import 'package:beacon/core/services/shared_prefrence_service.dart';
import 'package:beacon/core/utils/utils.dart';
import 'package:beacon/data/datasource/local/local_api.dart';
import 'package:beacon/data/datasource/remote/remote_auth_api.dart';
import 'package:beacon/data/datasource/remote/remote_group_api.dart';
import 'package:beacon/data/datasource/remote/remote_hike_api.dart';
import 'package:beacon/data/datasource/remote/remote_home_api.dart';
import 'package:beacon/data/repositories/auth_repository_implementation.dart';
import 'package:beacon/data/repositories/group_repository_implementation.dart';
import 'package:beacon/data/repositories/hike_repository_implementation.dart';
import 'package:beacon/data/repositories/home_repository_implementation.dart';
import 'package:beacon/domain/repositories/auth_repository.dart';
import 'package:beacon/domain/repositories/group_repository.dart';
import 'package:beacon/domain/repositories/hike_repository.dart';
import 'package:beacon/domain/repositories/home_repository.dart';
import 'package:beacon/domain/usecase/auth_usecase.dart';
import 'package:beacon/domain/usecase/group_usecase.dart';
import 'package:beacon/domain/usecase/hike_usecase.dart';
import 'package:beacon/domain/usecase/home_usecase.dart';
import 'package:beacon/presentation/auth/auth_cubit/auth_cubit.dart';
import 'package:beacon/presentation/auth/verification_cubit/verification_cubit.dart';
import 'package:beacon/presentation/group/cubit/group_cubit/group_cubit.dart';
import 'package:beacon/presentation/hike/cubit/hike_cubit/hike_cubit.dart';
import 'package:beacon/presentation/hike/cubit/location_cubit/location_cubit.dart';
import 'package:beacon/presentation/hike/cubit/panel_cubit/panel_cubit.dart';
import 'package:beacon/presentation/home/home_cubit/home_cubit.dart';
import 'package:beacon/presentation/group/cubit/members_cubit/members_cubit.dart';
import 'package:beacon/config/graphql_config.dart';
import 'package:beacon/config/local_notification.dart';
import 'package:beacon/config/router/router.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;
final GraphQLConfig graphqlConfig = locator<GraphQLConfig>();
final LocalNotification localNotif = locator<LocalNotification>();
final localApi = locator<LocalApi>();
final utils = locator<Utils>();
final locationService = locator<LocationService>();
final appRouter = locator<AppRouter>();
final sp = locator<SharedPreferenceService>();
Future<void> setupLocator() async {
  // shared prefrence services
  locator.registerSingleton(SharedPreferenceService());

  locator.registerLazySingleton(() => LocationService());
  locator.registerSingleton<AppRouter>(AppRouter());

  locator.registerSingleton<GraphQLConfig>(GraphQLConfig());

  //local Notification
  locator.registerSingleton(LocalNotification());

  // hive localDb
  locator.registerSingleton<LocalApi>(LocalApi());

  final clientAuth = await graphqlConfig.authClient();
  final subscriptionClient = await graphqlConfig.graphQlClient();

  // Remote Api
  locator.registerSingleton<RemoteAuthApi>(
      RemoteAuthApi(clientAuth, graphqlConfig.clientToQuery()));

  locator.registerSingleton<RemoteHomeApi>(
      RemoteHomeApi(clientAuth, subscriptionClient));
  locator.registerSingleton<RemoteGroupApi>(RemoteGroupApi(clientAuth));
  locator.registerSingleton<RemoteHikeApi>(
      RemoteHikeApi(clientAuth, subscriptionClient));

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

  // registering utils
  locator.registerSingleton<Utils>(Utils());

  // registering cubit class
  locator.registerSingleton(AuthCubit(locator()));
  locator.registerSingleton(VerificationCubit(locator()));
  locator.registerSingleton(HomeCubit(locator()));
  locator.registerSingleton(GroupCubit(locator()));
  locator.registerSingleton(MembersCubit(locator()));
  locator.registerSingleton(HikeCubit(locator()));
  locator.registerSingleton(LocationCubit(locator()));
  locator.registerSingleton(PanelCubit(locator()));
}
