import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/core/auth/auth_event.dart';
import 'package:mashena_rider/features/home/domain/repositories/ride_repository.dart';
import 'package:mashena_rider/features/home/presentation/booking/cubits/ride_booking_cubit/ride_booking_cubit.dart';
import 'package:mashena_rider/features/home/presentation/shell/cubits/home_cubit/home_cubit.dart';
import 'package:mashena_rider/features/home/presentation/shell/cubits/location_cubit/location_cubit.dart';
import 'package:mashena_rider/features/home/presentation/shell/cubits/map_state_cubit/map_state_cubit.dart';
import 'package:mashena_rider/features/home/presentation/shell/widgets/home_drawer.dart';
import 'package:mashena_rider/features/home/presentation/shell/widgets/home_view_body.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/driver_tracking_cubit/driver_tracking_cubit.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/trip_lifecycle_cubit/trip_lifecycle_cubit.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/trip_rating_cubit.dart';
import 'package:mashena_rider/core/services/location_service.dart';
import 'package:mashena_rider/core/services/osrm_route_service.dart';
import 'package:mashena_rider/features/home/domain/usecases/cancel_ride_usecase.dart';
import 'package:mashena_rider/features/home/domain/usecases/submit_ride_request_usecase.dart';
import 'package:mashena_rider/features/home/domain/repositories/rating_repository.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final MapStateCubit mapStateCubit;
  late final LocationCubit locationCubit;
  late final TripLifecycleCubit tripLifecycleCubit;
  late final DriverTrackingCubit driverTrackingCubit;
  late final RideBookingCubit rideBookingCubit;
  late final TripRatingCubit tripRatingCubit;
  late final HomeCubit homeCubit;

  @override
  void initState() {
    super.initState();
    // Build shared instances manually to guarantee the same object
    // is shared between cubits that need to talk to each other.
    mapStateCubit = MapStateCubit();
    locationCubit = LocationCubit(getIt<LocationService>());
    tripLifecycleCubit = TripLifecycleCubit(
      getIt<RideRepository>(),
      getIt<AuthEventBus>(),
    );
    driverTrackingCubit = DriverTrackingCubit(
      getIt<RideRepository>(),
      getIt<OSRMRouteService>(),
      mapStateCubit,
    );
    rideBookingCubit = RideBookingCubit(
      getIt<SubmitRideRequestUsecase>(),
      getIt<CancelRideUsecase>(),
      getIt<RideRepository>(),
      tripLifecycleCubit,
      driverTrackingCubit,
      mapStateCubit,
    );
    tripRatingCubit = TripRatingCubit(getIt<RatingRepository>());
    homeCubit = HomeCubit(getIt<RideRepository>(), locationCubit)..init();
  }

  @override
  void dispose() {
    mapStateCubit.close();
    locationCubit.close();
    tripLifecycleCubit.close();
    driverTrackingCubit.close();
    rideBookingCubit.close();
    tripRatingCubit.close();
    homeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: locationCubit),
          BlocProvider.value(value: mapStateCubit),
          BlocProvider.value(value: tripLifecycleCubit),
          BlocProvider.value(value: driverTrackingCubit),
          BlocProvider.value(value: rideBookingCubit),
          BlocProvider.value(value: tripRatingCubit),
          BlocProvider.value(value: homeCubit),
        ],
        child: const HomeViewBody(),
      ),
    );
  }
}

