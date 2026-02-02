import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/auth/domain/usecases/signup_usecase.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc(this._signup) : super(SignupInitial()) {
    on<SignupSubmitted>(_onSubmit);
  }

  final SignupUsecase _signup;

  Future<void> _onSubmit(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupLoading());

    final result = await _signup(
      email: event.email,
      password: event.password,
      fullName: event.fullName,
      phoneNumber: event.phoneNumber,
      channel: 'email',
    );

    result.fold(
      (failure) => emit(SignupFailure(failure)),
      (otp) => emit(SignupSuccess()),
    );
  }
}
