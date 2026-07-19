import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/features/home/presentation/shell/cubits/home_cubit/home_cubit.dart';
import 'package:mashena_rider/features/home/presentation/shell/widgets/home_menu_button.dart';
import 'package:mashena_rider/features/home/presentation/booking/widgets/ride_booking_overlay.dart';
import 'package:mashena_rider/features/home/presentation/shell/widgets/home_view_google_maps_section.dart';
import 'package:mashena_rider/features/home/presentation/shell/widgets/set_destination_cta.dart';
import 'package:mashena_rider/features/home/presentation/trip/widgets/ride_confirmed_bottom_sheet.dart';
import 'package:mashena_rider/features/home/presentation/trip/widgets/trip_rating_bottom_sheet.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) =>
          previous.bookingErrorMessage != current.bookingErrorMessage &&
          current.bookingErrorMessage != null,
      listener: (context, state) {
        final error = state.bookingErrorMessage!;
        final s = S.of(context);
        String displayError = error;
        if (error == 'tripCancelledByDriver') {
          displayError = s.tripCancelledByDriver;
        } else if (error == 'tripCancelledByAdmin') {
          displayError = s.tripCancelledByAdmin;
        } else if (error == 'tripCancelled') {
          displayError = s.tripCancelled;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(displayError)),
        );
      },
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final rideResult = state.confirmedRideResult;
        return ModalProgressHUD(
          inAsyncCall: state.isFetchingRoute,
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
                    : state.isTripEnded && state.submissionResponse != null
                        ? TripRatingBottomSheet(
                            key: const ValueKey('rating'),
                            rideResult: rideResult,
                            submissionResponse: state.submissionResponse!,
                            tripCompletedData: state.tripCompletedData,
                          )
                        : state.rideSubmittedSuccessfully &&
                              state.submissionResponse != null
                        ? RideConfirmedBottomSheet(
                            key: const ValueKey('confirmed'),
                            rideResult: rideResult,
                            submissionResponse: state.submissionResponse!,
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
    ),
  );
}
}
