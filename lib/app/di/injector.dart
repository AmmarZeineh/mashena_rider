import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:mashena_rider/core/auth/auth_event_bus.dart';
import 'package:mashena_rider/features/home/data/repositories/rating_repository_impl.dart';
import 'package:mashena_rider/features/home/domain/repositories/rating_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mashena_rider/app/config/app_config.dart';

// ======================
// Core - Network
// ======================
import 'package:mashena_rider/core/network/api_client.dart';
import 'package:mashena_rider/core/network/dio_client.dart';
import 'package:mashena_rider/core/network/auth_interceptor.dart';
import 'package:mashena_rider/core/network/api_logging_interceptor.dart';
import 'package:mashena_rider/core/network/network_info.dart';
import 'package:mashena_rider/core/network/socket_client.dart';
import 'package:mashena_rider/core/network/socket_io_client_impl.dart';

// ======================
// Core - Auth
// ======================
import 'package:mashena_rider/core/network/token_manager.dart';
import 'package:mashena_rider/core/network/token_manager_impl.dart';

// ======================
// Core - Storage & Services
// ======================
import 'package:mashena_rider/core/storage/local_storage.dart';
import 'package:mashena_rider/core/storage/local_storage_impl.dart';
import 'package:mashena_rider/core/services/location_service.dart';
import 'package:mashena_rider/core/services/nominatim_service.dart';
import 'package:mashena_rider/core/services/osrm_route_service.dart';

// ======================
// Features - Onboarding
// ======================
import 'package:mashena_rider/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:mashena_rider/features/onboarding/domain/usecases/get_onboarding_status_usecase.dart';

// ======================
// Features - Auth (Data)
// ======================
import 'package:mashena_rider/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:mashena_rider/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mashena_rider/features/auth/data/repositories/auth_repository_impl.dart';

// ======================
// Features - Auth (Domain)
// ======================
import 'package:mashena_rider/features/auth/domain/repositories/auth_repository.dart';
import 'package:mashena_rider/features/auth/domain/usecases/signup_usecase.dart';
import 'package:mashena_rider/features/auth/domain/usecases/login_usecase.dart';
import 'package:mashena_rider/features/auth/domain/usecases/logout_usecase.dart';
import 'package:mashena_rider/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:mashena_rider/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:mashena_rider/features/auth/domain/usecases/get_cached_session_usecase.dart';

// ======================
// Features - Auth (Presentation)
// ======================
import 'package:mashena_rider/features/auth/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:mashena_rider/app/router/auth_session_cache.dart';
import 'package:mashena_rider/features/home/domain/repositories/ride_repository.dart';
import 'package:mashena_rider/features/home/domain/usecases/create_ride_request_usecase.dart';
import 'package:mashena_rider/features/home/domain/usecases/submit_ride_request_usecase.dart';
import 'package:mashena_rider/features/home/domain/usecases/cancel_ride_usecase.dart';
import 'package:mashena_rider/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:mashena_rider/features/profile/domain/repositories/profile_repository.dart';
import 'package:mashena_rider/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:mashena_rider/features/home/data/datasources/ride_socket_data_source.dart';
import 'package:mashena_rider/features/home/data/repositories/ride_repository_impl.dart';
import 'package:mashena_rider/features/home/presentation/address/cubits/pick_address_cubit/pick_address_cubit.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/trip_rating_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // =====================================================
  // 🔹 1. External Dependencies (Platform / SDK Level)
  // =====================================================

  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // =====================================================
  // 🔹 2. App Configuration (Environment Driven Config)
  // =====================================================

  getIt.registerSingleton<AppConfig>(
    kDebugMode ? AppConfig.development() : AppConfig.production(),
  );

  // =====================================================
  // 🔹 3. Core - Storage & Utilities
  // =====================================================

  getIt.registerLazySingleton<LocalStorage>(
    () => LocalStorageImpl(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  getIt.registerLazySingleton<TokenManager>(
    () => TokenManagerImpl(getIt<FlutterSecureStorage>()),
  );

  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  getIt.registerLazySingleton<LocationService>(
    () => GeolocatorLocationService(),
  );

  getIt.registerLazySingleton<AuthEventBus>(() => AuthEventBus());

  getIt.registerLazySingleton<NominatimService>(() {
    // Create a clean Dio instance without AuthInterceptors for external APIs
    final nominatimDio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'com.mashena.rider', // Recommended by OSM
        },
      ),
    );
    return NominatimService(nominatimDio);
  });

  getIt.registerLazySingleton<OSRMRouteService>(() {
    final osrmDio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Accept': 'application/json'},
      ),
    );
    return OSRMRouteService(osrmDio);
  });

  // =====================================================
  // 🔹 4. Core - Networking Layer
  // =====================================================

  getIt.registerLazySingleton<Dio>(() {
    final config = getIt<AppConfig>();

    final dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: config.connectTimeout,
        receiveTimeout: config.receiveTimeout,
        sendTimeout: config.sendTimeout,
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    return dio;
  });

  getIt.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(
      dio: getIt<Dio>(),
      tokenManager: getIt<TokenManager>(),
      authEventBus: getIt<AuthEventBus>(),
    ),
  );

  getIt.registerLazySingleton<ApiClient>(() {
    final dio = getIt<Dio>();
    dio.interceptors.add(ApiLoggingInterceptor());
    dio.interceptors.add(getIt<AuthInterceptor>());
    return DioApiClient(dio: dio);
  });

  getIt.registerLazySingleton<SocketClient>(
    () => SocketIOClientImpl(getIt<AppConfig>(), getIt<TokenManager>()),
  );

  // =====================================================
  // 🔹 5. Features - Onboarding
  // =====================================================

  getIt.registerFactory<CompleteOnboarding>(
    () => CompleteOnboarding(getIt<LocalStorage>()),
  );

  getIt.registerFactory<GetOnboardingStatus>(
    () => GetOnboardingStatus(getIt<LocalStorage>()),
  );

  // =====================================================
  // 🔹 6. Features - Auth (Data Layer)
  // =====================================================

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(getIt<LocalStorage>(), getIt<TokenManager>()),
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<AuthLocalDataSource>(),
    ),
  );

  // =====================================================
  // 🔹 7. Features - Auth (Domain Layer / UseCases)
  // =====================================================

  getIt.registerFactory<SignupUsecase>(
    () => SignupUsecase(getIt<AuthRepository>()),
  );

  getIt.registerFactory<LoginUsecase>(
    () => LoginUsecase(getIt<AuthRepository>()),
  );

  getIt.registerFactory<VerifyOtpUsecase>(
    () => VerifyOtpUsecase(getIt<AuthRepository>()),
  );

  getIt.registerFactory<ResendOtpUsecase>(
    () => ResendOtpUsecase(getIt<AuthRepository>()),
  );

  getIt.registerFactory<GetCachedSessionUsecase>(
    () => GetCachedSessionUsecase(getIt<AuthRepository>()),
  );

  getIt.registerFactory<LogoutUsecase>(
    () => LogoutUsecase(getIt<AuthRepository>()),
  );

  // =====================================================
  // 🔹 8. Features - Auth (Presentation Layer)
  // =====================================================

  getIt.registerLazySingleton<AuthCubit>(
    () => AuthCubit(
      getIt<GetCachedSessionUsecase>(),
      getIt<LogoutUsecase>(),
      getIt<AuthEventBus>(),
    ),
  );

  getIt.registerLazySingleton<AuthSessionCache>(
    () => AuthSessionCache(getIt<GetCachedSessionUsecase>(), getIt<AuthCubit>()),
  );

  // =====================================================
  // 🔹  // Features - Profile
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt()),
  );
  getIt.registerFactory(() => ProfileCubit(getIt()));

  // Features - Home (Data & Domain)
  // =====================================================

  getIt.registerLazySingleton<RideSocketDataSource>(
    () => RideSocketDataSourceImpl(getIt<SocketClient>()),
  );

  getIt.registerLazySingleton<RideRepository>(
    () => RideRepositoryImpl(getIt<ApiClient>(), getIt<RideSocketDataSource>()),
  );

  getIt.registerFactory<CreateRideRequestUsecase>(
    () => CreateRideRequestUsecase(getIt<RideRepository>()),
  );

  getIt.registerFactory<SubmitRideRequestUsecase>(
    () => SubmitRideRequestUsecase(getIt<RideRepository>()),
  );

  getIt.registerFactory<CancelRideUsecase>(
    () => CancelRideUsecase(getIt<RideRepository>()),
  );

  // =====================================================
  // 🔹 10. Features - Home (Presentation Layer)
  // =====================================================

  getIt.registerFactory<PickAddressCubit>(
    () => PickAddressCubit(
      getIt<LocationService>(),
      getIt<NominatimService>(),
      getIt<CreateRideRequestUsecase>(),
    ),
  );

  getIt.registerLazySingleton<RatingRepository>(
    () => RatingRepositoryImpl(getIt<ApiClient>()),
  );

  getIt.registerFactory<TripRatingCubit>(
    () => TripRatingCubit(getIt<RatingRepository>()),
  );

}
