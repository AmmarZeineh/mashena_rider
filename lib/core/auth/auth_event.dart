import 'dart:async';

import 'package:mashena_rider/core/auth/auth_event_bus.dart';

class AuthEventBus {
  final _controller = StreamController<AuthEvent>.broadcast();

  Stream<AuthEvent> get stream => _controller.stream;

  void emit(AuthEvent event) {
    _controller.add(event);
  }

  void dispose() {
    _controller.close();
  }
}
