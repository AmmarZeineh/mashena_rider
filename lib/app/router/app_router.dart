import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/app/router/route_transitions.dart';
import 'package:mashena_rider/features/auth/domain/usecases/get_cached_session_usecase.dart';
import 'package:mashena_rider/features/home/presentation/views/home_view.dart';
import 'package:mashena_rider/features/home/presentation/views/pick_address_view.dart';
import 'package:mashena_rider/features/onboarding/domain/usecases/get_onboarding_status_usecase.dart';
import 'package:mashena_rider/features/auth/presentation/views/login_view.dart';
import 'package:mashena_rider/features/auth/presentation/views/signup_view.dart';
import 'package:mashena_rider/features/auth/presentation/views/verification_view.dart';
import 'package:mashena_rider/features/home/presentation/views/pick_from_map_view.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:mashena_rider/features/splash/presentation/views/splash_view.dart';

final class AppRouter {
  const AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    redirect: (context, state) async {
      final loc = state.matchedLocation;

      final onboardingSeen = getIt<GetOnboardingStatus>()();
      if (!onboardingSeen) {
        return loc == AppRoutes.onboardingPath
            ? null
            : AppRoutes.onboardingPath;
      }

      if (loc == AppRoutes.onboardingPath) return AppRoutes.loginPath;

      final cached = await getIt<GetCachedSessionUsecase>()();
      final isAuthed = cached.isRight();

      final isAuthRoute =
          loc == AppRoutes.loginPath ||
          loc == AppRoutes.signupPath ||
          loc == AppRoutes.verificationPath;

      if (!isAuthed && !isAuthRoute) return AppRoutes.loginPath;
      if (isAuthed && isAuthRoute) return AppRoutes.homePath;

      return null;
    },

    initialLocation: AppRoutes.splashPath,
    routes: <RouteBase>[
      GoRoute(path: '/', builder: (context, state) => const _RootPage()),
      GoRoute(
        path: AppRoutes.splashPath,
        name: AppRoutes.splash,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: AppRoutes.onboardingPath,
        name: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: AppRoutes.loginPath,
        name: AppRoutes.login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: AppRoutes.signupPath,
        name: AppRoutes.signup,
        builder: (context, state) => const SignupView(),
      ),

      GoRoute(
        path: AppRoutes.verificationPath,
        name: AppRoutes.verification,
        builder: (context, state) => const VerificationView(),
      ),

      GoRoute(
        path: AppRoutes.homePath,
        name: AppRoutes.home,
        builder: (context, state) => const HomeView(),
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.pickAdressPath,
        name: AppRoutes.pickAdress,
        pageBuilder: (context, state) {
          return bottomSlidePage(
            key: state.pageKey,
            child: const PickAddressView(),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.pickFromMapPath,
        name: AppRoutes.pickFromMap,
        builder: (context, state) {
          final initialLocation = state.extra as MapLatLng?;
          return PickFromMapView(
            initialLocation: initialLocation ?? const MapLatLng(latitude: 33.5153, longitude: 36.2772),
          );
        },
      ),
    ],
    errorBuilder: (context, state) => _ErrorPage(error: state.error),
  );
}

class _RootPage extends StatelessWidget {
  const _RootPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Root')));
  }
}

class _ErrorPage extends StatelessWidget {
  const _ErrorPage({required this.error});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(error?.toString() ?? 'Router error')),
    );
  }
}
