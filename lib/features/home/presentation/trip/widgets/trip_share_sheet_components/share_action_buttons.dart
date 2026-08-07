import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/utils/toast_helper.dart';
import 'package:share_plus/share_plus.dart';

class ShareActionButtons extends StatelessWidget {
  const ShareActionButtons({
    super.key,
    required this.shareUrl,
    required this.onRevokePressed,
    this.isRevoking = false,
  });

  final String shareUrl;
  final VoidCallback onRevokePressed;
  final bool isRevoking;

  Future<void> _shareViaNative(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    final Rect? sharePositionOrigin = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : null;

    final String messageText = '${S.of(context).shareRideSubtitle}:\n$shareUrl';

    try {
      await Share.share(
        messageText,
        subject: S.of(context).shareRide,
        sharePositionOrigin: sharePositionOrigin,
      );
    } catch (_) {
      if (!context.mounted) return;
      context.showErrorToast(S.of(context).shareRideFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final s = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () => _shareViaNative(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: AppColors.white,
            elevation: 0,
            minimumSize: Size(double.infinity, 52.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          icon: Icon(Icons.share_rounded, size: 20.r, color: AppColors.white),
          label: Text(
            s.shareRideShareVia,
            style: AppTextStyles.w600_16.copyWith(color: AppColors.white),
          ),
        ),
        SizedBox(height: 12.h),
        OutlinedButton.icon(
          onPressed: isRevoking ? null : onRevokePressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.errorColor,
            side: BorderSide(
              color: AppColors.errorColor.withValues(alpha: 0.5),
            ),
            minimumSize: Size(double.infinity, 52.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          icon: isRevoking
              ? SizedBox(
                  width: 18.r,
                  height: 18.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.r,
                    color: AppColors.errorColor,
                  ),
                )
              : Icon(
                  Icons.link_off_rounded,
                  size: 20.r,
                  color: AppColors.errorColor,
                ),
          label: Text(
            isRevoking ? s.shareRideRevoking : s.shareRideRevoke,
            style: AppTextStyles.w600_16.copyWith(color: AppColors.errorColor),
          ),
        ),
      ],
    );
  }
}
