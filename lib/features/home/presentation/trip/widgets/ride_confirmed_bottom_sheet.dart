import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_submission_response.dart';
import 'package:mashena_rider/features/home/presentation/shell/cubits/home_cubit/home_cubit.dart';
import 'package:mashena_rider/features/home/presentation/common/models/confirmed_ride_flow_result.dart';
import 'package:mashena_rider/features/home/presentation/common/widgets/custom_drag_handle.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';

import 'ride_confirmed_sheet_components/cancel_ride_button.dart';
import 'ride_confirmed_sheet_components/confirmed_badge.dart';
import 'ride_confirmed_sheet_components/driver_card.dart';
import 'ride_confirmed_sheet_components/trip_details.dart';

class RideConfirmedBottomSheet extends StatelessWidget {
  const RideConfirmedBottomSheet({
    super.key,
    required this.rideResult,
    required this.submissionResponse,
  });

  final ConfirmedRideFlowResult rideResult;
  final RideSubmissionResponse submissionResponse;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 30,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 12.h),
            const CustomDragHandle(),
            SizedBox(height: 16.h),

            // Confirmed Status Badge
            const Center(child: ConfirmedBadge()),

            SizedBox(height: 24.h),

            // Simulated Driver Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: const DriverCard(),
            ),

            SizedBox(height: 24.h),

            // Trip Details
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: TripDetails(submissionResponse: submissionResponse),
            ),

            SizedBox(height: 32.h),

            // Cancel Button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
              ).copyWith(bottom: MediaQuery.of(context).padding.bottom + 16.h),
              child: CancelRideButton(
                onPressed: () {
                  context.read<HomeCubit>().clearRideFlow();
                },
                label: S.of(context).rideCancelRide,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
