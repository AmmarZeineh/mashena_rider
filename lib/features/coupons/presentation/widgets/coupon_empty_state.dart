import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';

class CouponEmptyState extends StatelessWidget {
  final String emptyMessage;

  const CouponEmptyState({super.key, required this.emptyMessage});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final textColor =
        isDark ? colorScheme.onSurfaceVariant : AppColors.textGrey;
    final iconColor = isDark
        ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6)
        : AppColors.textGrey.withValues(alpha: 0.5);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.confirmation_number_outlined,
            size: 64.r,
            color: iconColor,
          ),
          SizedBox(height: 12.h),
          Text(
            emptyMessage,
            style: AppTextStyles.w400_14.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}
