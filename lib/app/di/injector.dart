import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mashena_rider/core/network/token_manager.dart';

import '../../core/network/dio_client.dart';
import '../../core/network/network_info.dart';
import '../../core/storage/local_storage.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  Prefs.init();

  // Core
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  // ApiClient
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(
      tokenManager: getIt<TokenManager>(),
      dio: getIt<Dio>(),
      baseUrl: 'https://YOUR_BASE_URL_HERE', // غيّره
    ),
  );
}
