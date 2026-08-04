import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/features/auth/domain/usecases/verify_otp_usecase.dart';

part 'verify_otp_event.dart';
part 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  VerifyOtpBloc(this._verifyOtp) : super(VerifyOtpInitial()) {
    on<VerifyOtpSubmitted>(_onSubmit);
  }

  final VerifyOtpUsecase _verifyOtp;

  Future<void> _onSubmit(
    VerifyOtpSubmitted event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(VerifyOtpLoading());

    final result = await _verifyOtp(
      email: event.email,
      phone: event.phoneNumber,
      channel: 'email',
      code: event.code,
    );

    result.fold(
      (failure) => emit(VerifyOtpFailure(failure)),
      (otp) => emit(VerifyOtpSuccess()),
    );
  }
}
