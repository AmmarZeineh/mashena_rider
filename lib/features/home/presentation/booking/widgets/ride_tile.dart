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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        estimate.name.isEmpty
                            ? localizations.ridePersonCapacity
                            : estimate.name,
                        style: AppTextStyles.w700_16.copyWith(
                          color: isSelected
                              ? AppColors.primaryColor
                              : colorScheme.onSurface,
                        ),
                      ),
                      if (estimate.hasDiscount &&
                          estimate.appliedCoupon != null) ...[
                        SizedBox(height: 4.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.local_offer_rounded,
                                size: 11.sp,
                                color: AppColors.primaryColor,
                              ),
                              SizedBox(width: 4.w),
                              Flexible(
                                child: Text(
                                  estimate.appliedCoupon!.code,
                                  style: AppTextStyles.w600_10.copyWith(
                                    color: AppColors.primaryColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else if (estimate.hasDiscount &&
                          estimate.effectiveDiscountAmount > 0) ...[
                        SizedBox(height: 4.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            '-${_formatAmount(estimate.effectiveDiscountAmount, estimate.currency)}',
                            style: AppTextStyles.w600_10.copyWith(
                              color: Colors.green.shade700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (estimate.hasDiscount) ...[
                      Text(
                        _formatAmount(
                          estimate.displayOriginalFare,
                          estimate.currency,
                        ),
                        style: AppTextStyles.w500_12.copyWith(
                          color: colorScheme.outline,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: colorScheme.outline,
                        ),
                      ),
                      SizedBox(height: 2.h),
                    ],
                    Text(
                      _formatAmount(
                        estimate.displayFinalFare,
                        estimate.currency,
                      ),
                      style: AppTextStyles.w700_18.copyWith(
                        color: estimate.hasDiscount
                            ? (isSelected
                                  ? AppColors.primaryColor
                                  : colorScheme.primary)
                            : colorScheme.onSurface,
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

  static String _formatAmount(double fare, String currency) {
    final formatted = fare.truncateToDouble() == fare
        ? fare.toStringAsFixed(0)
        : fare.toStringAsFixed(2);
    final trimmed = currency.trim();
    return trimmed.isEmpty ? formatted : '$trimmed $formatted';
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
