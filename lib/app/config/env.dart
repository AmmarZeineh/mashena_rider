import 'package:flutter_dotenv/flutter_dotenv.dart';

final class Env {
  const Env._();

  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static String get googleApiKey => dotenv.env['GOOGLE_MAPS_KEY'] ?? '';

  static bool get enableNetworkLogs =>
      dotenv.env['ENABLE_NETWORK_LOGS']?.toLowerCase() == 'true';
}
