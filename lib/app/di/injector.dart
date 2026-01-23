import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mashena_rider/app/config/env.dart';
import 'package:mashena_rider/core/network/token_manager.dart';
import 'package:mashena_rider/core/network/token_manager_impl.dart';
import 'package:mashena_rider/core/storage/local_storage_impl.dart';
import 'package:mashena_rider/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/dio_client.dart';
import '../../core/network/network_info.dart';
import '../../core/storage/local_storage.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // Storage
  getIt.registerLazySingleton<LocalStorage>(
    () => LocalStorageImpl(getIt<SharedPreferences>()),
  );

  // Dio + Token
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<TokenManager>(
    () => TokenManagerImpl(getIt<SharedPreferences>()), // عدّل حسب عندك
  );

  // Network
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // Usecases
  getIt.registerLazySingleton<CompleteOnboarding>(
    () => CompleteOnboarding(getIt<LocalStorage>()),
  );

  // ApiClient
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(
      tokenManager: getIt<TokenManager>(),
      dio: getIt<Dio>(),
      baseUrl: Env.baseUrl,
    ),
  );
}
