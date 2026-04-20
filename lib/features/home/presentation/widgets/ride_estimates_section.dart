import 'package:flutter/material.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate_response.dart';

class RideEstimatesSection extends StatelessWidget {
  const RideEstimatesSection({
    super.key,
    required this.estimateResponse,
    required this.selectedEstimate,
    required this.onEstimateSelected,
  });

  final RideEstimateResponse estimateResponse;
  final RideEstimate? selectedEstimate;
  final ValueChanged<RideEstimate> onEstimateSelected;

  @override
  Widget build(BuildContext context) {
    final estimates = estimateResponse.estimates;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose your ride', style: AppTextStyles.w600_18),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _TripStat(
              icon: Icons.route_outlined,
              label: '${_formatNumber(estimateResponse.distanceKm)} km',
            ),
            _TripStat(
              icon: Icons.schedule_outlined,
              label: '${_formatNumber(estimateResponse.durationMin)} min',
            ),
            if (estimateResponse.stopsCount > 0)
              _TripStat(
                icon: Icons.alt_route,
                label: '${estimateResponse.stopsCount} stops',
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (estimates.isEmpty)
          Text(
            'No car types are available for this trip right now.',
            style: AppTextStyles.w400_14.copyWith(color: Colors.grey),
          )
        else
          ...estimates.map(
            (estimate) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _RideEstimateTile(
                estimate: estimate,
                isSelected:
                    selectedEstimate?.vehicleTypeId == estimate.vehicleTypeId,
                onTap: () => onEstimateSelected(estimate),
              ),
            ),
          ),
      ],
    );
  }

  static String _formatNumber(double value) {
    if (value.truncateToDouble() == value) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(1);
  }
}

class _TripStat extends StatelessWidget {
  const _TripStat({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.w400_12.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _RideEstimateTile extends StatelessWidget {
  const _RideEstimateTile({
    required this.estimate,
    required this.isSelected,
    required this.onTap,
  });

  final RideEstimate estimate;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.outlineVariant;
    final backgroundColor = isSelected
        ? Color.alphaBlend(
            theme.colorScheme.primary.withAlpha(20),
            theme.colorScheme.surface,
          )
        : theme.colorScheme.surface;

    return Material(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: borderColor),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _VehicleImage(imageUrl: estimate.imageUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      estimate.name.isEmpty ? 'Car type' : estimate.name,
                      style: AppTextStyles.w600_16,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${S.of(context).rideEstimatedPrice}: ${_formatFare(estimate)}',
                      style: AppTextStyles.w400_12.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(_formatFare(estimate), style: AppTextStyles.w600_14),
              const SizedBox(width: 8),
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatFare(RideEstimate estimate) {
    final fare = estimate.estimatedFare;
    final formattedFare = fare.truncateToDouble() == fare
        ? fare.toStringAsFixed(0)
        : fare.toStringAsFixed(2);
    final currency = estimate.currency.trim();

    if (currency.isEmpty) return formattedFare;

    return '$currency $formattedFare';
  }
}

class _VehicleImage extends StatelessWidget {
  const _VehicleImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final url = imageUrl;

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: _hasNetworkImage(url)
          ? Image.network(
              url!,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.directions_car_filled_outlined);
              },
            )
          : const Icon(Icons.directions_car_filled_outlined),
    );
  }

  static bool _hasNetworkImage(String? url) {
    final uri = Uri.tryParse(url ?? '');
    return uri != null && uri.hasScheme && uri.host.isNotEmpty;
  }
}
