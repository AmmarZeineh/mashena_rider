import 'dart:async';
import 'package:mashena_rider/app/config/app_config.dart';
import 'package:mashena_rider/core/network/token_refresh_service.dart';
import 'package:mashena_rider/core/services/logger_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'socket_client.dart';

/// Concrete implementation of [SocketClient] using the `socket_io_client` package.
class SocketIOClientImpl implements SocketClient {
  final AppConfig _config;
  final TokenRefreshService _tokenRefreshService;

  socket_io.Socket? _socket;
  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();
  final Map<String, Set<void Function(dynamic)>> _eventListeners = {};
  bool _isHandlingAuthError = false;

  SocketIOClientImpl(this._config, this._tokenRefreshService);

  @override
  bool get isConnected => _socket?.connected ?? false;

  @override
  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  @override
  Future<void> connect() async {
    // If socket exists and is already connected, do nothing
    if (_socket != null && _socket!.connected) {
      return;
    }

    final token = await _tokenRefreshService.getValidAccessToken();
    if (token == null || token.isEmpty) {
      LoggerService.debug(
        'Socket connection failed: No valid access token found.',
        name: 'core.network.socket',
      );
      _connectionStatusController.add(false);
      return;
    }

    LoggerService.debug(
      'Socket connecting with valid token (present: true)',
      name: 'core.network.socket',
    );

    // Clean up existing socket before creating a new one
    if (_socket != null) {
      _socket!.destroy();
      _socket = null;
    }

    LoggerService.debug(
      'Connecting to socket server: ${_config.socketUrl}',
      name: 'core.network.socket',
    );

    try {
      final authToken = token.startsWith('Bearer ') ? token : 'Bearer $token';
      _socket = socket_io.io(
        _config.socketUrl,
        socket_io.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(double.maxFinite.toInt())
            .setReconnectionDelay(1000)
            .setReconnectionDelayMax(5000)
            .setAuth({'token': authToken})
            .build(),
      );

      // Register connection status callbacks
      _socket!.onConnect((_) {
        LoggerService.debug(
          'Socket connected successfully',
          name: 'core.network.socket',
        );
        _connectionStatusController.add(true);
      });

      _socket!.onReconnect((_) {
        LoggerService.debug(
          'Socket reconnected successfully',
          name: 'core.network.socket',
        );
        _connectionStatusController.add(true);
      });

      _socket!.onDisconnect((data) {
        LoggerService.debug(
          'Socket disconnected: $data',
          name: 'core.network.socket',
        );
        _connectionStatusController.add(false);
      });

      _socket!.onConnectError((err) {
        LoggerService.debug(
          'Socket connection error: $err',
          name: 'core.network.socket',
        );
        _connectionStatusController.add(false);
        _handleConnectError(err);
      });

      // Bind all existing event listeners to the new socket instance
      _eventListeners.forEach((event, listeners) {
        for (final callback in listeners) {
          _socket!.on(event, callback);
        }
      });

      _socket!.connect();
    } catch (e, stackTrace) {
      LoggerService.debug(
        'Error during socket initialization',
        name: 'core.network.socket',
        error: e,
        stackTrace: stackTrace,
      );
      _connectionStatusController.add(false);
    }
  }

  void _handleConnectError(dynamic err) async {
    final errString = err.toString().toLowerCase();
    final isUnauthorized =
        errString.contains('unauthorized') ||
        errString.contains('jwt') ||
        errString.contains('token') ||
        (err is Map &&
            err['message']?.toString().toLowerCase().contains('unauthorized') ==
                true);

    if (isUnauthorized && !_isHandlingAuthError) {
      _isHandlingAuthError = true;
      LoggerService.debug(
        'Socket connection failed due to authorization. Attempting token refresh...',
        name: 'core.network.socket',
      );
      try {
        final refreshed = await _tokenRefreshService.refreshToken();
        if (refreshed) {
          LoggerService.debug(
            'Token refreshed successfully after socket auth error. Reconnecting socket...',
            name: 'core.network.socket',
          );
          if (_socket != null) {
            _socket!.destroy();
            _socket = null;
          }
          await connect();
        } else {
          LoggerService.debug(
            'Failed to refresh token after socket auth error. Disconnecting.',
            name: 'core.network.socket',
          );
          disconnect();
        }
      } finally {
        _isHandlingAuthError = false;
      }
    }
  }

  @override
  Future<bool> ensureConnected({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    if (isConnected) return true;

    final completer = Completer<bool>();
    StreamSubscription<bool>? subscription;

    subscription = connectionStatusStream.listen((connected) {
      if (connected && !completer.isCompleted) {
        completer.complete(true);
      }
    });

    unawaited(connect());

    final timeoutTimer = Timer(timeout, () {
      if (!completer.isCompleted) {
        LoggerService.debug(
          'ensureConnected timed out after ${timeout.inSeconds}s (connected: $isConnected)',
          name: 'core.network.socket',
        );
        completer.complete(isConnected);
      }
    });

    try {
      return await completer.future;
    } finally {
      timeoutTimer.cancel();
      await subscription.cancel();
    }
  }

  @override
  void disconnect() {
    if (_socket != null) {
      LoggerService.debug(
        'Disconnecting socket...',
        name: 'core.network.socket',
      );
      _socket!.disconnect();
      _socket!.destroy();
      _socket = null;
      _connectionStatusController.add(false);
    }
  }

  @override
  void emit(String event, [dynamic data]) {
    if (_socket != null) {
      LoggerService.debug(
        'Emitting event: $event with data: $data',
        name: 'core.network.socket',
      );
      _socket!.emit(event, data);
    } else {
      LoggerService.debug(
        'Cannot emit event $event. Socket is not initialized.',
        name: 'core.network.socket',
      );
    }
  }

  @override
  void on(String event, void Function(dynamic data) callback) {
    _eventListeners.putIfAbsent(event, () => {}).add(callback);
    _socket?.on(event, callback);
  }

  @override
  void off(String event) {
    _eventListeners.remove(event);
    _socket?.off(event);
  }

  @override
  void dispose() {
    disconnect();
    _connectionStatusController.close();
  }
}
