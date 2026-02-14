import 'package:mashena_rider/app/config/env.dart';

class AppConfig {
  final String baseUrl;
  final String apiKey;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final bool enableNetworkLogs;

  const AppConfig({
    required this.baseUrl,
    required this.apiKey,
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 20),
    this.sendTimeout = const Duration(seconds: 30),
    this.enableNetworkLogs = true,
  });

  // Factory لإنشاء Config من Environment
  factory AppConfig.fromEnv() {
    return AppConfig(
      baseUrl: Env.baseUrl,
      apiKey: Env.apiKey,
      enableNetworkLogs: Env.enableNetworkLogs,
    );
  }

  // Optional: للـ development/production configs
  factory AppConfig.development() {
    return AppConfig(
      baseUrl: Env.baseUrl,
      apiKey: Env.apiKey,
      enableNetworkLogs: true,
      connectTimeout: const Duration(seconds: 30), // أطول للتطوير
    );
  }

  factory AppConfig.production() {
    return AppConfig(
      baseUrl: Env.baseUrl,
      apiKey: Env.apiKey,
      enableNetworkLogs: false, // إيقاف logs في production
      connectTimeout: const Duration(seconds: 10),
    );
  }
}
