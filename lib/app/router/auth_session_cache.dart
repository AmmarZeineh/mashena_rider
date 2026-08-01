import 'dart:async';

import 'package:mashena_rider/features/auth/domain/usecases/get_cached_session_usecase.dart';
import 'package:mashena_rider/features/auth/presentation/blocs/auth_cubit/auth_cubit.dart';

/// Caches the "is authenticated" check used by [AppRouter]'s redirect logic
/// to avoid hitting SharedPreferences on every single navigation.
/// Invalidated automatically whenever [AuthCubit] emits a new state
/// (covers explicit login/logout AND auto-logout via AuthEventBus).
class AuthSessionCache {
  AuthSessionCache(this._getCachedSession, AuthCubit authCubit) {
    _subscription = authCubit.stream.listen((_) => _cached = null);
  }

  final GetCachedSessionUsecase _getCachedSession;
  late final StreamSubscription<AuthState> _subscription;
  bool? _cached;

  Future<bool> isAuthenticated() async {
    if (_cached != null) return _cached!;
    final result = await _getCachedSession();
    _cached = result.isRight();
    return _cached!;
  }

  void dispose() => _subscription.cancel();
}
