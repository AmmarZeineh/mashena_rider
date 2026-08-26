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
    switch (status) {
      case UserAccountStatus.active:
        return StatusBadge(
          label: s.moderationStatusActive,
          foregroundColor: const Color(0xFF16A34A),
          backgroundColor: const Color(0xFFDCFCE7),
          icon: Icons.check_circle_outline_rounded,
        );
      case UserAccountStatus.warning:
        return StatusBadge(
          label: s.moderationStatusWarning,
          foregroundColor: const Color(0xFFD97706),
          backgroundColor: const Color(0xFFFEF3C7),
          icon: Icons.warning_amber_rounded,
        );
      case UserAccountStatus.restricted:
        return StatusBadge(
          label: s.moderationStatusRestricted,
          foregroundColor: const Color(0xFFEA580C),
          backgroundColor: const Color(0xFFFFEDD5),
          icon: Icons.lock_outline_rounded,
        );
      case UserAccountStatus.suspended:
        return StatusBadge(
          label: s.moderationStatusSuspended,
          foregroundColor: const Color(0xFFDC2626),
          backgroundColor: const Color(0xFFFEE2E2),
          icon: Icons.pause_circle_outline_rounded,
        );
      case UserAccountStatus.banned:
        return StatusBadge(
          label: s.moderationStatusBanned,
          foregroundColor: const Color(0xFF991B1B),
          backgroundColor: const Color(0xFFFEE2E2),
          icon: Icons.block_rounded,
        );
    }
  }

  factory StatusBadge.fromPenaltyStatus(
    BuildContext context,
    PenaltyStatus status,
  ) {
    final s = S.of(context);
    switch (status) {
      case PenaltyStatus.active:
        return StatusBadge(
          label: s.moderationPenaltyStatusActive,
          foregroundColor: const Color(0xFFDC2626),
          backgroundColor: const Color(0xFFFEE2E2),
          icon: Icons.error_outline_rounded,
        );
      case PenaltyStatus.expired:
        return StatusBadge(
          label: s.moderationPenaltyStatusExpired,
          foregroundColor: const Color(0xFF4B5563),
          backgroundColor: const Color(0xFFF3F4F6),
          icon: Icons.access_time_rounded,
        );
      case PenaltyStatus.revoked:
        return StatusBadge(
          label: s.moderationPenaltyStatusRevoked,
          foregroundColor: const Color(0xFF16A34A),
          backgroundColor: const Color(0xFFDCFCE7),
          icon: Icons.check_circle_outline_rounded,
        );
      case PenaltyStatus.cancelled:
      case PenaltyStatus.unknown:
        return StatusBadge(
          label: s.moderationPenaltyStatusCancelled,
          foregroundColor: const Color(0xFF6B7280),
          backgroundColor: const Color(0xFFF3F4F6),
          icon: Icons.cancel_outlined,
        );
    }
  }

  factory StatusBadge.fromAppealStatus(
    BuildContext context,
    AppealStatus status,
  ) {
    final s = S.of(context);
    switch (status) {
      case AppealStatus.pending:
        return StatusBadge(
          label: s.moderationAppealStatusPending,
          foregroundColor: const Color(0xFFD97706),
          backgroundColor: const Color(0xFFFEF3C7),
          icon: Icons.hourglass_empty_rounded,
        );
      case AppealStatus.underReview:
        return StatusBadge(
          label: s.moderationAppealStatusUnderReview,
          foregroundColor: AppColors.primaryColor,
          backgroundColor: AppColors.primaryColor.withValues(alpha: 0.1),
          icon: Icons.manage_search_rounded,
        );
      case AppealStatus.approved:
        return StatusBadge(
          label: s.moderationAppealStatusApproved,
          foregroundColor: const Color(0xFF16A34A),
          backgroundColor: const Color(0xFFDCFCE7),
          icon: Icons.check_circle_outline_rounded,
        );
      case AppealStatus.rejected:
        return StatusBadge(
          label: s.moderationAppealStatusRejected,
          foregroundColor: const Color(0xFFDC2626),
          backgroundColor: const Color(0xFFFEE2E2),
          icon: Icons.cancel_outlined,
        );
      case AppealStatus.cancelled:
      case AppealStatus.unknown:
        return StatusBadge(
          label: s.moderationAppealStatusCancelled,
          foregroundColor: const Color(0xFF6B7280),
          backgroundColor: const Color(0xFFF3F4F6),
        );
    }
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
