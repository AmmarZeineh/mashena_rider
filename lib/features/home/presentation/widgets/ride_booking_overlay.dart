import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate.dart';
import 'package:mashena_rider/features/home/presentation/cubits/home_location_cubit/home_location_cubit.dart';
import 'package:mashena_rider/features/home/presentation/utils/ride_flow_helper.dart';
import 'package:mashena_rider/features/home/presentation/widgets/book_ride_button.dart';
import 'package:mashena_rider/features/home/presentation/widgets/ride_list.dart';
import 'package:mashena_rider/features/home/presentation/widgets/trip_stats_row.dart';
import 'package:mashena_rider/features/home/presentation/models/confirmed_ride_flow_result.dart';

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

    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.rideSubmittedSuccessfully) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ride booked successfully!')),
          );
          // Handle navigation or flow cleanup if needed
        }
        if (state.bookingErrorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.bookingErrorMessage!)),
          );
        }
      },
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
                isLoading: state.isSubmittingRide,
                onBookPressed: () {
                  if (_selected != null) {
                    context.read<HomeCubit>().submitRideSelection(
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

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(16.r),
      color: colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Expanded(child: TripStatsRow(response: rideResult.estimateResponse)),
            SizedBox(width: 12.w),
            Container(
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () => RideFlowHelper.openPickAddressAndDrawRoute(
                  context,
                  initialResult: rideResult,
                ),
                icon: Icon(Icons.edit, color: colorScheme.onPrimaryContainer),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  context.read<HomeCubit>().clearRideFlow();
                },
                icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          RideList(
            estimates: estimates,
            selected: selected,
            onSelect: onSelect,
            emptyLabel: emptyLabel,
          ),
          const SizedBox(height: 16),
          BookRideButton(
            selected: selected,
            label: bookLabel,
            onPressed: onBookPressed,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
