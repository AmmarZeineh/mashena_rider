import 'dart:async';
import 'dart:developer' as developer;
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
      developer.log(
        'Socket connection failed: No access token found.',
        name: 'core.network.socket',
      );
      _connectionStatusController.add(false);
      return;
    }

    // Clean up existing socket before creating a new one
    if (_socket != null) {
      _socket!.destroy();
      _socket = null;
    }

    developer.log(
      'Connecting to socket server: ${_config.socketUrl}',
      name: 'core.network.socket',
    );

    try {
      _socket = socket_io.io(
        _config.socketUrl,
        socket_io.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            // Pass token in auth object (NestJS Gateway expects auth.token or auth.accessToken)
            .setAuth({'token': token})
            .build(),
      );

      // Register connection status callbacks
      _socket!.onConnect((_) {
        developer.log('Socket connected successfully', name: 'core.network.socket');
        _connectionStatusController.add(true);
      });

      _socket!.onDisconnect((data) {
        developer.log('Socket disconnected: $data', name: 'core.network.socket');
        _connectionStatusController.add(false);
      });

      _socket!.onConnectError((err) {
        developer.log('Socket connection error: $err', name: 'core.network.socket');
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
      developer.log(
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
      developer.log('Disconnecting socket...', name: 'core.network.socket');
      _socket!.disconnect();
      _socket!.destroy();
      _socket = null;
      _connectionStatusController.add(false);
    }
  }

  @override
  void emit(String event, [dynamic data]) {
    if (_socket != null) {
      developer.log(
        'Emitting event: $event with data: $data',
        name: 'core.network.socket',
      );
      _socket!.emit(event, data);
    } else {
      developer.log(
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
