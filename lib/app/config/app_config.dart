import 'package:mashena_rider/app/config/env.dart';

class AppConfig {
  final String baseUrl;
  final String socketUrl;
  final String apiKey;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final bool enableNetworkLogs;

  const AppConfig({
    required this.baseUrl,
    required this.socketUrl,
    required this.apiKey,
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 20),
    this.sendTimeout = const Duration(seconds: 30),
    this.enableNetworkLogs = true,
  });

  // Helper to derive socket URL from base URL if envSocketUrl is empty
  static String _deriveSocketUrl(String baseUrl, String envSocketUrl) {
    if (envSocketUrl.isNotEmpty) return envSocketUrl;
    final uri = Uri.tryParse(baseUrl);
    if (uri != null) {
      return '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}';
    }
    return baseUrl;
  }

  // Factory لإنشاء Config من Environment
  factory AppConfig.fromEnv() {
    final base = Env.baseUrl;
    return AppConfig(
      baseUrl: base,
      socketUrl: _deriveSocketUrl(base, Env.socketUrl),
      apiKey: Env.apiKey,
      enableNetworkLogs: Env.enableNetworkLogs,
    );
  }

  // Optional: للـ development/production configs
  factory AppConfig.development() {
    final base = Env.baseUrl;
    return AppConfig(
      baseUrl: base,
      socketUrl: _deriveSocketUrl(base, Env.socketUrl),
      apiKey: Env.apiKey,
      enableNetworkLogs: true,
      connectTimeout: const Duration(seconds: 30), // أطول للتطوير
    );
  }

  factory AppConfig.production() {
    final base = Env.baseUrl;
    return AppConfig(
      baseUrl: base,
      socketUrl: _deriveSocketUrl(base, Env.socketUrl),
      apiKey: Env.apiKey,
      enableNetworkLogs: false, // إيقاف logs في production
      connectTimeout: const Duration(seconds: 10),
    );
  }
}
