import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/utils/toast_helper.dart';

class ShareUrlCard extends StatelessWidget {
  const ShareUrlCard({super.key, required this.shareUrl});

  final String shareUrl;

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: shareUrl));
    context.showSuccessToast(S.of(context).shareRideCopied);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final s = S.of(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8.r,
                height: 8.r,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                s.shareRideActive,
                style: AppTextStyles.w600_12.copyWith(color: AppColors.success),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  shareUrl,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.w500_14.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              IconButton.filledTonal(
                onPressed: () => _copyToClipboard(context),
                icon: Icon(
                  Icons.copy_rounded,
                  size: 18.r,
                  color: colorScheme.primary,
                ),
                tooltip: s.shareRideCopied,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
