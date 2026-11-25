import 'package:get_it/get_it.dart';
import '../../core/authentication/cache/disk/hive.dart';
import '../../core/authentication/delegates/rxdart/authentication.dart';
import '../../core/network/client/dio/dio.dart';
import '../network/response_handler/app/response_handler.dart';
import '../../feature/auth/data/data_sources/data_source.dart';
import '../../feature/auth/data/repositories/authentication.dart';
import '../../feature/country/data/datasource/datasource.dart';
import '../../feature/country/data/repository/repository.dart';
import '../../feature/notifications/data/datasource/remote_datasource.dart';
import '../../feature/notifications/data/repository/repository.dart';
import '../../feature/setting/data/datasource/datasource.dart';
import '../../feature/setting/data/repository/repository.dart';
import '../../feature/cart/data/datasource/remote_datasource.dart';
import '../../feature/cart/data/repository/remote_repository.dart';
import '../../feature/user/data/data_sources/data_source.dart';
import '../../feature/user/data/repositories/user.dart';
import '../../shared/cubits/config/config_cubit.dart';
import '../../shared/cubits/language/language_cubit.dart';
import '../../shared/cubits/theme/theme_cubit.dart';
import '../../shared/data/config_data/data_source/config_data_source.dart';
import '../../shared/data/config_data/repo/config_repo.dart';
import '../../shared/show_case/management/showcase_manager.dart';
import '../helper/network_connection.dart';
import '../service/force_update/force_update_service.dart';

final class DependencyInjector {
  const DependencyInjector();

  static final GetIt _sl = GetIt.instance;

  static void reset() => _sl.reset();

  static void setup() {
    // region Config
    _sl
      ..registerLazySingleton<NetworkService>(() => NetworkService())
      ..registerLazySingleton<ForceUpdateService>(
        () => ForceUpdateService.instance,
      )
      ..registerLazySingleton<DioNetworkClient>(DioNetworkClient.new)
      ..registerLazySingleton<HiveAuthenticationCache>(() {
        return HiveAuthenticationCache();
      })
      ..registerLazySingleton<ShowcaseManager>(() {
        return ShowcaseManager();
      })
      ..registerLazySingleton<AppResponseHandler>(() {
        return const AppResponseHandler();
      })
      /// region Repository
      ..registerLazySingleton<AuthenticationRepository>(() {
        return AuthenticationRepository(
          dataSource: DependencyInjector._authenticationRemoteDataSource,
        );
      })
      ..registerLazySingleton<UserRepository>(() {
        return UserRepository(
          dataSource: DependencyInjector._userRemoteDataSource,
        );
      })
      ..registerLazySingleton<ConfigRepo>(() {
        return ConfigRepo(
          configDataSource: DependencyInjector._configDataSource,
        );
      })
      ..registerLazySingleton<CountryRepository>(() {
        return CountryRepository(
          dataSource: DependencyInjector._countryDataSource,
        );
      })
      // ..registerLazySingleton<PackageRepository>(() {
      //   return PackageRepository(
      //     dataSource: DependencyInjector._packageDataSource,
      //   );
      // })
      // ..registerLazySingleton<MyCoursesRepository>(() {
      //   return MyCoursesRepository(
      //     dataSource: DependencyInjector._myCoursesDataSource,
      //   );
      // })
      // ..registerLazySingleton<ParentProfileRepository>(() {
      //   return ParentProfileRepository(
      //     dataSource: DependencyInjector._parentProfileDataSource,
      //   );
      // })
      ..registerLazySingleton<NotificationRepository>(() {
        return NotificationRepository(
          datasource: DependencyInjector._notificationDataSource,
        );
      })
      ..registerLazySingleton<CartRepository>(() {
        return CartRepository(dataSource: DependencyInjector._cartDataSource);
      })
      // ..registerLazySingleton<OrderRepository>(() {
      //   return OrderRepository(
      //     dataSource: DependencyInjector._orderDataSource,
      //   );
      // })
      // ..registerLazySingleton<MyAssessmentRepository>(() {
      //   return MyAssessmentRepository(
      //     datasource: DependencyInjector._myAssessmentDataSource,
      //   );
      // })
      // ..registerLazySingleton<ScheduleRepository>(() {
      //   return ScheduleRepository(
      //     dataSource: DependencyInjector._scheduleDataSource,
      //   );
      // })
      // ..registerLazySingleton<DashboardRemoteRepo>(() {
      //   return DashboardRemoteRepo(
      //     datasource: DependencyInjector._dashboardDataSource,
      //   );
      // })
      // ..registerLazySingleton<HomeParentRemoteRepo>(() {
      //   return HomeParentRemoteRepo(
      //     dataSource: DependencyInjector._homeParentDatasource,
      //   );
      // })
      ..registerLazySingleton<SettingRepository>(() {
        return SettingRepository(
          dataSource: DependencyInjector._settingDataSource,
        );
      })
      // region DataSources
      ..registerLazySingleton<UserRemoteDataSource>(() {
        return UserRemoteDataSource(
          client: DependencyInjector._dioNetworkClient,
          responseHandler: DependencyInjector._appResponseHandler,
        );
      })
      ..registerLazySingleton<AuthenticationDelegateWithRxdart>(() {
        return AuthenticationDelegateWithRxdart(
          authRepository: DependencyInjector.authenticationRepository,
          userRepository: DependencyInjector.userRepository,
          cache: DependencyInjector.hiveAuthenticationCache,
        );
      })
      ..registerLazySingleton<AuthenticationRemoteDataSource>(() {
        return AuthenticationRemoteDataSource(
          client: DependencyInjector._dioNetworkClient,
          responseHandler: DependencyInjector._appResponseHandler,
        );
      })
      ..registerLazySingleton<ConfigDataSource>(() {
        return ConfigDataSource(
          responseHandler: DependencyInjector._appResponseHandler,
          client: DependencyInjector._dioNetworkClient,
        );
      })
      ..registerLazySingleton<CountryDataSource>(() {
        return CountryDataSource(
          handler: DependencyInjector._appResponseHandler,
          client: DependencyInjector._dioNetworkClient,
        );
      })
      // ..registerLazySingleton<PackageDataSource>(() {
      //   return PackageDataSource(
      //     handler: DependencyInjector._konozResponseHandler,
      //     client: DependencyInjector._dioNetworkClient,
      //   );
      // })
      // ..registerLazySingleton<MyCoursesDataSource>(() {
      //   return MyCoursesDataSource(
      //     handler: DependencyInjector._konozResponseHandler,
      //     client: DependencyInjector._dioNetworkClient,
      //   );
      // })
      // ..registerLazySingleton<ParentProfileDataSource>(() {
      //   return ParentProfileDataSource(
      //     responseHandler: DependencyInjector._konozResponseHandler,
      //     client: DependencyInjector._dioNetworkClient,
      //   );
      // })
      ..registerLazySingleton<NotificationDatasource>(() {
        return NotificationDatasource(
          handler: DependencyInjector._appResponseHandler,
          client: DependencyInjector._dioNetworkClient,
        );
      })
      ..registerLazySingleton<CartDataSource>(() {
        return CartDataSource(
          responseHandler: DependencyInjector._appResponseHandler,
          client: DependencyInjector._dioNetworkClient,
        );
      })
      // ..registerLazySingleton<OrderDataSource>(() {
      //   return OrderDataSource(
      //     handler: DependencyInjector._konozResponseHandler,
      //     client: DependencyInjector._dioNetworkClient,
      //   );
      // })
      // ..registerLazySingleton<MyAssessmentDatasource>(() {
      //   return MyAssessmentDatasource(
      //     handler: DependencyInjector._konozResponseHandler,
      //     client: DependencyInjector._dioNetworkClient,
      //   );
      // })
      // ..registerLazySingleton<ScheduleDataSource>(() {
      //   return ScheduleDataSource(
      //     handler: DependencyInjector._konozResponseHandler,
      //     client: DependencyInjector._dioNetworkClient,
      //   );
      // })
      // ..registerLazySingleton<DashboardRemoteDatasource>(() {
      //   return DashboardRemoteDatasource(
      //     handler: DependencyInjector._appResponseHandler,
      //     client: DependencyInjector._dioNetworkClient,
      //   );
      // })
      // ..registerLazySingleton<HomeParentDataSource>(() {
      //   return HomeParentDataSource(
      //     handler: DependencyInjector._konozResponseHandler,
      //     client: DependencyInjector._dioNetworkClient,
      //   );
      // })
      ..registerLazySingleton<SettingDataSource>(() {
        return SettingDataSource(
          handler: DependencyInjector._appResponseHandler,
          client: DependencyInjector._dioNetworkClient,
        );
      })
      // region Cubits
      ..registerLazySingleton<ConfigCubit>(
        () => ConfigCubit(DependencyInjector.configRepo),
      )
      ..registerLazySingleton<LanguageCubit>(
        () => LanguageCubit(repository: DependencyInjector.userRepository),
      )
      ..registerLazySingleton<ThemeCubit>(
        () => ThemeCubit(repository: DependencyInjector.userRepository),
      );
    // ..registerLazySingleton<OrderCubit>(
    //   () => OrderCubit(
    //     repository: DependencyInjector.orderRepo,
    //   ),
    // )

    // region Live Classroom
  }

  // region Configs Name
  static DioNetworkClient get _dioNetworkClient {
    return _sl.get<DioNetworkClient>();
  }

  static NetworkService get networkService {
    return _sl.get<NetworkService>();
  }

  static HiveAuthenticationCache get hiveAuthenticationCache {
    return _sl<HiveAuthenticationCache>();
  }

  static ForceUpdateService get forceUpdateService {
    return _sl.get<ForceUpdateService>();
  }

  static ShowcaseManager get showcaseManager {
    return _sl<ShowcaseManager>();
  }

  static AppResponseHandler get _appResponseHandler {
    return _sl<AppResponseHandler>();
  }

  static AuthenticationDelegateWithRxdart get authenticationDelegateWithRxdart {
    return _sl<AuthenticationDelegateWithRxdart>();
  }

  // region Repository Names

  static AuthenticationRepository get authenticationRepository {
    return _sl<AuthenticationRepository>();
  }

  static UserRepository get userRepository {
    return _sl<UserRepository>();
  }

  static ConfigRepo get configRepo {
    return _sl<ConfigRepo>();
  }

  static CountryRepository get countryRepo {
    return _sl<CountryRepository>();
  }

  // static PackageRepository get packageRepo {
  //   return _sl<PackageRepository>();
  // }

  // static MyCoursesRepository get myCoursesRepo {
  //   return _sl<MyCoursesRepository>();
  // }

  // static ParentProfileRepository get parentProfileRepo {
  //   return _sl<ParentProfileRepository>();
  // }

  static NotificationRepository get notificationRepo {
    return _sl<NotificationRepository>();
  }

  static CartRepository get cartRepo {
    return _sl<CartRepository>();
  }

  // static OrderRepository get orderRepo {
  //   return _sl<OrderRepository>();
  // }

  // static MyAssessmentRepository get myAssessmentRepository {
  //   return _sl<MyAssessmentRepository>();
  // }

  // static ScheduleRepository get scheduleRepository {
  //   return _sl<ScheduleRepository>();
  // }

  // static DashboardRemoteRepo get dashboardRepo {
  //   return _sl<DashboardRemoteRepo>();
  // }

  // static HomeParentRemoteRepo get homeParentRepo {
  //   return _sl<HomeParentRemoteRepo>();
  // }

  static SettingRepository get settingRepository {
    return _sl<SettingRepository>();
  }

  // region DataSources Names
  static AuthenticationRemoteDataSource get _authenticationRemoteDataSource {
    return _sl<AuthenticationRemoteDataSource>();
  }

  static UserRemoteDataSource get _userRemoteDataSource {
    return _sl<UserRemoteDataSource>();
  }

  static ConfigDataSource get _configDataSource {
    return _sl<ConfigDataSource>();
  }

  static CountryDataSource get _countryDataSource {
    return _sl<CountryDataSource>();
  }

  // static PackageDataSource get _packageDataSource {
  //   return _sl<PackageDataSource>();
  // }

  // static MyCoursesDataSource get _myCoursesDataSource {
  //   return _sl<MyCoursesDataSource>();
  // }

  // static ParentProfileDataSource get _parentProfileDataSource {
  //   return _sl<ParentProfileDataSource>();
  // }

  static NotificationDatasource get _notificationDataSource {
    return _sl<NotificationDatasource>();
  }

  static CartDataSource get _cartDataSource {
    return _sl<CartDataSource>();
  }

  // static OrderDataSource get _orderDataSource {
  //   return _sl<OrderDataSource>();
  // }

  // static MyAssessmentDatasource get _myAssessmentDataSource {
  //   return _sl<MyAssessmentDatasource>();
  // }

  // static ScheduleDataSource get _scheduleDataSource {
  //   return _sl<ScheduleDataSource>();
  // }

  // static DashboardRemoteDatasource get _dashboardDataSource {
  //   return _sl<DashboardRemoteDatasource>();
  // }

  // static HomeParentDataSource get _homeParentDatasource {
  //   return _sl<HomeParentDataSource>();
  // }

  static SettingDataSource get _settingDataSource {
    return _sl<SettingDataSource>();
  }

  // region Cubits Names
  static ConfigCubit get configCubit {
    return _sl<ConfigCubit>();
  }

  static LanguageCubit get languageCubit {
    return _sl<LanguageCubit>();
  }

  // static OrderCubit get orderCubit {
  //   return _sl<OrderCubit>();
  // }

  static ThemeCubit get themeCubit {
    return _sl<ThemeCubit>();
  }
}
