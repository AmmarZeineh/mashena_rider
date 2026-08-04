import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/features/auth/domain/usecases/login_usecase.dart';
import 'package:mashena_rider/features/auth/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:mashena_rider/core/services/fcm_token_provider.dart';
import 'package:mashena_rider/features/auth/presentation/widgets/login_view_body.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocProvider(
        create: (context) => LoginBloc(
          getIt.get<LoginUsecase>(),
          const NotificationServiceFcmProvider(),
        ),
        child: LoginViewBody(),
      ),
    );
  }
}
