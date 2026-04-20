import 'package:flutter/material.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate_response.dart';
import 'package:mashena_rider/features/home/presentation/widgets/book_ride_button.dart';
import 'package:mashena_rider/features/home/presentation/widgets/ride_list.dart';
import 'package:mashena_rider/features/home/presentation/widgets/trip_stats_row.dart';

/// Shows a modal bottom sheet allowing the user to select a car type.
///
/// Returns the chosen [RideEstimate] when the user taps "Book Ride".
class CarTypeBottomSheet extends StatefulWidget {
  const CarTypeBottomSheet({super.key, required this.estimateResponse});

  final RideEstimateResponse estimateResponse;

  @override
  State<CarTypeBottomSheet> createState() => _CarTypeBottomSheetState();
}

class _CarTypeBottomSheetState extends State<CarTypeBottomSheet> {
  late RideEstimate? _selected;

  @override
  void initState() {
    super.initState();
    final estimates = widget.estimateResponse.estimates;
    _selected = estimates.isEmpty ? null : estimates.first;
  }

  void _select(RideEstimate estimate) {
    setState(() => _selected = estimate);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final estimates = widget.estimateResponse.estimates;
    final localizations = S.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _DragHandle(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.rideAvailableRides,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                TripStatsRow(response: widget.estimateResponse),
              ],
            ),
          ),
          const SizedBox(height: 16),
          RideList(
            estimates: estimates,
            selected: _selected,
            onSelect: _select,
            emptyLabel: localizations.rideNoTypesAvailable,
          ),
          const SizedBox(height: 12),
          BookRideButton(
            selected: _selected,
            label: localizations.rideBookRide,
          ),
        ],
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
