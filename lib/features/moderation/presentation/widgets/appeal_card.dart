import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/moderation/domain/entities/appeal_entity.dart';
import 'package:mashena_rider/features/moderation/presentation/widgets/status_badge.dart';

class AppealCard extends StatelessWidget {
  final AppealEntity appeal;
  final VoidCallback? onTap;

  const AppealCard({super.key, required this.appeal, this.onTap});

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
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.25)
        : AppColors.borderColor.withValues(alpha: 0.6);
    final timeColor = isDark
        ? colorScheme.onSurfaceVariant
        : AppColors.textGrey;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      s.moderationAppealRef(appeal.id),
                      style: AppTextStyles.w700_16.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? colorScheme.surfaceContainerLow
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        s.moderationPenaltyRef(appeal.penaltyId),
                        style: AppTextStyles.w500_12.copyWith(
                          color: timeColor,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                    const Spacer(),
                    StatusBadge.fromAppealStatus(context, appeal.status),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  appeal.reason,
                  style: AppTextStyles.w400_14.copyWith(
                    color: colorScheme.onSurface,
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (appeal.adminDecision != null &&
                    appeal.adminDecision!.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: isDark
                          ? (appeal.status.isApproved
                              ? const Color(0xFF14532D).withValues(alpha: 0.3)
                              : const Color(0xFF7F1D1D).withValues(alpha: 0.3))
                          : (appeal.status.isApproved
                              ? const Color(0xFFF0FDF4)
                              : const Color(0xFFFEF2F2)),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          appeal.status.isApproved
                              ? Icons.check_circle_outline
                              : Icons.info_outline,
                          size: 16.r,
                          color: appeal.status.isApproved
                              ? (isDark
                                  ? const Color(0xFF4ADE80)
                                  : const Color(0xFF16A34A))
                              : (isDark
                                  ? const Color(0xFFF87171)
                                  : AppColors.errorColor),
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            appeal.adminDecision!,
                            style: AppTextStyles.w500_12.copyWith(
                              color: appeal.status.isApproved
                                  ? (isDark
                                      ? const Color(0xFF4ADE80)
                                      : const Color(0xFF15803D))
                                  : (isDark
                                      ? const Color(0xFFF87171)
                                      : const Color(0xFFB91C1C)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 13.r,
                      color: timeColor,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      appeal.submittedAt != null
                          ? s.moderationSubmittedAt(
                              dateFormat.format(appeal.submittedAt!),
                            )
                          : '',
                      style: AppTextStyles.w500_12.copyWith(
                        color: timeColor,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: timeColor,
                      size: 18.r,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
