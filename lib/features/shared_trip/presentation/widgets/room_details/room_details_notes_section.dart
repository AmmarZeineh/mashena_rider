import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';

class RoomDetailsNotesSection extends StatelessWidget {
  final String? notes;

  const RoomDetailsNotesSection({super.key, this.notes});

  @override
  Widget build(BuildContext context) {
    if (notes == null || notes!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final s = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: isDark ? 0.12 : 0.04),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: isDark ? 0.35 : 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 18.r,
                color: AppColors.primaryColor,
              ),
              SizedBox(width: 8.w),
              Text(
                s.sharedTripDriverNotes,
                style: AppTextStyles.w600_14.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            notes!,
            style: AppTextStyles.w500_14.copyWith(
              color: colorScheme.onSurface,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
