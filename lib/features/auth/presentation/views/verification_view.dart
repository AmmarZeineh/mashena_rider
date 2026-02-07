import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:mashena_rider/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:mashena_rider/features/auth/presentation/blocs/verify_otp_bloc/verify_otp_bloc.dart';
import 'package:mashena_rider/features/auth/presentation/widgets/verification_view_body.dart';

class VerificationView extends StatelessWidget {
  const VerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => VerifyOtpBloc(getIt<VerifyOtpUsecase>()),
          child: VerificationViewBody(
            resendOtp: getIt<ResendOtpUsecase>(),
          ),
        ),
      ),
    );
  }
}
