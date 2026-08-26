import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/moderation/domain/entities/appeal_entity.dart';
import 'package:mashena_rider/features/moderation/presentation/widgets/status_badge.dart';

class AppealDetailsBottomSheet extends StatelessWidget {
  final AppealEntity appeal;

  const AppealDetailsBottomSheet({super.key, required this.appeal});

  static Future<void> show(BuildContext context, AppealEntity appeal) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AppealDetailsBottomSheet(appeal: appeal),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final dateFormat = DateFormat('yyyy/MM/dd HH:mm');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top drag handle
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.borderColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.moderationAppealRef(appeal.id),
                        style: AppTextStyles.w700_20,
                      ),
                      Text(
                        s.moderationPenaltyRef(appeal.penaltyId),
                        style: AppTextStyles.w500_12.copyWith(
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge.fromAppealStatus(context, appeal.status),
              ],
            ),
            SizedBox(height: 16.h),

            // Submission Reason
            Text(s.moderationAppealReason, style: AppTextStyles.w600_14),
            SizedBox(height: 6.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Text(
                appeal.reason,
                style: AppTextStyles.w400_14.copyWith(
                  color: Colors.black87,
                  height: 1.35,
                ),
              ),
            ),

            if (appeal.evidence != null && appeal.evidence!.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Text(s.moderationAppealEvidence, style: AppTextStyles.w600_14),
              SizedBox(height: 6.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.link,
                      size: 16,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        appeal.evidence!,
                        style: AppTextStyles.w500_12.copyWith(
                          color: AppColors.primaryColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Admin Decision Section (if reviewed)
            if (appeal.adminDecision != null &&
                appeal.adminDecision!.isNotEmpty) ...[
              SizedBox(height: 16.h),
              Text(s.moderationAdminDecision, style: AppTextStyles.w600_14),
              SizedBox(height: 6.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: appeal.status.isApproved
                      ? const Color(0xFFF0FDF4)
                      : const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: appeal.status.isApproved
                        ? const Color(0xFF86EFAC)
                        : const Color(0xFFFECACA),
                  ),
                ),
                child: Text(
                  appeal.adminDecision!,
                  style: AppTextStyles.w500_14.copyWith(
                    color: appeal.status.isApproved
                        ? const Color(0xFF15803D)
                        : const Color(0xFFB91C1C),
                  ),
                ),
              ),
            ],

            if (appeal.adminNotes != null && appeal.adminNotes!.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Text(s.moderationAdminNotes, style: AppTextStyles.w600_14),
              SizedBox(height: 6.h),
              Text(
                appeal.adminNotes!,
                style: AppTextStyles.w400_14.copyWith(
                  color: AppColors.textGrey,
                ),
              ),
            ],

            SizedBox(height: 16.h),
            const Divider(color: Color(0xFFF3F4F6)),
            SizedBox(height: 10.h),

            // Timeline details
            if (appeal.submittedAt != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: 14.r,
                    color: AppColors.textGrey,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    s.moderationSubmittedAt(
                      dateFormat.format(appeal.submittedAt!),
                    ),
                    style: AppTextStyles.w500_12.copyWith(
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
            ],
            if (appeal.reviewedAt != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 14.r,
                    color: AppColors.textGrey,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    s.moderationReviewedAt(
                      dateFormat.format(appeal.reviewedAt!),
                    ),
                    style: AppTextStyles.w500_12.copyWith(
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ],

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
