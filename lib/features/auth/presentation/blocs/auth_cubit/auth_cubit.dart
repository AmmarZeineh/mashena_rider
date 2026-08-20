import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mashena_rider/core/auth/auth_event.dart';
import 'package:mashena_rider/core/auth/auth_event_bus.dart';
import 'package:mashena_rider/features/auth/domain/entities/auth_session.dart';
import 'package:mashena_rider/features/auth/domain/usecases/get_cached_session_usecase.dart';
import 'package:mashena_rider/features/auth/domain/usecases/logout_usecase.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._getCached, this._logout, this._authEventBus)
    : super(const AuthState.initial()) {
    _subscription = _authEventBus.stream.listen((event) {
      if (event == AuthEvent.loggedOut) {
        emit(const AuthState.unauthenticated());
      }
    });
  }

  final GetCachedSessionUsecase _getCached;
  final LogoutUsecase _logout;
  final AuthEventBus _authEventBus;
  late final StreamSubscription<AuthEvent> _subscription;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  Future<void> appStarted() async {
    final res = await _getCached();
    res.fold(
      (_) => emit(const AuthState.unauthenticated()),
      (session) => emit(AuthState.authenticated(session)),
    );
  }

  void setSession(AuthSession session) {
    emit(AuthState.authenticated(session));
  }

  Future<void> signOut({bool allDevices = false}) async {
    await _logout(allDevices: allDevices);
    emit(const AuthState.unauthenticated());
  }
}
