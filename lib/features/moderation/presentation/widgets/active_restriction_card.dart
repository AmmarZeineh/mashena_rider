import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/moderation/domain/entities/restriction_entity.dart';
import 'package:mashena_rider/features/moderation/domain/entities/restriction_type.dart';

class ActiveRestrictionCard extends StatelessWidget {
  final RestrictionEntity restriction;

  const ActiveRestrictionCard({super.key, required this.restriction});

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
    final dateFormat = DateFormat('yyyy/MM/dd HH:mm');

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFF97316).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFF97316).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_clock_rounded,
                  size: 18.r,
                  color: const Color(0xFFEA580C),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  _getRestrictionLabel(context, restriction.restrictionType),
                  style: AppTextStyles.w700_14.copyWith(
                    color: const Color(0xFFC2410C),
                  ),
                ),
              ),
            ],
          ),
          if (restriction.reason.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              restriction.reason,
              style: AppTextStyles.w400_14.copyWith(color: Colors.black87),
            ),
          ],
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 14.r,
                color: AppColors.textGrey,
              ),
              SizedBox(width: 4.w),
              Text(
                restriction.expiresAt != null
                    ? s.moderationExpiresAt(
                        dateFormat.format(restriction.expiresAt!),
                      )
                    : s.moderationPermanentBanNotice,
                style: AppTextStyles.w500_12.copyWith(color: AppColors.textGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
