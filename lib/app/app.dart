import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/features/auth/presentation/blocs/auth_cubit/auth_cubit.dart';

import '../core/theme/app_theme.dart';
import 'router/app_router.dart';

import 'router/app_routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;

    return BlocProvider(
      create: (_) => getIt<AuthCubit>()..appStarted(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          state.maybeWhen(
            unauthenticated: () {
              AppRouter.router.goNamed(AppRoutes.login);
            },
            orElse: () {},
          );
        },
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(deviceLocale),
          darkTheme: AppTheme.dark(deviceLocale),
          themeMode: ThemeMode.system,
          locale: deviceLocale,
          routerConfig: AppRouter.router,
          supportedLocales: const [Locale('en'), Locale('ar')],
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ),
      ),
    );
  }
}
