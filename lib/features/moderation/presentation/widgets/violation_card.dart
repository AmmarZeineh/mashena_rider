import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/moderation/domain/entities/violation_entity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/violation_type.dart';
import 'package:mashena_rider/features/moderation/presentation/widgets/severity_badge.dart';

class ViolationCard extends StatelessWidget {
  final ViolationEntity violation;

  const ViolationCard({super.key, required this.violation});

  String _getViolationTypeLabel(BuildContext context, ViolationType type) {
    final s = S.of(context);
    switch (type) {
      case ViolationType.riderTripCancellation:
        return s.moderationViolationRiderTripCancellation;
      case ViolationType.noShow:
        return s.moderationViolationNoShow;
      case ViolationType.lateCancellation:
        return s.moderationViolationLateCancellation;
      case ViolationType.sharedRideMisuse:
        return s.moderationViolationSharedRideMisuse;
      case ViolationType.passengerPoolMisuse:
        return s.moderationViolationPassengerPoolMisuse;
      case ViolationType.paymentAbuse:
        return s.moderationViolationPaymentAbuse;
      case ViolationType.walletAbuse:
        return s.moderationViolationWalletAbuse;
      case ViolationType.abusiveBehavior:
        return s.moderationViolationAbusiveBehavior;
      case ViolationType.fraud:
        return s.moderationViolationFraud;
      case ViolationType.manualAdminViolation:
        return s.moderationViolationManualAdmin;
      case ViolationType.unknown:
        return s.moderationViolationManualAdmin;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy/MM/dd HH:mm');

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _getViolationTypeLabel(context, violation.violationType),
                  style: AppTextStyles.w700_16.copyWith(color: Colors.black87),
                ),
              ),
              SeverityBadge(severity: violation.severity),
            ],
          ),
          if (violation.description.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              violation.description,
              style: AppTextStyles.w400_14.copyWith(
                color: Colors.black87,
                height: 1.35,
              ),
            ),
          ],
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 13.r,
                color: AppColors.textGrey,
              ),
              SizedBox(width: 4.w),
              Text(
                violation.occurredAt != null
                    ? dateFormat.format(violation.occurredAt!)
                    : (violation.createdAt != null
                          ? dateFormat.format(violation.createdAt!)
                          : ''),
                style: AppTextStyles.w500_12.copyWith(color: AppColors.textGrey),
              ),
              if (violation.sourceType != null &&
                  violation.sourceId != null) ...[
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    '${violation.sourceType} #${violation.sourceId}',
                    style: AppTextStyles.w500_12.copyWith(
                      color: AppColors.textGrey,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
