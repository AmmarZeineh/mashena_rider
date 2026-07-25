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

class RideConfirmedBottomSheet extends StatefulWidget {
  const RideConfirmedBottomSheet({
    super.key,
    required this.rideResult,
    required this.submissionResponse,
  });

  final ConfirmedRideFlowResult rideResult;
  final RideSubmissionResponse submissionResponse;

  @override
  State<RideConfirmedBottomSheet> createState() =>
      _RideConfirmedBottomSheetState();
}

class _RideConfirmedBottomSheetState extends State<RideConfirmedBottomSheet> {
  bool _isMinimized = false;

  void _handleVerticalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity != null) {
      if (details.primaryVelocity! > 300) {
        // Swiped down
        if (!_isMinimized) {
          setState(() => _isMinimized = true);
        }
      } else if (details.primaryVelocity! < -300) {
        // Swiped up
        if (_isMinimized) {
          setState(() => _isMinimized = false);
        }
      }
    }
  }

  void _handleTap() {
    if (_isMinimized) {
      setState(() => _isMinimized = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final homeState = context.watch<HomeCubit>().state;
    final isDriverArrived =
        homeState.isDriverArrived || homeState.isTripStarted;

    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onVerticalDragEnd: _handleVerticalDragEnd,
        onTap: _handleTap,
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
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 12.h),
                const CustomDragHandle(),
                SizedBox(height: 16.h),

                // Confirmed Status Badge
                const Center(child: ConfirmedBadge()),

                if (!_isMinimized) ...[
                  SizedBox(height: 24.h),

                  // Simulated Driver Card
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: const DriverCard(),
                  ),

                  if (!isDriverArrived) ...[
                    SizedBox(height: 24.h),

                    // Trip Details
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: TripDetails(
                        submissionResponse: widget.submissionResponse,
                      ),
                    ),
                  ],

                  SizedBox(height: 32.h),

                  // Cancel Button
                  if (!homeState.isTripStarted)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(
                        bottom: MediaQuery.of(context).padding.bottom + 16.h,
                      ),
                      child: Column(
                        children: [
                          CancelRideButton(
                            onPressed: () {
                              context.read<HomeCubit>().cancelRide();
                            },
                            label: S.of(context).rideCancelRide,
                          ),
                        ],
                      ),
                    ),
                ] else ...[
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom + 16.h,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
