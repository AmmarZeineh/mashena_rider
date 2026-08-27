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
    final s = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final coupon = historyItem.userCoupon.coupon;
    final locale = Localizations.localeOf(context).toString();

    final String dateText = historyItem.createdAt != null
        ? '${DateFormat.yMMMd(locale).format(historyItem.createdAt!)} • ${DateFormat.jm(locale).format(historyItem.createdAt!)}'
        : '';

    final cardBg = isDark
        ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.7)
        : AppColors.white;

    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.25)
        : AppColors.borderColor.withValues(alpha: 0.5);

    final secondaryTextColor =
        isDark ? colorScheme.onSurfaceVariant : AppColors.textGrey;

    final fareBoxBg = isDark
        ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.35)
        : AppColors.lightScaffold;

    final fareBoxBorder = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.2)
        : AppColors.borderColor.withValues(alpha: 0.4);

    final accentLineColor =
        isDark ? colorScheme.outlineVariant : AppColors.textGrey;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            // Directional start gray accent line for history item
            PositionedDirectional(
              top: 0,
              bottom: 0,
              start: 0,
              child: Container(width: 5.w, color: accentLineColor),
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
                              color: isDark
                                  ? colorScheme.surfaceContainerHighest
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: isDark
                                    ? colorScheme.outlineVariant.withValues(
                                        alpha: 0.3,
                                      )
                                    : AppColors.borderColor,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              coupon.code,
                              style: AppTextStyles.w700_12.copyWith(
                                color: colorScheme.onSurface,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            coupon.name,
                            style: AppTextStyles.w600_14.copyWith(
                              color: secondaryTextColor,
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
                          color: isDark
                              ? colorScheme.surfaceContainerHighest
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          s.couponStatusUsed,
                          style: AppTextStyles.w600_12.copyWith(
                            color: secondaryTextColor,
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
                      color: fareBoxBg,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: fareBoxBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.couponOriginalFare,
                              style: AppTextStyles.w400_12.copyWith(
                                color: secondaryTextColor,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              '${historyItem.originalFare.toStringAsFixed(0)} ${s.appCurrency}',
                              style: AppTextStyles.w600_14.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              s.couponSaved,
                              style: AppTextStyles.w400_12.copyWith(
                                color: AppColors.shieldGreen,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              '-${historyItem.discountAmount.toStringAsFixed(0)} ${s.appCurrency}',
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
                              s.couponFinalFare,
                              style: AppTextStyles.w400_12.copyWith(
                                color: secondaryTextColor,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              '${historyItem.finalFare.toStringAsFixed(0)} ${s.appCurrency}',
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
                          color: secondaryTextColor,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          dateText,
                          style: AppTextStyles.w400_12.copyWith(
                            color: secondaryTextColor,
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
