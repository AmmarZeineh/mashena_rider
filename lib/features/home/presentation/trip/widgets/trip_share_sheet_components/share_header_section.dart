import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';

class ShareHeaderSection extends StatelessWidget {
  const ShareHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final s = S.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
            width: 64.r,
            height: 64.r,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Center(
              child: Container(
                width: 46.r,
                height: 46.r,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.share_location_rounded,
                  color: AppColors.white,
                  size: 24.r,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          s.shareRide,
          textAlign: TextAlign.center,
          style: AppTextStyles.w700_20.copyWith(
            color: colorScheme.onSurface,
            height: 1.2,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          s.shareRideSubtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.w400_14.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
