import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/coupons/domain/entities/coupon_history_item_entity.dart';

class CouponHistoryCard extends StatelessWidget {
  final CouponHistoryItemEntity historyItem;

  const CouponHistoryCard({super.key, required this.historyItem});

  @override
  Widget build(BuildContext context) {
    final coupon = historyItem.userCoupon.coupon;
    final String dateText = historyItem.createdAt != null
        ? DateFormat('yyyy-MM-dd HH:mm').format(historyItem.createdAt!)
        : '';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            // Left gray accent line for history item
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: Container(width: 5.w, color: AppColors.textGrey),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 14.w, 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Code + Name + Status Pill
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: AppColors.borderColor,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              coupon.code,
                              style: AppTextStyles.w700_12.copyWith(
                                color: Colors.black87,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            coupon.name,
                            style: AppTextStyles.w600_14.copyWith(
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          S.of(context).couponStatusUsed,
                          style: AppTextStyles.w600_12.copyWith(
                            color: AppColors.textGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Fare discount details row
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: AppColors.lightScaffold,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Original Fare',
                              style: AppTextStyles.w400_12.copyWith(
                                color: AppColors.textGrey,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              '${historyItem.originalFare.toStringAsFixed(0)} ${S.of(context).appCurrency}',
                              style: AppTextStyles.w600_14.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Saved',
                              style: AppTextStyles.w400_12.copyWith(
                                color: AppColors.shieldGreen,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              '-${historyItem.discountAmount.toStringAsFixed(0)} ${S.of(context).appCurrency}',
                              style: AppTextStyles.w700_14.copyWith(
                                color: AppColors.shieldGreen,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Final Fare',
                              style: AppTextStyles.w400_12.copyWith(
                                color: AppColors.textGrey,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              '${historyItem.finalFare.toStringAsFixed(0)} ${S.of(context).appCurrency}',
                              style: AppTextStyles.w700_14.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Used date row
                  if (dateText.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_outlined,
                          size: 16.r,
                          color: AppColors.textGrey,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          dateText,
                          style: AppTextStyles.w400_12.copyWith(
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
