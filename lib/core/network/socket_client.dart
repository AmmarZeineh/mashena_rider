import 'dart:async';

/// An abstract interface class that defines the contracts for real-time
/// socket communication across the application.
abstract interface class SocketClient {
  /// Connects to the socket server.
  Future<void> connect();

  /// Disconnects from the socket server.
  void disconnect();

  /// Disposes of any resources/streams managed by this client.
  void dispose();

  /// Returns whether the socket is currently connected.
  bool get isConnected;

  /// A stream of the connection state updates.
  Stream<bool> get connectionStatusStream;

  /// Emits an event with optional data payload to the server.
  void emit(String event, [dynamic data]);

  /// Registers a callback for incoming events from the server.
  void on(String event, void Function(dynamic data) callback);

  /// Unregisters/removes the callback registered for the given event.
  void off(String event);
}
