import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/features/home/presentation/cubits/home_location_cubit/home_location_cubit.dart';
import 'package:mashena_rider/features/home/presentation/widgets/home_menu_button.dart';
import 'package:mashena_rider/features/home/presentation/widgets/ride_booking_overlay.dart';
import 'package:mashena_rider/features/home/presentation/widgets/home_view_google_maps_section.dart';
import 'package:mashena_rider/features/home/presentation/widgets/set_destination_cta.dart';
import 'package:mashena_rider/features/home/presentation/widgets/ride_confirmed_bottom_sheet.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
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
                  final offsetAnimation = Tween<Offset>(
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
    );
  }
}
