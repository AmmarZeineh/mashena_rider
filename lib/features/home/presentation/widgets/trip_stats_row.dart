import 'package:flutter/material.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate_response.dart';

class TripStatsRow extends StatelessWidget {
  const TripStatsRow({super.key, required this.response});

  final RideEstimateResponse response;

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        StatChip(
          icon: Icons.route_outlined,
          label: localizations.rideDistanceKm(_formatNum(response.distanceKm)),
        ),
        StatChip(
          icon: Icons.schedule_outlined,
          label: localizations.rideDurationMin(
            _formatNum(response.durationMin),
          ),
        ),
        if (response.stopsCount > 0)
          StatChip(
            icon: Icons.alt_route,
            label: localizations.rideStopsCount(response.stopsCount),
          ),
      ],
    );
  }

  /// Formats a [double] without a trailing `.0`.
  static String _formatNum(double value) => value.truncateToDouble() == value
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);
}

class StatChip extends StatelessWidget {
  const StatChip({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 5),
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
