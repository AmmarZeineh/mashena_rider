import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/moderation/domain/entities/user_account_status.dart';
import 'package:mashena_rider/features/moderation/presentation/widgets/status_badge.dart';

class AccountStatusCard extends StatelessWidget {
  final UserAccountStatus accountStatus;

  const AccountStatusCard({super.key, required this.accountStatus});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    final (shieldColor, lightGradStart, icon) = switch (accountStatus) {
      UserAccountStatus.active => (
        AppColors.shieldGreen,
        const Color(0xFFF0FDF4),
        Icons.verified_user_rounded,
      ),
      UserAccountStatus.warning => (
        const Color(0xFFD97706),
        const Color(0xFFFFFBEB),
        Icons.warning_rounded,
      ),
      UserAccountStatus.restricted => (
        const Color(0xFFEA580C),
        const Color(0xFFFFF7ED),
        Icons.gpp_maybe_rounded,
      ),
      UserAccountStatus.suspended => (
        AppColors.errorColor,
        const Color(0xFFFEF2F2),
        Icons.gpp_bad_rounded,
      ),
      UserAccountStatus.banned => (
        const Color(0xFF991B1B),
        const Color(0xFFFEF2F2),
        Icons.block_rounded,
      ),
    };

    final bgGradStart = isDark
        ? shieldColor.withValues(alpha: 0.18)
        : lightGradStart;
    final bgGradEnd = isDark
        ? colorScheme.surfaceContainerHigh
        : Colors.white;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bgGradStart, bgGradEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: shieldColor.withValues(alpha: isDark ? 0.35 : 0.25),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : shieldColor.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: shieldColor.withValues(alpha: isDark ? 0.2 : 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: shieldColor, size: 28.r),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.moderationAccountStatus,
                  style: AppTextStyles.w500_12.copyWith(
                    color: isDark
                        ? colorScheme.onSurfaceVariant
                        : AppColors.textGrey,
                  ),
                ),
                SizedBox(height: 4.h),
                StatusBadge.fromAccountStatus(context, accountStatus),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
