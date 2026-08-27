import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/moderation/domain/entities/penalty_entity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/penalty_type.dart';
import 'package:mashena_rider/features/moderation/domain/entities/restriction_type.dart';
import 'package:mashena_rider/features/moderation/presentation/widgets/severity_badge.dart';
import 'package:mashena_rider/features/moderation/presentation/widgets/status_badge.dart';

class PenaltyCard extends StatelessWidget {
  final PenaltyEntity penalty;
  final VoidCallback? onAppealTap;

  const PenaltyCard({super.key, required this.penalty, this.onAppealTap});

  String _getPenaltyTypeLabel(BuildContext context, PenaltyType type) {
    final s = S.of(context);
    switch (type) {
      case PenaltyType.warning:
        return s.moderationPenaltyTypeWarning;
      case PenaltyType.temporarySuspension:
        return s.moderationPenaltyTypeSuspension;
      case PenaltyType.permanentBan:
        return s.moderationPenaltyTypeBan;
      case PenaltyType.featureRestriction:
        return s.moderationPenaltyTypeFeatureRestriction;
      case PenaltyType.accountRestriction:
        return s.moderationPenaltyTypeAccountRestriction;
      case PenaltyType.unknown:
        return s.moderationPenaltyTypeWarning;
    }
  }

  String _getRestrictionLabel(BuildContext context, RestrictionType type) {
    final s = S.of(context);
    switch (type) {
      case RestrictionType.requestRide:
        return s.moderationRestrictionRequestRide;
      case RestrictionType.joinSharedRide:
        return s.moderationRestrictionJoinSharedRide;
      case RestrictionType.joinPassengerPool:
        return s.moderationRestrictionJoinPassengerPool;
      case RestrictionType.walletTransfer:
        return s.moderationRestrictionWalletTransfer;
      case RestrictionType.payment:
        return s.moderationRestrictionPayment;
      case RestrictionType.fullAccount:
        return s.moderationRestrictionFullAccount;
      case RestrictionType.unknown:
        return s.moderationStatusRestricted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    final dateFormat = DateFormat('yyyy/MM/dd HH:mm');

    final cardBg = isDark
        ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.7)
        : Colors.white;
    final borderColor = penalty.isAppealable
        ? AppColors.errorColor.withValues(alpha: isDark ? 0.5 : 0.3)
        : (isDark
            ? colorScheme.outlineVariant.withValues(alpha: 0.25)
            : AppColors.borderColor.withValues(alpha: 0.6));
    final timeColor = isDark
        ? colorScheme.onSurfaceVariant
        : AppColors.textGrey;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Type, Severity, and Status
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      _getPenaltyTypeLabel(context, penalty.penaltyType),
                      style: AppTextStyles.w700_16.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    SeverityBadge(severity: penalty.severity),
                  ],
                ),
              ),
              StatusBadge.fromPenaltyStatus(context, penalty.status),
            ],
          ),

          if (penalty.reason.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Text(
              penalty.reason,
              style: AppTextStyles.w400_14.copyWith(
                color: colorScheme.onSurface,
                height: 1.35,
              ),
            ),
          ],

          // Attached restrictions
          if (penalty.restrictions.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: penalty.restrictions.map((r) {
                final badgeBg = isDark
                    ? colorScheme.surfaceContainerLow
                    : const Color(0xFFFFEDD5);
                final badgeFg = isDark
                    ? const Color(0xFFFB923C)
                    : const Color(0xFFC2410C);

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 12.r,
                        color: badgeFg,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _getRestrictionLabel(context, r.restrictionType),
                        style: AppTextStyles.w600_12.copyWith(
                          color: badgeFg,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],

          SizedBox(height: 12.h),
          Divider(
            height: 1,
            color: isDark
                ? colorScheme.outlineVariant.withValues(alpha: 0.2)
                : const Color(0xFFF3F4F6),
          ),
          SizedBox(height: 10.h),

          // Date & Actions footer
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 14.r,
                color: timeColor,
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  penalty.expiresAt != null
                      ? s.moderationExpiresAt(
                          dateFormat.format(penalty.expiresAt!),
                        )
                      : s.moderationPermanentBanNotice,
                  style: AppTextStyles.w500_12.copyWith(
                    color: timeColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (penalty.isAppealable && onAppealTap != null)
                TextButton.icon(
                  onPressed: onAppealTap,
                  icon: const Icon(Icons.campaign_outlined, size: 16),
                  label: Text(
                    s.moderationSubmitAppeal,
                    style: AppTextStyles.w600_12.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    visualDensity: VisualDensity.compact,
                    backgroundColor: AppColors.primaryColor.withValues(
                      alpha: isDark ? 0.15 : 0.08,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
