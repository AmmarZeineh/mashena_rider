import 'package:bloc/bloc.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/auth/domain/usecases/login_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._login) : super(LoginInitial()) {
    on<LoginSubmitted>(_onSubmit);
  }

  final LoginUsecase _login;

  Future<void> _onSubmit(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    final result = await _login(
      email: event.email,
      password: event.password,
      fcmToken: event.fcmToken,
    );

    result.fold(
      (failure) => emit(LoginFailure(failure)),
      (_) => emit(LoginSuccess()),
    );
  }
}
