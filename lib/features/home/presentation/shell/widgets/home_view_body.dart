import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/core/l10n/failure_localizer.dart';
import 'package:mashena_rider/features/home/presentation/booking/cubits/ride_booking_cubit/ride_booking_cubit.dart';
import 'package:mashena_rider/features/home/presentation/shell/cubits/map_state_cubit/map_state_cubit.dart';
import 'package:mashena_rider/features/home/presentation/shell/widgets/home_menu_button.dart';
import 'package:mashena_rider/features/home/presentation/booking/widgets/ride_booking_overlay.dart';
import 'package:mashena_rider/features/home/presentation/shell/widgets/home_view_google_maps_section.dart';
import 'package:mashena_rider/features/home/presentation/shell/widgets/set_destination_cta.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/trip_lifecycle_cubit/trip_lifecycle_cubit.dart';
import 'package:mashena_rider/features/home/presentation/trip/widgets/ride_confirmed_bottom_sheet.dart';
import 'package:mashena_rider/features/home/presentation/trip/widgets/trip_rating_bottom_sheet.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Show snack bar on booking errors (cancel/submit failures)
        BlocListener<RideBookingCubit, RideBookingState>(
          listenWhen: (previous, current) =>
              previous.error != current.error && current.error != null,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(failureText(context, state.error!)),
              ),
            );
          },
        ),
        // Show snack bar on trip cancellation / lifecycle errors
        BlocListener<TripLifecycleCubit, TripLifecycleState>(
          listenWhen: (previous, current) =>
              previous.tripError != current.tripError &&
              current.tripError != null,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(failureText(context, state.tripError!)),
              ),
            );
          },
        ),
      ],
      child: BlocBuilder<MapStateCubit, MapStateState>(
        buildWhen: (p, c) => p.isFetchingRoute != c.isFetchingRoute,
        builder: (context, mapState) {
          return BlocBuilder<RideBookingCubit, RideBookingState>(
            builder: (context, bookingState) {
              final rideResult = bookingState.confirmedRideResult;
              final submissionResponse = bookingState.submissionResponse;

              return BlocBuilder<TripLifecycleCubit, TripLifecycleState>(
                builder: (context, tripState) {
                  return ModalProgressHUD(
                    inAsyncCall: mapState.isFetchingRoute,
                    opacity: 0.2,
                    progressIndicator: const CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                    child: Stack(
                      children: [
                        const HomeViewGoogleMapsSection(),
                        const HomeMenuButton(),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) {
                            final offsetAnimation =
                                Tween<Offset>(
                                  begin: const Offset(0, 1),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOutCubic,
                                  ),
                                );
                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                          child: rideResult == null
                              ? const Align(
                                  key: ValueKey('cta'),
                                  alignment: Alignment.bottomCenter,
                                  child: SetDestinationCta(),
                                )
                              : tripState.isTripEnded &&
                                    submissionResponse != null
                                  ? TripRatingBottomSheet(
                                      key: const ValueKey('rating'),
                                      rideResult: rideResult,
                                      submissionResponse: submissionResponse,
                                      tripCompletedData:
                                          tripState.tripCompletedData,
                                    )
                                  : bookingState.isSubmitted &&
                                        submissionResponse != null
                                      ? RideConfirmedBottomSheet(
                                          key: const ValueKey('confirmed'),
                                          rideResult: rideResult,
                                          submissionResponse: submissionResponse,
                                        )
                                      : RideBookingOverlay(
                                          key: const ValueKey('sheet'),
                                          rideResult: rideResult,
                                        ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
