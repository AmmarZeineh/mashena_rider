import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/network/socket_client.dart';
import 'package:mashena_rider/core/network/token_manager.dart';
import 'package:mashena_rider/features/auth/presentation/blocs/auth_cubit/auth_cubit.dart';

import '../core/theme/app_theme.dart';
import 'router/app_router.dart';

import 'router/app_routes.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  late final AuthCubit _authCubit;
  Locale? _deviceLocale;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _authCubit = getIt<AuthCubit>()..appStarted();
    _updateDeviceLocale();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateDeviceLocale();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _handleAppResumed();
    }
  }

  void _handleAppResumed() async {
    final tokenManager = getIt<TokenManager>();
    final hasToken = await tokenManager.hasToken();
    if (hasToken) {
      final socketClient = getIt<SocketClient>();
      unawaited(socketClient.ensureConnected());
    }
  }

  void _updateDeviceLocale() {
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    if (_deviceLocale != deviceLocale) {
      setState(() {
        _deviceLocale = deviceLocale;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _authCubit,
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
          theme: AppTheme.light(_deviceLocale ?? Locale('en')),
          darkTheme: AppTheme.dark(_deviceLocale ?? Locale('en')),
          themeMode: ThemeMode.system,
          locale: _deviceLocale,
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
