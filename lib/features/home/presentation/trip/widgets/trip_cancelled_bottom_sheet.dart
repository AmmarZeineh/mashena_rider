import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/home/presentation/common/widgets/custom_drag_handle.dart';

/// A modern design bottom sheet presented when a trip is cancelled by driver or admin.
class TripCancelledBottomSheet extends StatelessWidget {
  const TripCancelledBottomSheet({
    super.key,
    this.cancelledBy,
    this.isExpired = false,
  });

  /// Indicates who cancelled the trip: 'driver', 'admin', or null.
  final String? cancelledBy;

  /// Indicates if the ride request expired due to no driver accepting.
  final bool isExpired;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);

    final String titleText;
    final String subtitleText;
    final IconData iconData;
    final Color emblemColor;

    if (isExpired) {
      titleText = s.rideExpiredTitle;
      subtitleText = s.rideExpiredSubtitle;
      iconData = Icons.timer_off_rounded;
      emblemColor = AppColors.rating;
    } else if (cancelledBy == 'driver') {
      titleText = s.tripCancelledByDriver;
      subtitleText = s.tripCancelledSubtitleDriver;
      iconData = Icons.cancel_rounded;
      emblemColor = AppColors.errorColor;
    } else if (cancelledBy == 'admin') {
      titleText = s.tripCancelledByAdmin;
      subtitleText = s.tripCancelledSubtitleAdmin;
      iconData = Icons.cancel_rounded;
      emblemColor = AppColors.errorColor;
    } else {
      titleText = s.tripCancelled;
      subtitleText = s.tripCancelledSubtitleGeneral;
      iconData = Icons.cancel_rounded;
      emblemColor = AppColors.errorColor;
    }

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 30,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 12.h),
            const CustomDragHandle(),
            SizedBox(height: 24.h),

            // Hero Icon Emblem
            Center(
              child: Container(
                width: 72.r,
                height: 72.r,
                decoration: BoxDecoration(
                  color: emblemColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: emblemColor.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 52.r,
                    height: 52.r,
                    decoration: BoxDecoration(
                      color: emblemColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(iconData, color: AppColors.white, size: 30.r),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Title
            Text(
              titleText,
              textAlign: TextAlign.center,
              style: AppTextStyles.w700_20.copyWith(
                color: colorScheme.onSurface,
                height: 1.2,
              ),
            ),
            SizedBox(height: 8.h),

            // Subtitle
            Text(
              subtitleText,
              textAlign: TextAlign.center,
              style: AppTextStyles.w400_14.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            SizedBox(height: 24.h),

            // Notice Box: No Cancellation Fee
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: AppColors.shieldGreen.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shield_outlined,
                      color: AppColors.shieldGreen,
                      size: 18.r,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      s.noCancellationFeeNotice,
                      style: AppTextStyles.w500_14.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.h),

            // Action Button
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.white,
                elevation: 0,
                minimumSize: Size(double.infinity, 52.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Text(
                s.rideBookRide,
                style: AppTextStyles.w600_16.copyWith(color: AppColors.white),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
