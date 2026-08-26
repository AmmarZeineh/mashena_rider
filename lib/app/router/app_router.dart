import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/app/router/route_transitions.dart';
import 'package:mashena_rider/app/router/auth_session_cache.dart';
import 'package:mashena_rider/features/home/presentation/shell/views/home_view.dart';
import 'package:mashena_rider/features/home/presentation/address/views/pick_address_view.dart';
import 'package:mashena_rider/features/shared_trip/presentation/models/shared_trip_rooms_args.dart';
import 'package:mashena_rider/features/shared_trip/presentation/views/pick_shared_trip_address_view.dart';
import 'package:mashena_rider/features/shared_trip/presentation/views/shared_trip_room_details_view.dart';
import 'package:mashena_rider/features/shared_trip/presentation/views/shared_trip_rooms_view.dart';
import 'package:mashena_rider/features/onboarding/domain/usecases/get_onboarding_status_usecase.dart';
import 'package:mashena_rider/features/auth/presentation/views/login_view.dart';
import 'package:mashena_rider/features/auth/presentation/views/signup_view.dart';
import 'package:mashena_rider/features/auth/presentation/views/verification_view.dart';
import 'package:mashena_rider/features/home/presentation/address/views/pick_from_map_view.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:mashena_rider/features/splash/presentation/views/splash_view.dart';
import 'package:mashena_rider/features/notifications/presentation/views/notifications_view.dart';
import 'package:mashena_rider/features/home/presentation/common/models/confirmed_ride_flow_result.dart';
import 'package:mashena_rider/features/pool/presentation/models/pool_discovery_args.dart';
import 'package:mashena_rider/features/pool/presentation/views/pool_create_view.dart';
import 'package:mashena_rider/features/pool/presentation/views/pool_discovery_view.dart';
import 'package:mashena_rider/features/pool/presentation/views/pool_lobby_view.dart';
import 'package:mashena_rider/features/moderation/presentation/views/moderation_view.dart';
import 'package:mashena_rider/features/profile/presentation/views/profile_view.dart';
import 'package:mashena_rider/features/trip_history/presentation/views/trip_history_view.dart';
import 'package:mashena_rider/features/coupons/presentation/views/coupons_view.dart';

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

      final isAuthed = await getIt<AuthSessionCache>().isAuthenticated();

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
            child: PickAddressView(
              initialData: state.extra as ConfirmedRideFlowResult?,
            ),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.sharedTripPickAddressPath,
        name: AppRoutes.sharedTripPickAddress,
        pageBuilder: (context, state) {
          final extra = state.extra;
          return bottomSlidePage(
            key: state.pageKey,
            child: PickSharedTripAddressView(
              initialData: extra is ConfirmedRideFlowResult ? extra : null,
              initialLocations: extra is SharedTripRoomsArgs ? extra : null,
            ),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.sharedTripRoomsPath,
        name: AppRoutes.sharedTripRooms,
        builder: (context, state) {
          final args = state.extra as SharedTripRoomsArgs;
          return SharedTripRoomsView(args: args);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.sharedTripRoomDetailsPath,
        name: AppRoutes.sharedTripRoomDetails,
        builder: (context, state) {
          final roomId = state.extra as int;
          return SharedTripRoomDetailsView(roomId: roomId);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.poolDiscoveryPath,
        name: AppRoutes.poolDiscovery,
        builder: (context, state) {
          final args = state.extra as PoolDiscoveryArgs;
          return PoolDiscoveryView(args: args);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.poolCreatePath,
        name: AppRoutes.poolCreate,
        builder: (context, state) {
          final args = state.extra as PoolDiscoveryArgs;
          return PoolCreateView(args: args);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.poolLobbyPath,
        name: AppRoutes.poolLobby,
        builder: (context, state) {
          final roomId = state.extra as int;
          return PoolLobbyView(roomId: roomId);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.notificationsPath,
        name: AppRoutes.notifications,
        builder: (context, state) => const NotificationsView(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.moderationPath,
        name: AppRoutes.moderation,
        builder: (context, state) => const ModerationView(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.pickFromMapPath,
        name: AppRoutes.pickFromMap,
        builder: (context, state) {
          final initialLocation = state.extra as MapLatLng?;
          return PickFromMapView(
            initialLocation:
                initialLocation ??
                const MapLatLng(latitude: 33.5153, longitude: 36.2772),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.profilePath,
        name: AppRoutes.profile,
        builder: (context, state) => const ProfileView(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.tripHistoryPath,
        name: AppRoutes.tripHistory,
        builder: (context, state) => const TripHistoryView(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.couponsPath,
        name: AppRoutes.coupons,
        builder: (context, state) => const CouponsView(),
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
