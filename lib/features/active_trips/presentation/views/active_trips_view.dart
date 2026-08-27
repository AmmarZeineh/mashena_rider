import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/l10n/failure_localizer.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import '../../domain/entities/active_trip_context.dart';
import '../cubits/active_trips_cubit.dart';
import '../cubits/active_trips_state.dart';
import '../widgets/active_trip_card.dart';
import '../widgets/active_trips_empty_view.dart';

class ActiveTripsView extends StatelessWidget {
  const ActiveTripsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ActiveTripsCubit>()..fetchActiveTrips(),
      child: const _ActiveTripsScaffold(),
    );
  }
}

class _ActiveTripsScaffold extends StatelessWidget {
  const _ActiveTripsScaffold();

  void _onTripTapped(BuildContext context, ActiveTripContext trip) {
    if (trip.isRegularTrip) {
      // Regular trip: Navigate back to HomeView to resume live tracking
      context.go(AppRoutes.homePath);
    } else if (trip.isSharedRide) {
      // Shared Ride / Companion Booking: Open SharedTripRoomDetailsView
      final roomId = trip.sharedRideId ?? trip.tripId;
      if (roomId != null) {
        context.push(AppRoutes.sharedTripRoomDetailsPath, extra: roomId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          s.activeTripsTitle,
          style: AppTextStyles.w600_18.copyWith(color: colorScheme.onSurface),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: s.commonRetry,
            onPressed: () => context.read<ActiveTripsCubit>().refresh(),
          ),
        ],
      ),
      body: BlocBuilder<ActiveTripsCubit, ActiveTripsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ActiveTripsStatus.failure && !state.hasActiveTrips) {
            final failure = state.failure;
            final errorText = failure != null
                ? failureText(context, failure)
                : s.commonError;

            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 48.r,
                      color: colorScheme.error,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      errorText,
                      style: AppTextStyles.w500_14.copyWith(
                        color: colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    FilledButton.icon(
                      onPressed: () =>
                          context.read<ActiveTripsCubit>().fetchActiveTrips(),
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(s.commonRetry),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state.trips.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => context.read<ActiveTripsCubit>().refresh(),
              color: AppColors.primaryColor,
              child: ActiveTripsEmptyView(
                onRefresh: () => context.read<ActiveTripsCubit>().refresh(),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<ActiveTripsCubit>().refresh(),
            color: AppColors.primaryColor,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
              itemCount: state.trips.length,
              itemBuilder: (context, index) {
                final trip = state.trips[index];
                return ActiveTripCard(
                  key: ValueKey('${trip.type}_${trip.tripId}_${trip.sharedRideId}_$index'),
                  trip: trip,
                  onTap: (selectedTrip) =>
                      _onTripTapped(context, selectedTrip),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
