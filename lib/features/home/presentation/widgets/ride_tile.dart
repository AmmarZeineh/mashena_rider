import 'package:flutter/material.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/features/home/domain/entities/ride_estimate.dart';

class RideTile extends StatelessWidget {
  const RideTile({
    super.key,
    required this.estimate,
    required this.isSelected,
    required this.onTap,
  });

  final RideEstimate estimate;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final localizations = S.of(context);

    final borderColor = isSelected
        ? AppColors.primaryColor
        : AppColors.borderColor;
    final bgColor = isSelected
        ? Color.alphaBlend(
            AppColors.primaryColor.withAlpha(18),
            colorScheme.surface,
          )
        : colorScheme.surface;

    return Material(
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: borderColor, width: isSelected ? 1.5 : 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              VehicleImage(imageUrl: estimate.imageUrl),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      estimate.name.isEmpty
                          ? localizations.ridePersonCapacity
                          : estimate.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      localizations.ridePersonCapacity,
                      style: textTheme.labelMedium?.copyWith(
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatFare(estimate),
                style: textTheme.titleMedium?.copyWith(
                  color: isSelected
                      ? AppColors.primaryColor
                      : colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Formats the fare with its currency symbol.
  static String _formatFare(RideEstimate estimate) {
    final fare = estimate.estimatedFare;
    final formatted = fare.truncateToDouble() == fare
        ? fare.toStringAsFixed(0)
        : fare.toStringAsFixed(2);
    final currency = estimate.currency.trim();
    return currency.isEmpty ? formatted : '$currency $formatted';
  }
}

class VehicleImage extends StatelessWidget {
  const VehicleImage({super.key, required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasUrl = _isNetworkUrl(imageUrl);

    return Container(
      width: 64,
      height: 48,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: hasUrl
          ? Image.network(
              imageUrl!,
              fit: BoxFit.contain,
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
              errorBuilder: (_, _, _) =>
                  const Icon(Icons.directions_car_outlined),
            )
          : const Icon(
              Icons.directions_car_outlined,
              color: AppColors.textGrey,
            ),
    );
  }

  static bool _isNetworkUrl(String? url) {
    final uri = Uri.tryParse(url ?? '');
    return uri != null && uri.hasScheme && uri.host.isNotEmpty;
  }
}
