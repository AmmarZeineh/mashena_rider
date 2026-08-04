import 'dart:async';
import 'package:mashena_rider/core/services/logger_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

import 'package:mashena_rider/app/config/app_config.dart';
import 'package:mashena_rider/core/network/token_manager.dart';
import 'socket_client.dart';

/// Concrete implementation of [SocketClient] using the `socket_io_client` package.
class SocketIOClientImpl implements SocketClient {
  final AppConfig _config;
  final TokenManager _tokenManager;

  socket_io.Socket? _socket;
  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();
  final Map<String, Set<void Function(dynamic)>> _eventListeners = {};

  SocketIOClientImpl(this._config, this._tokenManager);

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

    final token = await _tokenManager.getAccessToken();
    if (token == null || token.isEmpty) {
      LoggerService.debug(
        'Socket connection failed: No access token found.',
        name: 'core.network.socket',
      );
      _connectionStatusController.add(false);
      return;
    }

    LoggerService.debug(
      'Socket connecting with token (present: true)',
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
        LoggerService.debug('Socket connected successfully', name: 'core.network.socket');
        _connectionStatusController.add(true);
      });

      _socket!.onReconnect((_) {
        LoggerService.debug('Socket reconnected successfully', name: 'core.network.socket');
        _connectionStatusController.add(true);
        _eventListeners.forEach((event, listeners) {
          for (final callback in listeners) {
            _socket?.off(event, callback);
            _socket?.on(event, callback);
          }
        });
      });

      _socket!.onDisconnect((data) {
        LoggerService.debug('Socket disconnected: $data', name: 'core.network.socket');
        _connectionStatusController.add(false);
      });

      _socket!.onConnectError((err) {
        LoggerService.debug('Socket connection error: $err', name: 'core.network.socket');
        _connectionStatusController.add(false);
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

  @override
  void disconnect() {
    if (_socket != null) {
      LoggerService.debug('Disconnecting socket...', name: 'core.network.socket');
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
