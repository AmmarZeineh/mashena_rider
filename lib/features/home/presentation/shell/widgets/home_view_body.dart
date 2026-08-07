import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashena_rider/core/errors/failure.dart';
import 'package:mashena_rider/core/l10n/failure_localizer.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/home/presentation/booking/cubits/ride_booking_cubit/ride_booking_cubit.dart';
import 'package:mashena_rider/features/home/presentation/booking/widgets/ride_booking_overlay.dart';
import 'package:mashena_rider/features/home/presentation/shell/cubits/map_state_cubit/map_state_cubit.dart';
import 'package:mashena_rider/features/home/presentation/shell/widgets/home_menu_button.dart';
import 'package:mashena_rider/features/home/presentation/shell/widgets/home_view_google_maps_section.dart';
import 'package:mashena_rider/features/home/presentation/shell/widgets/set_destination_cta.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/trip_lifecycle_cubit/trip_lifecycle_cubit.dart';
import 'package:mashena_rider/features/home/presentation/trip/widgets/ride_confirmed_bottom_sheet.dart';
import 'package:mashena_rider/features/home/presentation/trip/widgets/trip_cancelled_bottom_sheet.dart';
import 'package:mashena_rider/features/home/presentation/trip/widgets/trip_rating_bottom_sheet.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  side: BorderSide(
                    color: AppColors.errorColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                elevation: 6,
                duration: const Duration(seconds: 4),
                content: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: AppColors.errorColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.error_outline_rounded,
                        color: AppColors.errorColor,
                        size: 20.r,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        failureText(context, state.error!),
                        style: AppTextStyles.w600_14.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        // Handle trip cancellation / ride expiry / lifecycle errors
        BlocListener<TripLifecycleCubit, TripLifecycleState>(
          listenWhen: (previous, current) =>
              (previous.tripError != current.tripError &&
                  current.tripError != null) ||
              (previous.isRideExpired != current.isRideExpired &&
                  current.isRideExpired),
          listener: (context, state) {
            if (state.isRideExpired) {
              // Dismiss any active modal bottom sheets or popup routes first
              Navigator.of(context).popUntil((route) => route is! PopupRoute);

              // Show ride expired bottom sheet
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (bottomSheetContext) =>
                    const TripCancelledBottomSheet(isExpired: true),
              );

              // Return HomeView to initial state
              context.read<RideBookingCubit>().clearBooking();
              context.read<TripLifecycleCubit>().reset();
              return;
            }

            final error = state.tripError!;
            final isCancellation =
                error.code == FailureCode.tripCancelledByDriver ||
                error.code == FailureCode.tripCancelledByAdmin ||
                error.code == FailureCode.tripCancelled ||
                state.tripCancelledData != null;

            final String? cancelledBy =
                state.tripCancelledData?.cancelledBy ??
                (error.code == FailureCode.tripCancelledByDriver
                    ? 'driver'
                    : error.code == FailureCode.tripCancelledByAdmin
                    ? 'admin'
                    : null);

            // Show edited modern floating SnackBar
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  side: BorderSide(
                    color: AppColors.errorColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                elevation: 6,
                duration: const Duration(seconds: 4),
                content: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: AppColors.errorColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.cancel_outlined,
                        color: AppColors.errorColor,
                        size: 20.r,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        failureText(context, error),
                        style: AppTextStyles.w600_14.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );

            if (isCancellation) {
              // Dismiss any active modal bottom sheets or popup routes first
              Navigator.of(context).popUntil((route) => route is! PopupRoute);

              // Show modern design bottom sheet
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (bottomSheetContext) =>
                    TripCancelledBottomSheet(cancelledBy: cancelledBy),
              );

              // Return HomeView to initial state
              context.read<RideBookingCubit>().clearBooking();
            }
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
