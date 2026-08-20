import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/features/coupons/domain/entities/user_coupon_entity.dart';

class CouponCard extends StatelessWidget {
  final UserCouponEntity userCoupon;
  final VoidCallback? onTap;

  const CouponCard({super.key, required this.userCoupon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final coupon = userCoupon.coupon;
    final isActive = userCoupon.isActive;
    final isUsed = userCoupon.isUsed;

    final Color primaryBorder = isActive
        ? AppColors.primaryColor
        : (isUsed ? AppColors.textGrey : AppColors.errorColor);

    final Color statusBg = isActive
        ? AppColors.shieldGreen.withValues(alpha: 0.12)
        : (isUsed
              ? Colors.grey.withValues(alpha: 0.15)
              : AppColors.errorColor.withValues(alpha: 0.12));

    final Color statusTextColor = isActive
        ? AppColors.shieldGreen
        : (isUsed ? AppColors.textGrey : AppColors.errorColor);

    final String statusLabel = isActive
        ? S.of(context).couponStatusActive
        : (isUsed
              ? S.of(context).couponStatusUsed
              : S.of(context).couponStatusExpired);

    final DateTime? effectiveExpiresAt =
        (coupon.expiresAt != null && userCoupon.expiresAt != null)
        ? (coupon.expiresAt!.isBefore(userCoupon.expiresAt!)
              ? coupon.expiresAt
              : userCoupon.expiresAt)
        : (coupon.expiresAt ?? userCoupon.expiresAt);

    final String dateText = effectiveExpiresAt != null
        ? DateFormat('yyyy-MM-dd').format(effectiveExpiresAt)
        : '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isActive
                ? AppColors.primaryColor.withValues(alpha: 0.2)
                : AppColors.borderColor.withValues(alpha: 0.5),
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
              // Decorative left accent border line
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                child: Container(width: 5.w, color: primaryBorder),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 14.w, 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: Discount Value + Status Pill
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
                                color: AppColors.primaryColor.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                coupon.formattedDiscount(
                                  S.of(context).appCurrency,
                                ),
                                style: AppTextStyles.w700_16.copyWith(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6.r),
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
                          ],
                        ),

                        // Status Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            statusLabel,
                            style: AppTextStyles.w600_12.copyWith(
                              color: statusTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    // Name & Description
                    Text(
                      coupon.name,
                      style: AppTextStyles.w600_14.copyWith(
                        color: isActive ? Colors.black87 : AppColors.textGrey,
                      ),
                    ),
                    if (coupon.description != null &&
                        coupon.description!.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        coupon.description!,
                        style: AppTextStyles.w400_12.copyWith(
                          color: AppColors.textGrey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    SizedBox(height: 12.h),
                    const Divider(height: 1, color: AppColors.borderColor),
                    SizedBox(height: 10.h),

                    // Bottom info: Usages + Expiry Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.history_outlined,
                              size: 16.r,
                              color: AppColors.textGrey,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              S
                                  .of(context)
                                  .remainingUsages(userCoupon.remainingUsages),
                              style: AppTextStyles.w400_12.copyWith(
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
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
                                S.of(context).expiresOn(dateText),
                                style: AppTextStyles.w400_12.copyWith(
                                  color: AppColors.textGrey,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
