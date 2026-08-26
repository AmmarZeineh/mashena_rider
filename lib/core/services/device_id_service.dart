import 'dart:math';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/core/storage/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for generating and persisting a unique device identifier across sessions.
final class DeviceIdService {
  const DeviceIdService._();

  static const String _deviceIdKey = 'mashena_rider_device_id';
  static String? _cachedDeviceId;

  /// Retrieves the existing device ID or generates, stores, and returns a new one.
  static Future<String> getOrCreateDeviceId() async {
    if (_cachedDeviceId != null) return _cachedDeviceId!;

    // Try reading from LocalStorage if available
    try {
      if (getIt.isRegistered<LocalStorage>()) {
        final storage = getIt<LocalStorage>();
        final savedId = storage.getString(_deviceIdKey);
        if (savedId != null && savedId.isNotEmpty) {
          _cachedDeviceId = savedId;
          return savedId;
        }
      }
    } catch (_) {}

    // Fallback reading directly from SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedId = prefs.getString(_deviceIdKey);
      if (savedId != null && savedId.isNotEmpty) {
        _cachedDeviceId = savedId;
        return savedId;
      }

      // Generate a new UUID v4-like identifier
      final newId = _generateUuid();
      await prefs.setString(_deviceIdKey, newId);
      _cachedDeviceId = newId;
      return newId;
    } catch (_) {
      // Fallback in-memory ID if storage is unavailable
      final fallbackId = _generateUuid();
      _cachedDeviceId = fallbackId;
      return fallbackId;
    }
  }

  static String _generateUuid() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(256));

    // Set UUID version to 4
    values[6] = (values[6] & 0x0f) | 0x40;
    // Set UUID variant to RFC 4122
    values[8] = (values[8] & 0x3f) | 0x80;

    final hex = values.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20, 32)}';
  }
}
