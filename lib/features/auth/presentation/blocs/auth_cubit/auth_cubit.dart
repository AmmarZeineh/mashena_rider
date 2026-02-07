import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mashena_rider/features/auth/domain/entities/auth_session.dart';
import 'package:mashena_rider/features/auth/domain/usecases/get_cached_session_usecase.dart';
import 'package:mashena_rider/features/auth/domain/usecases/logout_usecase.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._getCached, this._logout) : super(const AuthState.initial());

  final GetCachedSessionUsecase _getCached;
  final LogoutUsecase _logout;

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

  Future<void> signOut() async {
    await _logout();
    emit(const AuthState.unauthenticated());
  }
}
