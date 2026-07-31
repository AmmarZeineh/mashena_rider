import 'package:bloc/bloc.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/auth/domain/entities/auth_session.dart';
import 'package:mashena_rider/core/services/notification_service.dart';
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

    final token = await NotificationService.getFcmToken();

    final result = await _login(
      email: event.email,
      password: event.password,
      fcmToken: token,
    );

    result.fold(
      (failure) => emit(LoginFailure(failure)),
      (session) => emit(LoginSuccess(session)),
    );
  }
}
