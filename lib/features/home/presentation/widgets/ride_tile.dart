import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final localizations = S.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: 220.w, // Wider for horizontal layout
      margin: EdgeInsets.symmetric(vertical: 8.h),
      transform: isSelected
          ? Matrix4.diagonal3Values(1.02, 1.02, 1.0)
          : Matrix4.identity(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: isSelected
                  ? colorScheme.primaryContainer
                  : colorScheme.surface,
              gradient: isSelected
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primaryContainer,
                        colorScheme.primaryContainer.withValues(alpha: 0.8),
                      ],
                    )
                  : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.15),
                        blurRadius: 10.r,
                        offset: Offset(0, 4.h),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6.r,
                        offset: Offset(0, 2.h),
                      ),
                    ],
              border: Border.all(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                width: 1.5.w,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                // Car Image - Larger
                VehicleImage(imageUrl: estimate.imageUrl),
                SizedBox(width: 12.w),
                // Info Column
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        estimate.name.isEmpty
                            ? localizations.ridePersonCapacity
                            : estimate.name,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: isSelected
                              ? colorScheme.onPrimaryContainer
                              : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _formatFare(estimate),
                        style: textTheme.titleMedium?.copyWith(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
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

    return Container(
      width: 80.w, // Increased size
      height: 60.h, // Increased size
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(),
      child: hasUrl
          ? Image.network(
              imageUrl!,
              fit: BoxFit.contain,
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return Center(
                  child: SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: CircularProgressIndicator(strokeWidth: 2.w),
                  ),
                );
              },
              errorBuilder: (_, _, _) =>
                  Icon(Icons.directions_car_outlined, size: 40.r),
            )
          : Icon(
              Icons.directions_car_outlined,
              color: AppColors.textGrey,
              size: 40.r,
            ),
    );
  }

  static bool _isNetworkUrl(String? url) {
    final uri = Uri.tryParse(url ?? '');
    return uri != null && uri.hasScheme && uri.host.isNotEmpty;
  }
}
