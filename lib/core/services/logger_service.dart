import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class LoggerService {
  const LoggerService._();

  static void debug(String message, {String? name, Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      developer.log(message, name: name ?? 'debug', error: error, stackTrace: stackTrace);
    }
  }

  static void info(String message, {String? name}) {
    if (kDebugMode) {
      developer.log(message, name: name ?? 'info');
    }
  }

  static void warning(String message, {String? name, Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      developer.log(message, name: name ?? 'warning', error: error, stackTrace: stackTrace);
    }
  }

  static void error(String message, {String? name, Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      developer.log(message, name: name ?? 'error', error: error, stackTrace: stackTrace);
    }
  }
}
