import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = S.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: isSelected
                  ? AppColors.primaryColor.withValues(alpha: 0.08)
                  : colorScheme.surface,
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.borderColor.withValues(alpha: 0.5),
                width: isSelected ? 2.w : 1.w,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primaryColor.withValues(alpha: 0.1),
                        blurRadius: 12.r,
                        offset: Offset(0, 4.h),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              children: [
                // Vehicle Image with background
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.all(8.w),
                  child: VehicleImage(imageUrl: estimate.imageUrl),
                ),
                SizedBox(width: 16.w),
                // Info
                Expanded(
                  child: Text(
                    estimate.name.isEmpty
                        ? localizations.ridePersonCapacity
                        : estimate.name,
                    style: AppTextStyles.w700_16.copyWith(
                      color: isSelected
                          ? AppColors.primaryColor
                          : colorScheme.onSurface,
                    ),
                  ),
                ),
                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatFare(estimate),
                      style: AppTextStyles.w700_18.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (isSelected)
                      Container(
                        margin: EdgeInsets.only(top: 4.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          localizations.commonSelected.toUpperCase(),
                          style: AppTextStyles.w700_12.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
    final hasUrl = _isNetworkUrl(imageUrl);

    return Center(
      child: hasUrl
          ? Image.network(
              imageUrl!,
              fit: BoxFit.contain,
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return Center(
                  child: SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.w,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                );
              },
              errorBuilder: (_, _, _) =>
                  Icon(Icons.directions_car_filled_rounded, size: 32.r),
            )
          : Icon(
              Icons.directions_car_filled_rounded,
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              size: 32.r,
            ),
    );
  }

  static bool _isNetworkUrl(String? url) {
    final uri = Uri.tryParse(url ?? '');
    return uri != null && uri.hasScheme && uri.host.isNotEmpty;
  }
}
