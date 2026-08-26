import 'dart:async';
import 'dart:math';
import 'package:mashena_rider/app/config/app_config.dart';
import 'package:mashena_rider/core/auth/auth_event.dart';
import 'package:mashena_rider/core/auth/auth_event_bus.dart';
import 'package:mashena_rider/core/network/token_refresh_service.dart';
import 'package:mashena_rider/core/services/logger_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'socket_client.dart';

/// Concrete implementation of [SocketClient] using the `socket_io_client` package.
class SocketIOClientImpl implements SocketClient {
  final AppConfig _config;
  final TokenRefreshService _tokenRefreshService;
  final AuthEventBus _authEventBus;

  socket_io.Socket? _socket;
  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();
  final Map<String, Set<void Function(dynamic)>> _eventListeners = {};

  StreamSubscription<AuthEvent>? _authSubscription;
  Completer<bool>? _connectionCompleter;
  Completer<void>? _reconnectCompleter;
  bool _isHandlingAuthError = false;
  int _authRetryCount = 0;
  static const int _maxAuthRetries = 5;

  SocketIOClientImpl(
    this._config,
    this._tokenRefreshService,
    this._authEventBus,
  ) {
    _subscribeToAuthEvents();
  }

  void _subscribeToAuthEvents() {
    _authSubscription = _authEventBus.stream.listen((event) {
      switch (event) {
        case AuthEvent.loggedOut:
          LoggerService.debug(
            'AuthEvent.loggedOut received. Disconnecting socket and resetting state.',
            name: 'core.network.socket',
          );
          disconnect();
          break;
        case AuthEvent.tokenRefreshed:
          LoggerService.debug(
            'AuthEvent.tokenRefreshed received. Reconnecting socket with fresh token.',
            name: 'core.network.socket',
          );
          unawaited(reconnect());
          break;
      }
    });
  }

  @override
  bool get isConnected => _socket?.connected ?? false;

  @override
  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  @override
  Future<void> connect() async {
    // If socket is already connected, return immediately
    if (_socket != null && _socket!.connected) {
      return;
    }

    // Coalesce concurrent connection attempts onto a single in-flight operation
    if (_connectionCompleter != null) {
      await _connectionCompleter!.future;
      return;
    }

    final completer = Completer<bool>();
    _connectionCompleter = completer;

    try {
      final token = await _tokenRefreshService.getValidAccessToken();
      if (token == null || token.isEmpty) {
        LoggerService.debug(
          'Socket connection aborted: No valid access token found.',
          name: 'core.network.socket',
        );
        _notifyStatus(false);
        if (!completer.isCompleted) completer.complete(false);
        return;
      }

      LoggerService.debug(
        'Socket connecting with valid token to: ${_config.socketUrl}',
        name: 'core.network.socket',
      );

      // Clean up previous socket instance before creating a new one
      _destroyCurrentSocket();

      final cleanToken = token.startsWith('Bearer ')
          ? token.substring(7).trim()
          : token.trim();

      _socket = socket_io.io(
        _config.socketUrl,
        socket_io.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(10)
            .setReconnectionDelay(1000)
            .setReconnectionDelayMax(5000)
            .setAuth({
              'token': cleanToken,
              'accessToken': cleanToken,
            })
            .setExtraHeaders({
              'Authorization': 'Bearer $cleanToken',
            })
            .build(),
      );

      _registerSocketCallbacks(completer);
      _bindRegisteredEventListeners();

      _socket!.connect();
      await completer.future;
    } catch (e, stackTrace) {
      LoggerService.error(
        'Error during socket initialization',
        name: 'core.network.socket',
        error: e,
        stackTrace: stackTrace,
      );
      _notifyStatus(false);
      if (!completer.isCompleted) completer.complete(false);
    } finally {
      if (_connectionCompleter == completer) {
        _connectionCompleter = null;
      }
    }
  }

  void _registerSocketCallbacks(Completer<bool> initialConnectCompleter) {
    if (_socket == null) return;

    _socket!.onConnect((_) {
      LoggerService.debug(
        'Socket connected successfully',
        name: 'core.network.socket',
      );
      _authRetryCount = 0;
      _isHandlingAuthError = false;
      _notifyStatus(true);
      if (!initialConnectCompleter.isCompleted) {
        initialConnectCompleter.complete(true);
      }
    });

    _socket!.onReconnect((_) {
      LoggerService.debug(
        'Socket reconnected successfully',
        name: 'core.network.socket',
      );
      _authRetryCount = 0;
      _isHandlingAuthError = false;
      _notifyStatus(true);
      if (!initialConnectCompleter.isCompleted) {
        initialConnectCompleter.complete(true);
      }
    });

    _socket!.onDisconnect((data) {
      LoggerService.debug(
        'Socket disconnected: $data',
        name: 'core.network.socket',
      );
      _notifyStatus(false);
    });

    _socket!.onConnectError((err) {
      LoggerService.debug(
        'Socket connect error: $err',
        name: 'core.network.socket',
      );
      _notifyStatus(false);
      if (!initialConnectCompleter.isCompleted) {
        initialConnectCompleter.complete(false);
      }
      _handleConnectError(err);
    });

    _socket!.onError((err) {
      LoggerService.debug(
        'Socket general error: $err',
        name: 'core.network.socket',
      );
    });

    // Dynamic token injection before every reconnection attempt
    _socket!.on('reconnect_attempt', (_) async {
      LoggerService.debug(
        'Socket reconnect_attempt triggered. Checking and refreshing token...',
        name: 'core.network.socket',
      );
      final token = await _tokenRefreshService.getValidAccessToken();
      if (token != null && token.isNotEmpty) {
        final clean = token.startsWith('Bearer ')
            ? token.substring(7).trim()
            : token.trim();
        _socket?.io.options?['auth'] = {
          'token': clean,
          'accessToken': clean,
        };
        _socket?.io.options?['extraHeaders'] = {
          'Authorization': 'Bearer $clean',
        };
      }
    });

    _socket!.on('reconnect_error', (err) {
      LoggerService.debug(
        'Socket reconnect error: $err',
        name: 'core.network.socket',
      );
      _handleConnectError(err);
    });

    _socket!.on('reconnect_failed', (_) {
      LoggerService.warning(
        'Socket auto-reconnection failed after maximum attempts',
        name: 'core.network.socket',
      );
      _notifyStatus(false);
      if (!initialConnectCompleter.isCompleted) {
        initialConnectCompleter.complete(false);
      }
    });
  }

  void _bindRegisteredEventListeners() {
    if (_socket == null) return;
    _eventListeners.forEach((event, listeners) {
      for (final callback in listeners) {
        _socket!.on(event, callback);
      }
    });
  }

  void _notifyStatus(bool isConnected) {
    if (!_connectionStatusController.isClosed) {
      _connectionStatusController.add(isConnected);
    }
  }

  void _destroyCurrentSocket() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.destroy();
      _socket = null;
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
      if (_authRetryCount >= _maxAuthRetries) {
        LoggerService.warning(
          'Socket auth failed after $_authRetryCount retries. Halting auto-refresh to prevent infinite loop.',
          name: 'core.network.socket',
        );
        disconnect();
        return;
      }

      _isHandlingAuthError = true;
      _authRetryCount++;

      // Calculate delay with exponential backoff: 1s, 2s, 4s, 8s, 16s (up to max retries)
      final delayMs = (pow(2, _authRetryCount - 1) * 1000).toInt();
      LoggerService.debug(
        'Socket connection failed due to authorization (attempt $_authRetryCount/$_maxAuthRetries). '
        'Waiting ${delayMs}ms before token refresh...',
        name: 'core.network.socket',
      );

      try {
        await Future.delayed(Duration(milliseconds: delayMs));

        // Check if socket is null (disposed) during delay
        if (_socket == null) return;

        final refreshed = await _tokenRefreshService.refreshToken();
        if (!refreshed) {
          LoggerService.debug(
            'Failed to refresh token after socket auth error. Disconnecting.',
            name: 'core.network.socket',
          );
          disconnect();
        }
        // NOTE: If refreshed is true, TokenRefreshService emits AuthEvent.tokenRefreshed,
        // which triggers reconnect() safely through the single-flight _reconnectCompleter.
      } catch (e) {
        LoggerService.error(
          'Error during token refresh after socket auth error',
          name: 'core.network.socket',
          error: e,
        );
        disconnect();
      } finally {
        _isHandlingAuthError = false;
      }
    }
  }

  @override
  Future<void> reconnect() async {
    // Coalesce concurrent reconnection attempts onto a single in-flight operation
    if (_reconnectCompleter != null) {
      await _reconnectCompleter!.future;
      return;
    }

    final completer = Completer<void>();
    _reconnectCompleter = completer;

    try {
      _destroyCurrentSocket();
      _notifyStatus(false);
      await connect();
    } finally {
      _reconnectCompleter = null;
      if (!completer.isCompleted) {
        completer.complete();
      }
    }
  }

  @override
  Future<bool> ensureConnected({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    // Proactively verify token validity
    final token = await _tokenRefreshService.getValidAccessToken();
    if (token == null || token.isEmpty) {
      disconnect();
      return false;
    }

    if (isConnected) {
      return true;
    }

    // Trigger connect and wait for connection or timeout
    final connectFuture = connect();

    final result = await Future.any<bool>([
      connectFuture.then((_) => isConnected),
      Future.delayed(timeout, () => isConnected),
    ]);

    return result;
  }

  @override
  void disconnect() {
    _authRetryCount = 0;
    _isHandlingAuthError = false;
    _connectionCompleter = null;
    _reconnectCompleter = null;
    if (_socket != null) {
      LoggerService.debug(
        'Disconnecting socket...',
        name: 'core.network.socket',
      );
      _destroyCurrentSocket();
      _notifyStatus(false);
    }
  }

  @override
  void emit(String event, [dynamic data]) {
    if (_socket != null && _socket!.connected) {
      LoggerService.debug(
        'Emitting event: $event with data: $data',
        name: 'core.network.socket',
      );
      _socket!.emit(event, data);
    } else {
      LoggerService.warning(
        'Cannot emit event $event. Socket is not connected (connected: $isConnected).',
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
  void off(String event, [void Function(dynamic data)? callback]) {
    if (callback != null) {
      final listeners = _eventListeners[event];
      if (listeners != null) {
        listeners.remove(callback);
        if (listeners.isEmpty) {
          _eventListeners.remove(event);
        }
      }
      _socket?.off(event, callback);
    } else {
      _eventListeners.remove(event);
      _socket?.off(event);
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _authSubscription = null;
    disconnect();
    _eventListeners.clear();
    _connectionStatusController.close();
  }
}

