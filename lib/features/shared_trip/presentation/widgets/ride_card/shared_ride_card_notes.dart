import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';

class SharedRideCardNotes extends StatelessWidget {
  final String? notes;

  const SharedRideCardNotes({super.key, this.notes});

  @override
  Widget build(BuildContext context) {
    final trimmed = notes?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark
        ? Colors.amber.shade900.withValues(alpha: 0.18)
        : Colors.amber.shade50;
    final borderColor = isDark
        ? Colors.amber.shade700.withValues(alpha: 0.35)
        : Colors.amber.shade200;
    final textColor = isDark ? Colors.amber.shade200 : Colors.amber.shade900;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: borderColor, width: 0.8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.info_outline_rounded, size: 14.r, color: textColor),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                trimmed,
                style: AppTextStyles.w500_12.copyWith(color: textColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
