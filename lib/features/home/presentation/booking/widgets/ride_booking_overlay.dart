import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate.dart';
import 'package:mashena_rider/features/home/presentation/booking/cubits/ride_booking_cubit/ride_booking_cubit.dart';
import 'package:mashena_rider/features/home/presentation/ride_flow/ride_flow_coordinator.dart';
import 'package:mashena_rider/features/home/presentation/booking/widgets/book_ride_button.dart';
import 'package:mashena_rider/features/home/presentation/booking/widgets/ride_list.dart';
import 'package:mashena_rider/features/home/presentation/booking/widgets/trip_stats_row.dart';
import 'package:mashena_rider/features/home/presentation/common/models/confirmed_ride_flow_result.dart';

class RideBookingOverlay extends StatefulWidget {
  const RideBookingOverlay({super.key, required this.rideResult});

  final ConfirmedRideFlowResult rideResult;

  @override
  State<RideBookingOverlay> createState() => _RideBookingOverlayState();
}

class _RideBookingOverlayState extends State<RideBookingOverlay> {
  late RideEstimate? _selected;

  @override
  void initState() {
    super.initState();
    final estimates = widget.rideResult.estimateResponse.estimates;
    _selected = estimates.isEmpty ? null : estimates.first;
  }

  void _select(RideEstimate estimate) {
    setState(() => _selected = estimate);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    final estimates = widget.rideResult.estimateResponse.estimates;

    return BlocBuilder<RideBookingCubit, RideBookingState>(
      builder: (context, state) {
        return Stack(
          children: [
            // Top floating card for Trip Stats and Edit Action
            Align(
              alignment: Alignment.topCenter,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
                  child: _TopEditCard(rideResult: widget.rideResult),
                ),
              ),
            ),
            // Bottom section for horizontal car list and book button
            Align(
              alignment: Alignment.bottomCenter,
              child: _BottomCarSelection(
                estimates: estimates,
                selected: _selected,
                onSelect: _select,
                emptyLabel: localizations.rideNoTypesAvailable,
                bookLabel: localizations.rideBookRide,
                isLoading: state.isSubmitting,
                onBookPressed: () {
                  if (_selected != null) {
                    context.read<RideBookingCubit>().submitRideSelection(
                      _selected!.vehicleTypeId,
                    );
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TopEditCard extends StatelessWidget {
  const _TopEditCard({required this.rideResult});

  final ConfirmedRideFlowResult rideResult;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          Expanded(child: TripStatsRow(response: rideResult.estimateResponse)),
          SizedBox(width: 8.w),
          _CircularAction(
            icon: Icons.edit_location_alt_rounded,
            color: colorScheme.primary,
            onPressed: () => RideFlowCoordinator.openPickAddressAndDrawRoute(
              context,
              initialResult: rideResult,
            ),
          ),
          SizedBox(width: 8.w),
          _CircularAction(
            icon: Icons.close_rounded,
            color: colorScheme.error,
            onPressed: () => context.read<RideBookingCubit>().clearBooking(),
          ),
        ],
      ),
    );
  }
}

class _CircularAction extends StatelessWidget {
  const _CircularAction({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: 20.sp),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

class _BottomCarSelection extends StatelessWidget {
  const _BottomCarSelection({
    required this.estimates,
    required this.selected,
    required this.onSelect,
    required this.emptyLabel,
    required this.bookLabel,
    this.onBookPressed,
    this.isLoading = false,
  });

  final List<RideEstimate> estimates;
  final RideEstimate? selected;
  final ValueChanged<RideEstimate> onSelect;
  final String emptyLabel;
  final String bookLabel;
  final VoidCallback? onBookPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
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
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
            child: Text(
              'Select Vehicle',
              style: AppTextStyles.w800_16.copyWith(
                fontSize: 20.sp,
                letterSpacing: -0.5,
              ),
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: RideList(
              estimates: estimates,
              selected: selected,
              onSelect: onSelect,
              emptyLabel: emptyLabel,
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: BookRideButton(
              selected: selected,
              label: bookLabel,
              onPressed: onBookPressed,
              isLoading: isLoading,
            ),
          ),
        ],
      ),
    );
  }
}
