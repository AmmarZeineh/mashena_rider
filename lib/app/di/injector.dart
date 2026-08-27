import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:mashena_rider/core/auth/auth_event_bus.dart';
import 'package:mashena_rider/features/home/data/repositories/rating_repository_impl.dart';
import 'package:mashena_rider/features/home/domain/repositories/rating_repository.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/pick_shared_trip_address_cubit/pick_shared_trip_address_cubit.dart';
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
import 'package:mashena_rider/core/network/token_refresh_service.dart';

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

import 'package:mashena_rider/features/settings/presentation/cubits/settings_cubit.dart';
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
import 'package:mashena_rider/features/home/domain/usecases/share_trip_usecase.dart';
import 'package:mashena_rider/features/home/domain/usecases/revoke_share_trip_usecase.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/trip_share_cubit/trip_share_cubit.dart';
import 'package:mashena_rider/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:mashena_rider/features/profile/domain/repositories/profile_repository.dart';
import 'package:mashena_rider/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:mashena_rider/features/home/data/datasources/ride_socket_data_source.dart';
import 'package:mashena_rider/features/home/data/repositories/ride_repository_impl.dart';
import 'package:mashena_rider/features/home/presentation/address/cubits/pick_address_cubit/pick_address_cubit.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/trip_rating_cubit.dart';
import 'package:mashena_rider/features/coupons/data/repositories/coupons_repository_impl.dart';
import 'package:mashena_rider/features/coupons/domain/repositories/coupons_repository.dart';
import 'package:mashena_rider/features/coupons/presentation/cubits/coupons_cubit.dart';
import 'package:mashena_rider/features/trip_history/data/repositories/trip_history_repository_impl.dart';
import 'package:mashena_rider/features/trip_history/domain/repositories/trip_history_repository.dart';
import 'package:mashena_rider/features/trip_history/presentation/cubits/trip_history_cubit.dart';
import 'package:mashena_rider/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:mashena_rider/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:mashena_rider/features/notifications/presentation/cubits/notifications_cubit.dart';
import 'package:mashena_rider/features/shared_trip/data/datasources/shared_trip_remote_data_source.dart';
import 'package:mashena_rider/features/shared_trip/data/datasources/shared_trip_socket_data_source.dart';
import 'package:mashena_rider/features/shared_trip/data/repositories/shared_trip_repository_impl.dart';
import 'package:mashena_rider/features/shared_trip/domain/repositories/shared_trip_repository.dart';
import 'package:mashena_rider/features/shared_trip/domain/usecases/search_shared_rides_usecase.dart';
import 'package:mashena_rider/features/shared_trip/domain/usecases/get_shared_ride_details_usecase.dart';
import 'package:mashena_rider/features/shared_trip/domain/usecases/join_shared_ride_usecase.dart';
import 'package:mashena_rider/features/shared_trip/domain/usecases/leave_shared_ride_usecase.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/shared_trip_rooms_cubit/shared_trip_rooms_cubit.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/shared_trip_room_details_cubit/shared_trip_room_details_cubit.dart';
import 'package:mashena_rider/features/shared_trip/presentation/models/shared_trip_rooms_args.dart';
import 'package:mashena_rider/features/pool/data/datasources/pool_remote_data_source.dart';
import 'package:mashena_rider/features/pool/data/datasources/pool_socket_data_source.dart';
import 'package:mashena_rider/features/pool/data/repositories/pool_repository_impl.dart';
import 'package:mashena_rider/features/pool/domain/repositories/pool_repository.dart';
import 'package:mashena_rider/features/pool/domain/usecases/get_pool_suggestions_usecase.dart';
import 'package:mashena_rider/features/pool/domain/usecases/create_pool_room_usecase.dart';
import 'package:mashena_rider/features/pool/domain/usecases/get_pool_room_details_usecase.dart';
import 'package:mashena_rider/features/pool/domain/usecases/join_pool_room_usecase.dart';
import 'package:mashena_rider/features/pool/domain/usecases/leave_pool_room_usecase.dart';
import 'package:mashena_rider/features/pool/domain/usecases/cancel_pool_room_usecase.dart';
import 'package:mashena_rider/features/pool/presentation/cubits/pool_discovery_cubit/pool_discovery_cubit.dart';
import 'package:mashena_rider/features/pool/presentation/cubits/pool_create_cubit/pool_create_cubit.dart';
import 'package:mashena_rider/features/pool/presentation/cubits/pool_lobby_cubit/pool_lobby_cubit.dart';
import 'package:mashena_rider/features/pool/presentation/models/pool_discovery_args.dart';

// ======================
// Features - Moderation
// ======================
import 'package:mashena_rider/features/moderation/data/datasources/moderation_remote_data_source.dart';
import 'package:mashena_rider/features/moderation/data/datasources/moderation_socket_data_source.dart';
import 'package:mashena_rider/features/moderation/data/repositories/moderation_repository_impl.dart';
import 'package:mashena_rider/features/moderation/domain/repositories/moderation_repository.dart';
import 'package:mashena_rider/features/moderation/domain/usecases/get_moderation_overview_usecase.dart';
import 'package:mashena_rider/features/moderation/domain/usecases/get_penalties_history_usecase.dart';
import 'package:mashena_rider/features/moderation/domain/usecases/get_violations_history_usecase.dart';
import 'package:mashena_rider/features/moderation/domain/usecases/get_active_restrictions_usecase.dart';
import 'package:mashena_rider/features/moderation/domain/usecases/submit_appeal_usecase.dart';
import 'package:mashena_rider/features/moderation/domain/usecases/get_appeals_history_usecase.dart';

// ======================
// Features - Active Trips
// ======================
import 'package:mashena_rider/features/active_trips/data/datasources/active_trips_remote_data_source.dart';
import 'package:mashena_rider/features/active_trips/data/repositories/active_trips_repository_impl.dart';
import 'package:mashena_rider/features/active_trips/domain/repositories/active_trips_repository.dart';
import 'package:mashena_rider/features/active_trips/domain/usecases/get_active_trips_usecase.dart';
import 'package:mashena_rider/features/active_trips/presentation/cubits/active_trips_cubit.dart';
import 'package:mashena_rider/features/moderation/domain/usecases/get_appeal_details_usecase.dart';
import 'package:mashena_rider/features/moderation/presentation/cubits/moderation_overview_cubit/moderation_overview_cubit.dart';
import 'package:mashena_rider/features/moderation/presentation/cubits/penalties_history_cubit/penalties_history_cubit.dart';
import 'package:mashena_rider/features/moderation/presentation/cubits/violations_history_cubit/violations_history_cubit.dart';
import 'package:mashena_rider/features/moderation/presentation/cubits/appeals_history_cubit/appeals_history_cubit.dart';
import 'package:mashena_rider/features/moderation/presentation/cubits/submit_appeal_cubit/submit_appeal_cubit.dart';

// ======================
// Features - Wallet
// ======================
import 'package:mashena_rider/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:mashena_rider/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:mashena_rider/features/wallet/domain/usecases/get_my_wallet_usecase.dart';
import 'package:mashena_rider/features/wallet/domain/usecases/get_my_wallet_transactions_usecase.dart';
import 'package:mashena_rider/features/wallet/presentation/cubits/wallet_cubit/wallet_cubit.dart';
import 'package:mashena_rider/features/wallet/presentation/cubits/wallet_transactions_cubit/wallet_transactions_cubit.dart';

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

    // Validate that baseUrl is not empty to prevent invalid Dio configuration
    final baseUrl = config.baseUrl;
    if (baseUrl.isEmpty) {
      // In development, provide a fallback URL to prevent silent failures
      // In production, throw an error to alert about missing configuration
      if (kDebugMode) {
        print(
          'WARNING: BASE_URL is empty. Using fallback URL for development.',
        );
        // Use a placeholder - in real scenarios, this should be configured properly
        // This prevents Dio from crashing but will cause API calls to fail obviously
        // which is better than silent failures
        final fallbackUrl = 'https://placeholder-api.mashena-rider.com';
        return Dio(
          BaseOptions(
            baseUrl: fallbackUrl,
            connectTimeout: config.connectTimeout,
            receiveTimeout: config.receiveTimeout,
            sendTimeout: config.sendTimeout,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );
      } else {
        throw StateError(
          'BASE_URL is not configured. Please check your .env file and ensure BASE_URL is set.',
        );
      }
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
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

  getIt.registerLazySingleton<TokenRefreshService>(
    () => TokenRefreshServiceImpl(
      dio: getIt<Dio>(),
      tokenManager: getIt<TokenManager>(),
      authEventBus: getIt<AuthEventBus>(),
    ),
  );

  getIt.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(
      dio: getIt<Dio>(),
      tokenManager: getIt<TokenManager>(),
      tokenRefreshService: getIt<TokenRefreshService>(),
    ),
  );

  getIt.registerLazySingleton<ApiClient>(() {
    final dio = getIt<Dio>();
    dio.interceptors.add(ApiLoggingInterceptor());
    dio.interceptors.add(getIt<AuthInterceptor>());
    return DioApiClient(dio: dio);
  });

  getIt.registerLazySingleton<SocketClient>(
    () => SocketIOClientImpl(
      getIt<AppConfig>(),
      getIt<TokenRefreshService>(),
      getIt<AuthEventBus>(),
    ),
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
    () =>
        AuthSessionCache(getIt<GetCachedSessionUsecase>(), getIt<AuthCubit>()),
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

  getIt.registerFactory<ShareTripUsecase>(
    () => ShareTripUsecase(getIt<RideRepository>()),
  );

  getIt.registerFactory<RevokeShareTripUsecase>(
    () => RevokeShareTripUsecase(getIt<RideRepository>()),
  );

  getIt.registerFactory<TripShareCubit>(
    () => TripShareCubit(
      getIt<ShareTripUsecase>(),
      getIt<RevokeShareTripUsecase>(),
    ),
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

  getIt.registerFactory<PickSharedTripAddressCubit>(
    () => PickSharedTripAddressCubit(
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

  // =====================================================
  // 🔹 11. Features - Coupons
  // =====================================================

  getIt.registerLazySingleton<CouponsRepository>(
    () => CouponsRepositoryImpl(getIt<ApiClient>()),
  );

  getIt.registerFactory<CouponsCubit>(
    () => CouponsCubit(getIt<CouponsRepository>()),
  );

  // =====================================================
  // 🔹 12. Features - Trip History
  // =====================================================

  getIt.registerLazySingleton<TripHistoryRepository>(
    () => TripHistoryRepositoryImpl(getIt<ApiClient>()),
  );

  getIt.registerFactory<TripHistoryCubit>(
    () => TripHistoryCubit(getIt<TripHistoryRepository>()),
  );

  // =====================================================
  // 🔹 13. Features - Shared Rides
  // =====================================================

  getIt.registerLazySingleton<SharedTripRemoteDataSource>(
    () => SharedTripRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<SharedTripSocketDataSource>(
    () => SharedTripSocketDataSourceImpl(getIt<SocketClient>()),
  );

  getIt.registerLazySingleton<SharedTripRepository>(
    () => SharedTripRepositoryImpl(
      remoteDataSource: getIt<SharedTripRemoteDataSource>(),
      socketDataSource: getIt<SharedTripSocketDataSource>(),
    ),
  );

  getIt.registerFactory<SearchSharedRidesUsecase>(
    () => SearchSharedRidesUsecase(getIt<SharedTripRepository>()),
  );

  getIt.registerFactory<GetSharedRideDetailsUsecase>(
    () => GetSharedRideDetailsUsecase(getIt<SharedTripRepository>()),
  );

  getIt.registerFactory<JoinSharedRideUsecase>(
    () => JoinSharedRideUsecase(getIt<SharedTripRepository>()),
  );

  getIt.registerFactory<LeaveSharedRideUsecase>(
    () => LeaveSharedRideUsecase(getIt<SharedTripRepository>()),
  );

  getIt.registerFactoryParam<SharedTripRoomsCubit, SharedTripRoomsArgs, void>(
    (args, _) => SharedTripRoomsCubit(
      searchSharedRidesUsecase: getIt<SearchSharedRidesUsecase>(),
      args: args,
    ),
  );

  getIt.registerFactoryParam<SharedTripRoomDetailsCubit, int, void>(
    (roomId, _) => SharedTripRoomDetailsCubit(
      getSharedRideDetailsUsecase: getIt<GetSharedRideDetailsUsecase>(),
      joinSharedRideUsecase: getIt<JoinSharedRideUsecase>(),
      leaveSharedRideUsecase: getIt<LeaveSharedRideUsecase>(),
      repository: getIt<SharedTripRepository>(),
      getCachedSessionUsecase: getIt<GetCachedSessionUsecase>(),
      roomId: roomId,
    ),
  );

  // =====================================================
  // 🔹 14. Features - Notifications
  // =====================================================

  getIt.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(getIt<ApiClient>()),
  );

  getIt.registerFactory<NotificationsCubit>(
    () => NotificationsCubit(getIt<NotificationsRepository>()),
  );

  // =====================================================
  // 🔹 15. Features - Passenger Pool
  // =====================================================

  getIt.registerLazySingleton<PoolRemoteDataSource>(
    () => PoolRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<PoolSocketDataSource>(
    () => PoolSocketDataSourceImpl(getIt<SocketClient>()),
  );

  getIt.registerLazySingleton<PoolRepository>(
    () => PoolRepositoryImpl(
      remoteDataSource: getIt<PoolRemoteDataSource>(),
      socketDataSource: getIt<PoolSocketDataSource>(),
    ),
  );

  getIt.registerFactory<GetPoolSuggestionsUsecase>(
    () => GetPoolSuggestionsUsecase(getIt<PoolRepository>()),
  );

  getIt.registerFactory<CreatePoolRoomUsecase>(
    () => CreatePoolRoomUsecase(getIt<PoolRepository>()),
  );

  getIt.registerFactory<GetPoolRoomDetailsUsecase>(
    () => GetPoolRoomDetailsUsecase(getIt<PoolRepository>()),
  );

  getIt.registerFactory<JoinPoolRoomUsecase>(
    () => JoinPoolRoomUsecase(getIt<PoolRepository>()),
  );

  getIt.registerFactory<LeavePoolRoomUsecase>(
    () => LeavePoolRoomUsecase(getIt<PoolRepository>()),
  );

  getIt.registerFactory<CancelPoolRoomUsecase>(
    () => CancelPoolRoomUsecase(getIt<PoolRepository>()),
  );

  getIt.registerFactoryParam<PoolDiscoveryCubit, PoolDiscoveryArgs, void>(
    (args, _) => PoolDiscoveryCubit(
      getPoolSuggestionsUsecase: getIt<GetPoolSuggestionsUsecase>(),
      joinPoolRoomUsecase: getIt<JoinPoolRoomUsecase>(),
      args: args,
    ),
  );

  getIt.registerFactoryParam<PoolCreateCubit, PoolDiscoveryArgs, void>(
    (args, _) => PoolCreateCubit(
      createPoolRoomUsecase: getIt<CreatePoolRoomUsecase>(),
      args: args,
    ),
  );

  getIt.registerFactoryParam<PoolLobbyCubit, int, void>(
    (roomId, _) => PoolLobbyCubit(
      getPoolRoomDetailsUsecase: getIt<GetPoolRoomDetailsUsecase>(),
      leavePoolRoomUsecase: getIt<LeavePoolRoomUsecase>(),
      cancelPoolRoomUsecase: getIt<CancelPoolRoomUsecase>(),
      repository: getIt<PoolRepository>(),
      getCachedSessionUsecase: getIt<GetCachedSessionUsecase>(),
      osrmRouteService: getIt<OSRMRouteService>(),
      roomId: roomId,
    ),
  );

  // =====================================================
  // 🔹 16. Features - Moderation
  // =====================================================

  getIt.registerLazySingleton<ModerationRemoteDataSource>(
    () => ModerationRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<ModerationSocketDataSource>(
    () => ModerationSocketDataSourceImpl(getIt<SocketClient>()),
  );

  getIt.registerLazySingleton<ModerationRepository>(
    () => ModerationRepositoryImpl(
      remoteDataSource: getIt<ModerationRemoteDataSource>(),
      socketDataSource: getIt<ModerationSocketDataSource>(),
    ),
  );

  getIt.registerFactory<GetModerationOverviewUsecase>(
    () => GetModerationOverviewUsecase(getIt<ModerationRepository>()),
  );

  getIt.registerFactory<GetPenaltiesHistoryUsecase>(
    () => GetPenaltiesHistoryUsecase(getIt<ModerationRepository>()),
  );

  getIt.registerFactory<GetViolationsHistoryUsecase>(
    () => GetViolationsHistoryUsecase(getIt<ModerationRepository>()),
  );

  getIt.registerFactory<GetActiveRestrictionsUsecase>(
    () => GetActiveRestrictionsUsecase(getIt<ModerationRepository>()),
  );

  getIt.registerFactory<SubmitAppealUsecase>(
    () => SubmitAppealUsecase(getIt<ModerationRepository>()),
  );

  getIt.registerFactory<GetAppealsHistoryUsecase>(
    () => GetAppealsHistoryUsecase(getIt<ModerationRepository>()),
  );

  getIt.registerFactory<GetAppealDetailsUsecase>(
    () => GetAppealDetailsUsecase(getIt<ModerationRepository>()),
  );

  getIt.registerFactory<ModerationOverviewCubit>(
    () => ModerationOverviewCubit(
      getOverviewUsecase: getIt<GetModerationOverviewUsecase>(),
      repository: getIt<ModerationRepository>(),
    ),
  );

  getIt.registerFactory<PenaltiesHistoryCubit>(
    () => PenaltiesHistoryCubit(getIt<GetPenaltiesHistoryUsecase>()),
  );

  getIt.registerFactory<ViolationsHistoryCubit>(
    () => ViolationsHistoryCubit(getIt<GetViolationsHistoryUsecase>()),
  );

  getIt.registerFactory<AppealsHistoryCubit>(
    () => AppealsHistoryCubit(getIt<GetAppealsHistoryUsecase>()),
  );

  getIt.registerFactory<SubmitAppealCubit>(
    () => SubmitAppealCubit(getIt<SubmitAppealUsecase>()),
  );

  // ======================
  // Features - Active Trips
  // ======================
  getIt.registerLazySingleton<ActiveTripsRemoteDataSource>(
    () => ActiveTripsRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<ActiveTripsRepository>(
    () => ActiveTripsRepositoryImpl(getIt<ActiveTripsRemoteDataSource>()),
  );

  getIt.registerFactory<GetActiveTripsUsecase>(
    () => GetActiveTripsUsecase(getIt<ActiveTripsRepository>()),
  );

  getIt.registerFactory<ActiveTripsCubit>(
    () => ActiveTripsCubit(getIt<GetActiveTripsUsecase>()),
  );

  // ======================
  // Features - Settings
  // ======================
  getIt.registerLazySingleton<SettingsCubit>(
    () => SettingsCubit(getIt<LocalStorage>()),
  );

  // ======================
  // Features - Wallet
  // ======================
  getIt.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(getIt<ApiClient>()),
  );

  getIt.registerFactory<GetMyWalletUsecase>(
    () => GetMyWalletUsecase(getIt<WalletRepository>()),
  );

  getIt.registerFactory<WalletCubit>(
    () => WalletCubit(getIt<GetMyWalletUsecase>()),
  );

  getIt.registerFactory<GetMyWalletTransactionsUsecase>(
    () => GetMyWalletTransactionsUsecase(getIt<WalletRepository>()),
  );

  getIt.registerFactory<WalletTransactionsCubit>(
    () => WalletTransactionsCubit(getIt<GetMyWalletTransactionsUsecase>()),
  );
}
