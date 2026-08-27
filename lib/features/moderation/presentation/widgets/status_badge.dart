import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/moderation/domain/entities/appeal_status.dart';
import 'package:mashena_rider/features/moderation/domain/entities/penalty_status.dart';
import 'package:mashena_rider/features/moderation/domain/entities/user_account_status.dart';

/// Reusable badge displaying various domain statuses with distinct themed colors.
class StatusBadge extends StatelessWidget {
  final String label;
  final Color foregroundColor;
  final Color backgroundColor;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
    this.icon,
  });

  factory StatusBadge.fromAccountStatus(
    BuildContext context,
    UserAccountStatus status,
  ) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final (label, fg, lightBg, icon) = switch (status) {
      UserAccountStatus.active => (
        s.moderationStatusActive,
        isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A),
        const Color(0xFFDCFCE7),
        Icons.check_circle_outline_rounded,
      ),
      UserAccountStatus.warning => (
        s.moderationStatusWarning,
        isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
        const Color(0xFFFEF3C7),
        Icons.warning_amber_rounded,
      ),
      UserAccountStatus.restricted => (
        s.moderationStatusRestricted,
        isDark ? const Color(0xFFFB923C) : const Color(0xFFEA580C),
        const Color(0xFFFFEDD5),
        Icons.lock_outline_rounded,
      ),
      UserAccountStatus.suspended => (
        s.moderationStatusSuspended,
        isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
        const Color(0xFFFEE2E2),
        Icons.pause_circle_outline_rounded,
      ),
      UserAccountStatus.banned => (
        s.moderationStatusBanned,
        isDark ? const Color(0xFFFCA5A5) : const Color(0xFF991B1B),
        const Color(0xFFFEE2E2),
        Icons.block_rounded,
      ),
    };

    return StatusBadge(
      label: label,
      foregroundColor: fg,
      backgroundColor: isDark ? fg.withValues(alpha: 0.18) : lightBg,
      icon: icon,
    );
  }

  factory StatusBadge.fromPenaltyStatus(
    BuildContext context,
    PenaltyStatus status,
  ) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final (label, fg, lightBg, icon) = switch (status) {
      PenaltyStatus.active => (
        s.moderationPenaltyStatusActive,
        isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
        const Color(0xFFFEE2E2),
        Icons.error_outline_rounded,
      ),
      PenaltyStatus.expired => (
        s.moderationPenaltyStatusExpired,
        isDark ? const Color(0xFF9CA3AF) : const Color(0xFF4B5563),
        const Color(0xFFF3F4F6),
        Icons.access_time_rounded,
      ),
      PenaltyStatus.revoked => (
        s.moderationPenaltyStatusRevoked,
        isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A),
        const Color(0xFFDCFCE7),
        Icons.check_circle_outline_rounded,
      ),
      PenaltyStatus.cancelled || PenaltyStatus.unknown => (
        s.moderationPenaltyStatusCancelled,
        isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
        const Color(0xFFF3F4F6),
        Icons.cancel_outlined,
      ),
    };

    return StatusBadge(
      label: label,
      foregroundColor: fg,
      backgroundColor: isDark ? fg.withValues(alpha: 0.18) : lightBg,
      icon: icon,
    );
  }

  factory StatusBadge.fromAppealStatus(
    BuildContext context,
    AppealStatus status,
  ) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final (label, fg, lightBg, icon) = switch (status) {
      AppealStatus.pending => (
        s.moderationAppealStatusPending,
        isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
        const Color(0xFFFEF3C7),
        Icons.hourglass_empty_rounded,
      ),
      AppealStatus.underReview => (
        s.moderationAppealStatusUnderReview,
        AppColors.primaryColor,
        AppColors.primaryColor.withValues(alpha: 0.1),
        Icons.manage_search_rounded,
      ),
      AppealStatus.approved => (
        s.moderationAppealStatusApproved,
        isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A),
        const Color(0xFFDCFCE7),
        Icons.check_circle_outline_rounded,
      ),
      AppealStatus.rejected => (
        s.moderationAppealStatusRejected,
        isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
        const Color(0xFFFEE2E2),
        Icons.cancel_outlined,
      ),
      AppealStatus.cancelled || AppealStatus.unknown => (
        s.moderationAppealStatusCancelled,
        isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
        const Color(0xFFF3F4F6),
        null,
      ),
    };

    return StatusBadge(
      label: label,
      foregroundColor: fg,
      backgroundColor: isDark ? fg.withValues(alpha: 0.18) : lightBg,
      icon: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13.r, color: foregroundColor),
            SizedBox(width: 4.w),
          ],
          Text(
            label,
            style: AppTextStyles.w600_12.copyWith(
              color: foregroundColor,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
