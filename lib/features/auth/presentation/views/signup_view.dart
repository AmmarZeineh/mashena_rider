import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/features/auth/domain/usecases/signup_usecase.dart';
import 'package:mashena_rider/features/auth/presentation/blocs/signup_bloc/signup_bloc.dart';
import 'package:mashena_rider/features/auth/presentation/widgets/signup_view_body.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => SignupBloc(getIt.get<SignupUsecase>()),
          child: SignupViewBody(),
        ),
      ),
    );
  }
}
